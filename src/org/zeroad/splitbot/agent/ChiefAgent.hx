/*
	this file is part of SplitBot
	SplitBot: an attempt to a better AI in 0ad - see http://code.google.com/p/split-bot/

	SplitBot is (c) 2011-2012 Alexandre Hoyau and is released under the GPL License:

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License (GPL)
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.
	
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package org.zeroad.splitbot.agent;

import org.zeroad.common_api.BaseAI;
import org.zeroad.common_api.ResourceSupply;
import org.zeroad.splitbot.agent.Agent;
import org.zeroad.common_api.Entity;
import org.zeroad.common_api.EntityCollection;
import org.zeroad.common_api.EntityTypeValues;
import org.zeroad.common_api.Utils;
import org.zeroad.splitbot.core.Point;
import org.zeroad.splitbot.core.Sequencer;
import org.zeroad.splitbot.core.Statistic;
import org.zeroad.splitbot.helper.MapHelper;
import org.zeroad.splitbot.helper.Debug0AD;
import org.zeroad.splitbot.helper.EntityHelper;

/**
 * this agent is a parent to other agents, 
 * it is in charge of distributing units and structures, 
 * and to manage the other agents in order to build, attack and defend
 * @author lexa
 */
class ChiefAgent extends Agent 
{
	/**
	 * all chief agents listed here
	 * keep track of all chief agents for the main loop
 	 */
	private static var chiefAgentsArray:Array<ChiefAgent>;
	/**
	 * chief agents count = number of chief agents (one moore for each split)
 	 */
	private static var chiefAgentNumber:Int;
	/**
	 * true if the agent was split already
	 */
	private var _hasSplit:Bool;
	/**
	 * a civic center is being build if _buildingCivCenterPending > 0
	 * each turn we do _buildingCivCenterPending-- 
	 */
	private var _buildingCivCenterPending:Int;
	/**
	 * frequency at which the agent is updated by the sequencer
	 */
	private static inline var ChiefAgentUpdateFrequency:Int = 2;
	/**
	 * frequency at which the agent says something
	 */
	private static inline var ChiefAgentSpeakFrequency:Int = 100;
	/**
	 * reference to the agent
	 */
	private var defenderAgent:DefenderAgent;
	/**
	 * reference to the agent
	 */
	private var builderAgent1:BuilderAgent;
	/**
	 * reference to the agent
	 */
	private var builderAgent2:BuilderAgent;
	/**
	 * reference to the agent
	 */
	private var machinaSexualAgent:MachinaSexualAgent;
	/**
	 * reference to the agent
	 */
	private var workerAgent:WorkerAgent;
	/**
	 * array of attacker agents
	 * attackers do not need to be called onUpdate, the handle it themselves
	 */
	private var attackerAgentsArray:Array<AttackerAgent>;
	/**
	 * an attack has just been started if _attackPending > 0
	 */
	private var _attackPending:Int;
	/**
	 * attacking
	 */
	private var _attackMode:Bool;
	/**
	 * name of this agent
	 */
	public var name:String;

	/**
	 * constructor
	 */
	public function new(botAI:BotAI, parentAgentUID:AgentUID) 
	{
		super(botAI, parentAgentUID);

		// keep track of all chief agents for the main loop
		if (ChiefAgent.chiefAgentsArray == null) 
			ChiefAgent.chiefAgentsArray = new Array();
		ChiefAgent.chiefAgentsArray.push(this);
		chiefAgentNumber = ChiefAgent.chiefAgentsArray.length-1;
		_buildingCivCenterPending = 0;
		_hasSplit = false;
		
		// init attackers
		attackerAgentsArray = new Array();
		_attackPending = 0;
		_attackMode = false;
		
		// used because seed of javascript random function depends on the time elapsed
		//var randomSeed:Int = Math.round((botAI.playerData.popLimit + botAI.playerData.popLimit + botAI.map.height + botAI.map.width)/100);
		var randomSeed:Int = Math.round(Date.now().getMinutes() / 10);
		
		Sequencer.getInstance().addTimer(this, onUpdate, randomSeed, ChiefAgentUpdateFrequency);
		Sequencer.getInstance().addTimer(this, saySomething, randomSeed * 15, ChiefAgentSpeakFrequency);
		name = "Chief #" + chiefAgentNumber;
	}
	/**
	 * used for debug
	 */
	public function saySomething(botAI:BotAI):Void 
	{
/*		botAI.chat("Agent " + name + " speeking. I have " 
			+ Statistic.peopleNumber + " people, "
			+ Statistic.buildersNumber + " workers, "
			+ Statistic.buildingsNumber + " buildings, "
			+ "resources: [" + Statistic.foodCount +", "+ Statistic.woodCount +", "+ Statistic.stoneCount +", "+ Statistic.metalCount +"]"
			);
/**/
		botAI.chat("--------------------------Agent " + name + " speeking. I have " 
			+ (builderAgent1.getBuilders(EntityHelper.myEntities).length
				+builderAgent2.getBuilders(EntityHelper.myEntities).length)+ " builders, "
			+ workerAgent.getWorkers().length + " workers, "
			+ machinaSexualAgent.getBuildings().length + " buildings, "
			+ "resources: [" + Statistic.foodCount +", "+ Statistic.woodCount +", "+ Statistic.stoneCount +", "+ Statistic.metalCount +"]"
			);

		var enemiesArray:Array<Player> = new Array();
		var idx:Int;
		if (botAI.state != null)
		{
			for (idx in 0...botAI.state.players.length)
				if (botAI.playerData.isEnemy[idx])
					enemiesArray.push(botAI.state.players[idx]);
		
			var enemyPlayer:Player = Statistic.choose(enemiesArray);
			var enemyName:String = enemyPlayer.name;
			botAI.chat("Hey " + enemyName + " ! SplitBot is after you... Eu sunt cu ochii pe tine...");
		}
	}
	/**
	 * update method called by the parent of this agent
	 */
	override public function onUpdate(botAI:BotAI):Void 
	{		
//		botAI.chat("passabilityClasses = " + Debug0AD.inspectObject(botAI.passabilityClasses));

		super.onUpdate(botAI);
		var entities:EntityCollection = getMyEntities();//EntityHelper.myEntities;//botAI.entities;

		// init
		if (machinaSexualAgent == null)
		{
			 botAI.chat("INIT "+name+" with "+entities.length+" entities");
			// create agents
			builderAgent1 = new BuilderAgent(botAI, agentUID);
			builderAgent2 = new BuilderAgent(botAI, agentUID);
			defenderAgent = new DefenderAgent(botAI, agentUID);
			machinaSexualAgent = new MachinaSexualAgent(botAI, agentUID);
			workerAgent = new WorkerAgent(botAI, agentUID);

			// assign units
			var workers:EntityCollection = workerAgent.takeEntities(getBuilders(entities), agentUID, null, 4);
			builderAgent1.takeEntities(getWorkers(), agentUID);

			// assign buildings
			machinaSexualAgent.takeEntities(getBuildings(), agentUID);
			// but keep the civic center
			var keepCivCenter = machinaSexualAgent.getCivicCenter();
			if (keepCivCenter != null)
				setAsMyEntity(keepCivCenter);
			
			// at the begining, put everyone to work on food and wood, whatever the resources are
			//workerAgent.gatherIdle(entities, workers, ResourceSupplyTypeValue.WOOD);

			// callbacks
			builderAgent1.onNewBuilding = onNewBuilding;
			builderAgent2.onNewBuilding = onNewBuilding;
			machinaSexualAgent.onNewUnitStart = onNewUnitStart;
			defenderAgent.onAttackStart = onAttackStart;
			defenderAgent.onAttackStop = onAttackStop;


		}
		else
		{
			// before a cc is build (after a split)
			if (getCivicCenter() == null)
			{
				var underConstructionCC:Entity = getCCFondation();
				if (underConstructionCC == null)
//				if(_buildingCivCenterPending-- <= 0)// only if we are not already building one
				{
					// is the new CC ready?
					var availableCC = getAvailableCC();
					if (availableCC != null)
					{
						Debug0AD.log("ChiefAgent, YEAH, I GOT A CC NOW !!!");
						setAsMyEntity(availableCC);
					}
					else
					{
					
						_buildingCivCenterPending = 100;
						
						var fatherCC:Entity = ChiefAgent.chiefAgentsArray[chiefAgentNumber-1].getCivicCenter();
					
						if (fatherCC == null)
						{
							Debug0AD.log("NO CC on the parent !!! son: "+chiefAgentNumber+" - "+ChiefAgent.chiefAgentsArray[chiefAgentNumber].name +" ----------- father: "+ChiefAgent.chiefAgentsArray[chiefAgentNumber-1].name +" - "+ChiefAgent.chiefAgentsArray[chiefAgentNumber-1].getCivicCenter());
							return;
						}
							
						// det best place to build
						var buildPosition:Point = getGoodPostionForbuildingCC(fatherCC);
						//Debug0AD.log("--------------SPLIT !!! build from "+ChiefAgent.chiefAgentsArray[chiefAgentNumber-1].getCivicCenter().position()+ " TO "+buildPosition.x+", "+buildPosition.y);

/*
Debug : check to see if distance to center of the map is kept
		var mapCenterX = MapHelper.passabilityMap.width * MapHelper.TILE_SIZE / 2;
		var mapCenterY = MapHelper.passabilityMap.height * MapHelper.TILE_SIZE / 2;
						Debug0AD.log("SPLIT !!! distance to cc from "+
							Utils.VectorDistance(ChiefAgent.chiefAgentsArray[chiefAgentNumber-1].getCivicCenter().position(), 
								(new Point(mapCenterX, mapCenterY)).toArrayPoint())
							+ " TO "+
							Utils.VectorDistance(buildPosition.toArrayPoint(), 
								(new Point(mapCenterX, mapCenterY)).toArrayPoint())
						);
*/
						var myEntities:EntityCollection = workerAgent.getMyEntities();
						myEntities.toEntityArray()[0].construct(EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER, 
							buildPosition.toArrayPoint()[0], 
							buildPosition.toArrayPoint()[1], 
							0.75 * Math.PI);
						myEntities.move(buildPosition.toArrayPoint()[0], buildPosition.toArrayPoint()[1]);
					}
				}
				else
				{
					Debug0AD.log("--------------SPLIT !!! Construction of CC has started");
				}
				return;
			}
			
			// **
			// take decisions according to the game state
			// **

/**/
			// split if this is the last chief agent in ChiefAgent.chiefAgentsArray
			if (_hasSplit == false && chiefAgentNumber >= ChiefAgent.chiefAgentsArray.length -1
				&& builderAgent2.getMyEntities().length >= 5)
			{
				_hasSplit = true;
				var sonChiefAgent:ChiefAgent = new ChiefAgent(botAI, null);
				var givenBuilders:EntityCollection = sonChiefAgent.takeEntities(builderAgent2.getMyEntities());//, null, null, 8);
				Debug0AD.log("SPLIT !!! total of chiefs="+ChiefAgent.chiefAgentsArray.length+"--------------------"+ (sonChiefAgent.name)+" has "+givenBuilders.length +" builders and "+(name)+" has "+builderAgent2.getMyEntities().length);
			}            
/**/
			// attack
			if ((_attackMode || botAI.playerData.popCount >= 170) && _attackPending-- <= 0)
			{
				// exit attack mode if population is too low
				if (botAI.playerData.popCount > 50)
					_attackMode = true;
				else _attackMode = false;
				// attack regularely again
				_attackPending = 50;
				// attack
				attack(botAI);
			}

			// choose what to build
			builderAgent1.goodTemplateNames = BuilderAgent.GOOD_TEMPLATE_NAMES;
				
			var barracks:EntityCollection = machinaSexualAgent.getBuildings([EntityHelper.TEMPLATE_STRUCTURE_BARRACKS]);
			var fields:EntityCollection = EntityHelper.myEntities.filter(function (ent:Entity, str:String) {
				return ent.templateName() == EntityHelper.TEMPLATE_STRUCTURE_FIELD;
			});
			if (botAI.playerData.popCount > 50)
			{
				// build defenses
  				builderAgent1.goodTemplateNames.push(EntityHelper.TEMPLATE_STRUCTURE_SCOUT_TOWER);                    
				// we have medium-high pop count
				// build attack
				// one of each attack building
				var templateNameAttack:String;
				for (templateNameAttack in EntityHelper.TEMPLATE_STRUCTURE_ATTACK_ARRAY)
				{
					if (machinaSexualAgent.getBuildings([templateNameAttack]).length <= 0)
					{
						builderAgent1.goodTemplateNames.push(templateNameAttack);
					}
				}
			}
			if (botAI.playerData.popCount < botAI.playerData.popLimit * 0.90 || botAI.playerData.popLimit >= 200)
			{
				// we are way under max pop limit
				if (machinaSexualAgent.getBuildings().length > 5)
				{
					// we are NOT at the begining
				}
				if (fields.length < 3)
					builderAgent1.goodTemplateNames.push(EntityHelper.TEMPLATE_STRUCTURE_FIELD);
				if (barracks.length < 6)
				{
					// we have few barracks
					builderAgent1.goodTemplateNames = builderAgent1.goodTemplateNames.concat([EntityHelper.TEMPLATE_STRUCTURE_BARRACKS]);
					if (fields.length < 2)
						builderAgent1.goodTemplateNames.push(EntityHelper.TEMPLATE_STRUCTURE_FIELD);
				}
				else
				{
					// never executed ?!
				}
			}
			else
			{
				// we almost reached max pop limit
				builderAgent1.goodTemplateNames = builderAgent1.goodTemplateNames.concat([EntityHelper.TEMPLATE_STRUCTURE_HOUSE, EntityHelper.TEMPLATE_STRUCTURE_HOUSE, EntityHelper.TEMPLATE_STRUCTURE_HOUSE]);
				//Debug0AD.log("Reach pop limit (" + botAI.playerData.popCount +" / "+ botAI.playerData.popLimit+") - "+builderAgent.goodTemplateNames);
			}
			builderAgent2.goodTemplateNames = builderAgent1.goodTemplateNames;

			// max % of women
			machinaSexualAgent.badTemplateNames = MachinaSexualAgent.BAD_TEMPLATE_NAMES;
			var women:EntityCollection = workerAgent.getWorkers().filter(function (ent:Entity, str:String) {
				return ent.templateName() == EntityHelper.UNIT_SUPPORT_FEMALE_CITIZEN;
			});
			if (women.length > Statistic.peopleNumber / 10 && women.length > 50)
			{
				machinaSexualAgent.badTemplateNames.push(EntityHelper.UNIT_SUPPORT_FEMALE_CITIZEN);
			}

			// update my agents
			builderAgent1.onUpdate(botAI);
			builderAgent2.onUpdate(botAI);
			machinaSexualAgent.onUpdate(botAI);
			workerAgent.onUpdate(botAI);
			
		}
	}
	/**
	 * retrieve the Civ Center after construction 
	 * i.e. a CC which belongs to SplitBot, but is not attributed to an agent yet
	 */
	public function getAvailableCC():Entity
	{
		var me:Agent = this;
		return EntityHelper.myEntities.filter(function(ent:Entity, str:String) 
		{ 
			return ent.getMetadata(Agent.ENTITY_META_OWNER_ID) == null
				&& ent.templateName() == EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER; 
		} ).toEntityArray()[0];
	}
	/**
	 * retrieve the Civ Center under construction 
	 */
	public function getCCFondation():Entity
	{
		var me:Agent = this;
		return getFondations().filter(function(ent:Entity, str:String) 
		{ 
			return ent.templateName() == "foundation|"+EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER; 
		} ).toEntityArray()[0];
	}
	/**
	 * function used when the bot splits, to det the best position of the new CC
	 */
	public function getGoodPostionForbuildingCC(civCenter:Entity):Point
	{
		var templateSize:Float = civCenter.obstructionRadius();
		var securityMaxLoop:Int = 0;
		var positionCC = Point.arrayPoint2Point(civCenter.position());
		var mapCenterX = MapHelper.passabilityMap.width * MapHelper.TILE_SIZE / 2;
		var mapCenterY = MapHelper.passabilityMap.height * MapHelper.TILE_SIZE / 2;
		// from map coordinate system to CC coord system
		var polarCoordOfCC = new Point(positionCC.x - mapCenterX, positionCC.y - mapCenterY).toPolarCoord();

		// go round the map
		while (true)
		{
			// random angle in the same half of the map
			var newAngle = polarCoordOfCC.angle + ((Math.random() - .5) * Math.PI); 
			var newPoint = new PolarCoord(polarCoordOfCC.distance, newAngle).toPoint();
			// back to the map coordinate system
			newPoint.x += mapCenterX;
			newPoint.y += mapCenterY;
			newPoint.x = Math.round(newPoint.x);
			newPoint.y = Math.round(newPoint.y);

			if (!MapHelper.isObstructed(newPoint, templateSize, templateSize, 
				[
					EntityHelper.BUILDING_LAND_OBSTRUCTION, 
					EntityHelper.FOUNDATION_OBSTRUCTION,
					EntityHelper.PATHFINDER_OBSTRUCTION,
					EntityHelper.DEFAULT_OBSTRUCTION,
					//EntityHelper.SHIP_OBSTRUCTION, 
					//EntityHelper.BUILDING_SHORE_OBSTRUCTION,
					EntityHelper.UNRESTRICTED_OBSTRUCTION
				]))
				return newPoint;
			if (securityMaxLoop++ > 100000)
				break;
		}
		Debug0AD.error("Could not find a place to build the civic center for "+name);
		return new Point(-1, -1);
	}
	/**
	 * attack the nearest oponent's building
	 */
	public function attack(botAI:BotAI):Void
	{
		// take the workers
		var attackerAgent:AttackerAgent = new AttackerAgent(botAI, this.agentUID);
		var people:EntityCollection = EntityHelper.myPeopleUnits;

		// take all unassigned entities
		attackerAgent.takeEntities(EntityHelper.myPeopleUnits, agentUID);

		// take 80% of the men and 100% of idle
		var maxAttackers:Int = 15; // workers.length * 0.8;
		//var numAttackers:Int = 0;
		var attackers:EntityCollection = people.filter(function (ent:Entity, str:String) {
			if(ent.templateName() != EntityHelper.UNIT_SUPPORT_FEMALE_CITIZEN 
				//&& Math.random() < 0.8
				//&& (ent.isIdle() || numAttackers++ < maxAttackers )
			)
			{
				// no, because it takes from other attackers: attackerAgent.setAsMyEntity(ent);
				return true;
			}
			return false;
		});
		// no, because the entities have an owner allready 
		attackerAgent.takeEntities(attackers, workerAgent.agentUID, null, maxAttackers);
		
		// for machines
		var machines:EntityCollection = attackerAgent.takeEntities(EntityHelper.myEntities, this.agentUID, [EntityHelper.CLASS_MECHANICAL], maxAttackers);
		//Debug0AD.log("machines "+ machines.length);
		
		// add it to the que of attackers
		attackerAgentsArray.push(attackerAgent);
		
		// stop attack if there is too few units left
		if (attackerAgent.getMyEntities().length <= 5)
		{
			_attackMode = false;
			_attackPending = 0;
		}
		
		Debug0AD.log("One more attacker agent, with " + attackerAgent.getMyEntities().length + ", that makes " + attackerAgentsArray.length + " attacker agents ");
		
		// remove useless attackers
		cleanupAttackerAgents();
	}
	/**
	 * remove useless attackers
	 */
	function cleanupAttackerAgents()
	{
		var attackersToRemove:Array<Int> = new Array();
		var idx:Int;
		// build an array of indexes to remove
		for (idx in 0...attackerAgentsArray.length)
		{
			if (attackerAgentsArray[idx].getMyEntities().length <= 0)
			{
				attackersToRemove.unshift(idx);
			}
		}
		// remove all desired indexes, beginning by high indexes
		for (idx in 0...attackersToRemove.length)
		{
			var removedAgent:Agent = attackerAgentsArray.splice(attackersToRemove[idx], 1)[0];
			removedAgent.cleanup();
		}
	}
	/**
	 * callback called by the defender agent when the village is under attack
	 */
	function onAttackStart()
	{
		Debug0AD.log("onAttackStart ----------------------------------------------------------");
		_attackPending = 50;
		_attackMode = true;
	}
	/**
	 * callback called by the defender agent when the village is NOT under attack anymore
	 */
	function onAttackStop()
	{
		Debug0AD.log("onAttackStop ----------------------------------------------------------");
	}
	/**
	 * callback called by the builderAgent when a new building is ready
	 */
	function onNewBuilding(building:Entity)
	{
		if (building.templateName() == EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER)
			return;
			
/// to do: if closer from another CC, let it go
		machinaSexualAgent.setAsMyEntity(building);
	}
	/**
	 * callback used to tell the machinaSexualAgent, to which agent it should give a unit which is about to be created
	 */
	function onNewUnitStart(entity:Entity, templateName:String):Agent
	{
		//Debug0AD.log("onNewUnitStart "  + entity.templateName() + " - " + entity.classes() + " - " + entity.hasClass(EntityHelper.CLASS_SIEGE));
		// case of the machines
		if (entity.templateName() == EntityHelper.TEMPLATE_STRUCTURE_FORTRESS)//entity.hasClass(EntityHelper.CLASS_SIEGE))
		{
			//Debug0AD.log("MACHINE");
			return this;
		}
		else
		{
			var choicesArray:Array<Agent> = [];
			choicesArray.push(workerAgent);
			
			// add a worker once in a while, while there is less than MAX_NUM_WORKERS
			if (builderAgent1.getWorkers().length < 5)
			{
				choicesArray.push(builderAgent1);
			}
			else if (builderAgent2.getWorkers().length < 5)
			{
				choicesArray.push(builderAgent2);
			}
			return Statistic.choose(choicesArray);
		}
	}
}
