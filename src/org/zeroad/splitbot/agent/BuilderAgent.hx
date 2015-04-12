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
 * the builder agent is in charge of leading a team of units to build structures
 * the chief agent will ask for speceific structures
 * and once a building is ready, it is given back to the chief agent through the onNewBuilding callback
 * 
 * @author lexa
 */
class BuilderAgent extends Agent 
{
	/**
	 * callback which will be called when we have to choose an owner for a new building
	 */
	public var onNewBuilding: Entity->Void;
	/**
	 * the templates which we build automatically by default
	 * other templates may be added at runtime, in goodTemplateNames property
	 */
	public static var GOOD_TEMPLATE_NAMES : Array<String> = [];
	/**
	 * the templates which we build automatically
	 */
	public var goodTemplateNames : Array<String>;
	/**
	 * Margin between buildings
	 */
	public static inline var MARGIN_BETWEEN_BUILDINGS:Int = 20;
	/**
	 * point where we have build something last time
	 */
	private var lastGoodPosition:Point;
	/**
	 * max number of turns elapsed before the construction of a new building begins
	 * after that we considere it can not be build and must be destroyed
	 * used to determine if we can not build it - because of the pathfinder bugs, or an inadequat position
	 */
	public static inline var MAX_TURNS_BEFORE_BUILDING_START : Int = 200; // 300 is about 1 minute ?
	/**
	 * the building which is under construction
	 * used to determine if we can not build it - because of the pathfinder bugs, or an inadequat position
	 */
	private var currentBuildingId:String;
	/**
	 * the building progress
	 * used to determine if we can not build it - because of the pathfinder bugs, or an inadequat position
	 */
	private var currentBuildingProgress:Int;
	/**
	 * the turn at which we started building the building which is under construction
	 * used to determine if we can not build it - because of the pathfinder bugs, or an inadequat position
	 */
	private var currentBuildingStartTurn:Int;
	
	/**
	 * constructor
	 */
	public function new(botAI:BotAI, parentAgentUID:AgentUID) 
	{
		super(botAI, parentAgentUID);
		goodTemplateNames = GOOD_TEMPLATE_NAMES;
	}
	/**
	 * once a building is build, we should assign it to an agent
	 * let the parent decide what to do with it
	 */
	public function setMetadataOnNewBuildings(entities):Void
	{
		var me:BuilderAgent = this;
		entities.forEach(function(ent:Entity, str:String) 
		{ 
			if (ent.hasClass(EntityHelper.CLASS_STRUCTURE) && ent.isOwn() && ent.getMetadata("ENTITY_META_OWNER_ID") == null)
			{
				if (ent.foundationProgress() != null)
					me.setAsMyEntity(ent);
				else
				{
					// building ready
					//Debug0AD.log("Building ready !");
					//ent.setMetadata(Agent.ENTITY_META_OWNER_ID,me.MACHINA_SEXUAL_AGENT_UID);
					me.onNewBuilding(ent);
					// reset current building id
					me.currentBuildingId == null;
				}
			}
			return false;
		} );
	}
	/**
	 * update method called by the parent of this agent
	 * if there is a building under construction, put all builders on it
	 * otherwise, build something
	 */
	override public function onUpdate(botAI:BotAI):Void 
	{
		super.onUpdate(botAI);
		
		
		var units:EntityCollection = getBuilders(botAI.entities);
		var foundations:EntityCollection = getFondations();
		
		var closestFoundation:Entity = null;
		var closestFoundationDistance:Float = Math.POSITIVE_INFINITY;
		
		if (units.length > 0 && foundations.length > 0)
		{
			// get closest foundation
			foundations.forEach(function(ent:Entity, str:String) 
			{ 
				var dist:Float = Utils.VectorDistance(ent.position(), units.toEntityArray()[0].position());
				if (dist < closestFoundationDistance)
				{
					closestFoundation = ent;
					closestFoundationDistance = dist;
				}
				return false; 
			} );
		}		
//		Debug0AD.log("BuilderAgent, onUpdate "+units.toIdArray().length+" units, "+foundationsArray.length+" buildings under construction" );

		var me:Agent = this;
		if (closestFoundation != null)
		{
			// Debug0AD.log("BuilderAgent, onUpdate FOUNDATIONS "+foundationsArray[0].hitpoints()+" hitpoints, "+foundationsArray[0].foundationProgress()+" progress, "+foundationsArray.length+" buildings under construction" );
			// update progress
			currentBuildingProgress = closestFoundation.hitpoints();
			
//			botAI.chat("Builders, Move !"+closestFoundation.getMetadata(Agent.ENTITY_META_OWNER_ID) );
			units.forEach(function(ent:Entity, str:String) 
			{ 
				ent.repair(closestFoundation);
				return false; 
			} );
			// did we start another building?
			if (currentBuildingId == null || currentBuildingId != closestFoundation.id())
			{
				// update the current building information
				currentBuildingId = closestFoundation.id();
				currentBuildingStartTurn = Sequencer.getInstance().turnNumber;
			}
			else
			{
				// check if time is up, i.e. we can not build it - because of the pathfinder bugs, or an inadequat position
				if (Sequencer.getInstance().turnNumber - currentBuildingStartTurn > MAX_TURNS_BEFORE_BUILDING_START
					&& currentBuildingProgress == 1)
				{
					// destroy the building
					closestFoundation.destroy();
				}
			}
			// idleUnits.move(foundationsArray[0].position()[0], foundationsArray[0].position()[1]);
		}
		else
		{
			// boost house and field
//			var templateName:String = Statistic.choose([EntityHelper.TEMPLATE_STRUCTURE_FIELD, EntityHelper.TEMPLATE_STRUCTURE_HOUSE, EntityHelper.TEMPLATE_STRUCTURE_BARRACKS,null],[10, 20, 20, 50]);
			// random build
			build(botAI, botAI.entities, botAI.playerData.civ);
		}
	}
	/**
	 * compute the best choice about what to build next
	 */
	function getBestTemplate(templatesNames:Array<String>, civ:String):String
	{
		if (goodTemplateNames.length <= 0)
			return null;
		
		var idx:Int;
		var probabilities:Array<Int> = new Array();
		var goodTemplates:Array<String> = new Array();
		// keep only good templates
		for (idx in 0...templatesNames.length)
		{
			if (Utils.isInArray(goodTemplateNames, templatesNames[idx]))
			{
				goodTemplates.push(templatesNames[idx]);
			}
		}
		// all with probability proportional to cost (the more expensive, the better)
		for (idx in 0...goodTemplates.length)
		{
			probabilities.push(Math.round(100/goodTemplates.length));
		}
		return Statistic.choose(goodTemplates, probabilities);
	}
	/**
	 * build the desired building at the desired place with the available builders.
	 * the place can be automatically chosen, it does a circle around the civ center
	 */
	public function build(botAI:BotAI, entities:EntityCollection, civ:String, templateName:String = null, position:Point = null):Void
	{
		
		//var mapCenter:Point = new Point(MapHelper.map.width * MapHelper.TILE_SIZE, MapHelper.map.height * MapHelper.TILE_SIZE);
		
		
		var me:BuilderAgent = this;
		var onlyFirstTime:Bool = false;
		
		// get my units
		var unitsEntityCollection:EntityCollection = getBuilders(entities);
		var units:Array<Entity>;
		units = unitsEntityCollection.toEntityArray();
		if (units.length <= 0) return;
		var randomIndex:Int = Math.round(Math.random()*(units.length-1));
		var ent:Entity = units[randomIndex];
// to do : take the 1st non-idle instead of random
			if (ent.isIdle())
			{
				// automatic choice of a good template
				if (templateName == null) 
					templateName = me.getBestTemplate(ent.buildableEntities(), civ);
				// if this entity can produce something good
				if (templateName != null)
				{
					var entityTemplate:EntityTemplate = new EntityTemplate(Reflect.field(botAI.templates,templateName));

					var templateSize:Float = entityTemplate.obstructionRadius();
					//if (templateSize == null) templateSize = 5;
					//Debug0AD.log("build - "+ me.isMyEntity(ent));

					var buildPosition:Point;
					if (position != null)
						buildPosition = position;
					else
					{
						buildPosition = me.getGoodPostionForbuilding(entities, templateSize, templateSize, civ); // ent.position();
					}
				
					ent.construct(templateName, buildPosition.toArrayPoint()[0], buildPosition.toArrayPoint()[1], 0.75 * Math.PI); 
					
					// compute rotation v1: 2 * Math.PI - getAngle(buildPosition, Point.arrayPoint2Point(getCivicCenter().position()))); 
					
					// send all units there to build
					unitsEntityCollection.move(buildPosition.toArrayPoint()[0], buildPosition.toArrayPoint()[1]);


				}
				//Debug0AD.log("build " + templateName + " - " + Reflect.field(botAI.templates,templateName) + " - " + entityTemplate.obstructionRadius());
			}
		setMetadataOnNewBuildings(entities); 
	}
	/**
	 * compute the angle which a given point makes to the center of the map
	 */
	public function getAngle(pointCenter:Point, point:Point):Float
	{
		return new Point(pointCenter.x - point.x, pointCenter.y - point.y).toPolarCoord().angle;
	}
	/**
	 * find a good buildable place 
	 */
	public function getGoodPostionForbuilding(entities:EntityCollection, width:Float, height:Float, civ:String):Point
	{
		var debugStr:String = width +", " + height;
		var civCenter:Entity = getCivicCenter();
		if (civCenter != null)
		{
			// back to the CC once in a while
			if (lastGoodPosition == null || Statistic.choose([true, false], [10, 90]) == true)
				lastGoodPosition = Point.arrayPoint2Point(civCenter.position());
			
			var securityMaxLoop:Int = 0;
			
			var relativeCoord = Point.arrayPoint2Point(civCenter.position());
			var polarCoord = lastGoodPosition.toPolarCoord(relativeCoord.x,relativeCoord.y);//new PolarCoord((width+height)/2,0);
			var angle = 0;
		
			while (true)
			{
/**/				lastGoodPosition.x += Math.round(((Math.random() - .5)
					* (width + MARGIN_BETWEEN_BUILDINGS) ));
				lastGoodPosition.y += Math.round(((Math.random() - .5) 
					* (height + MARGIN_BETWEEN_BUILDINGS)));
/**/
/* here, polarCoord.angle stay stuck at some point (first time the build failed)
 * 
 * 				polarCoord.angle += Math.PI/3;
				if (polarCoord.angle >= 2 * Math.PI)
				{
					polarCoord.angle=0.0;
					polarCoord.distance += 10;
				}
				lastGoodPosition = polarCoord.toPoint();
				lastGoodPosition.x += relativeCoord.x;
				lastGoodPosition.y += relativeCoord.y;
*/
				if (!MapHelper.isObstructed(lastGoodPosition, width + MARGIN_BETWEEN_BUILDINGS, height + MARGIN_BETWEEN_BUILDINGS, 
					[
						EntityHelper.BUILDING_LAND_OBSTRUCTION, 
						EntityHelper.FOUNDATION_OBSTRUCTION,
						EntityHelper.PATHFINDER_OBSTRUCTION,
						EntityHelper.DEFAULT_OBSTRUCTION,
						//EntityHelper.SHIP_OBSTRUCTION, 
						//EntityHelper.BUILDING_SHORE_OBSTRUCTION,
						EntityHelper.UNRESTRICTED_OBSTRUCTION
					]))
				{
					Debug0AD.log("GOOD POSITION TO BUILD "+lastGoodPosition.x+","+lastGoodPosition.y+"- "+polarCoord.angle);
					return lastGoodPosition;
				}
					
				if (securityMaxLoop++ > 100000)
					break;
			}
			Debug0AD.error("Could not find a place to build");
		}
		// do not build
					Debug0AD.log("COULD NOT FIND POSITION TO BUILD ");
		return new Point(-10000,-10000);
/*		
		// HERE WE BUILD A CONTINUOUS SNAKE
		var point:Point = lastGoodPosition;
		var distHeight:Float = height;
		var distWidth:Float = width;
		
		do
		{
			point = new Point(lastGoodPosition.x+distWidth, lastGoodPosition.y);
			if (!MapHelper.isObstructed(point, width, height, [EntityHelper.BUILDING_LAND, EntityHelper.FOUNDATION_OBSTRUCTION]))
				break;
				
			point = new Point(lastGoodPosition.x, lastGoodPosition.y+distHeight);
			if (!MapHelper.isObstructed(point, width, height, [EntityHelper.BUILDING_LAND, EntityHelper.FOUNDATION_OBSTRUCTION]))
				break;
				
			point = new Point(lastGoodPosition.x-distWidth, lastGoodPosition.y);
			if (!MapHelper.isObstructed(point, width, height, [EntityHelper.BUILDING_LAND, EntityHelper.FOUNDATION_OBSTRUCTION]))
				break;
				
			point = new Point(lastGoodPosition.x, lastGoodPosition.y-distHeight);
			if (!MapHelper.isObstructed(point, width, height, [EntityHelper.BUILDING_LAND, EntityHelper.FOUNDATION_OBSTRUCTION]))
				break;
			
			distHeight += height;
			distWidth += width;
		}
		while (true);

		Debug0AD.log("found good location - " + point.x + "," + point.y+" - "+getCivicCenter(entities).position()+" - "+width+" - "+height);
		lastGoodPosition = point;
		return lastGoodPosition;
		*/
	}
}
