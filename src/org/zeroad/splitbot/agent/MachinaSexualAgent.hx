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
import org.zeroad.common_api.Entity;
import org.zeroad.common_api.EntityTypeValues;
import org.zeroad.common_api.EntityCollection;
import org.zeroad.common_api.Utils;
import org.zeroad.splitbot.agent.Agent;
import org.zeroad.splitbot.core.Point;
import org.zeroad.splitbot.core.Statistic;
import org.zeroad.splitbot.helper.Debug0AD;
import org.zeroad.splitbot.helper.EntityHelper;
import org.zeroad.splitbot.helper.MapHelper;
import org.zeroad.splitbot.core.Sequencer;

/**
 * the machina sexual (sex machine) agent is in charge of building units
 * the chief agent can specify what to build
 * new units are given to the chief agent through the MachinaSexualAgent::onNewUnitStart callback
 * @author lexa
 */
class MachinaSexualAgent extends Agent 
{
	/**
	 * callback called when a new unit is started to be build
	 * params: building which builds the unit and template name of the unit
	 * it is supposed to return an agent to which we want to give the unit
	 */
	public var onNewUnitStart: Entity->String->Agent;
	
	/**
	 * the templates which we are not allowed to build by default 
	 * women or other templates may be added at runtime, in badTemplateNames property
	 */
	public static var BAD_TEMPLATE_NAMES : Array<String> = [EntityHelper.UNIT_CAVALRY_JAVELINIST, EntityHelper.UNIT_CAVALRY_SPEARMAN, EntityHelper.UNIT_CAVALRY_SWORDSMAN, EntityHelper.UNIT_CHAMPION_CAVALRY_BRIT, EntityHelper.UNIT_CHAMPION_CAVALRY_GAUL];
	/**
	 * the templates which we are not allowed to be build 
	 */
	public var badTemplateNames : Array<String>;
	/**
	 * constructor
	 */
	public function new(botAI:BotAI, parentAgentUID:AgentUID) 
	{
		super(botAI, parentAgentUID);
		badTemplateNames = BAD_TEMPLATE_NAMES;
	}

	function getBestTemplate(templatesNames:Array<String>):String
	{
		//workaround: no cost available => count 1 for every body
		
		var idx:Int;
		var goodTemplateNames:Array<String> = new Array();
		var probabilities:Array<Int> = new Array();
		for (idx in 0...templatesNames.length)
		{
			if (!Utils.isInArray(badTemplateNames, templatesNames[idx]))
			{
				goodTemplateNames.push(templatesNames[idx]);
				probabilities.push(Math.round(100/templatesNames.length));
			}
		}
		
		return Statistic.choose(goodTemplateNames, probabilities);
		
		
/*		var templates:Array<EntityTemplate> = [];
		var idx:Int, totalCost:Int = 0;
		for (idx in 0...templatesNames.length)
		{
			var template:EntityTemplate = new EntityTemplate(templatesNames[idx]);
			templates.push(template);
			totalCost += template.cost[0];
		}
		var probabilities:Array<Int> = [];
		for (idx in 0...templates.length)
		{
			if (templates[idx].cost != null && templates[idx].cost[0] != null)
			{
				probabilities[idx] = Math.round(templates[idx].cost[0] / totalCost);
			}
			else
			{
				probabilities[idx] = 1;
			}
		}
		Debug0AD.log("xxxxxxxx " + templates.length +" - "+ probabilities.length);
		return Statistic.choose(templatesNames, probabilities);
*/	}
	/**
	 * update method called by the parent of this agent
	 */
	override public function onUpdate(botAI:BotAI):Void 
	{
		super.onUpdate(botAI);
		build(getBuildings(), botAI.playerData.civ);
	}
	/**
	 * build the desired building at the desired place with the available builders.
	 * the place can be automatically chosen, it does a circle around the civ center
	 */
	public function build(buildings:EntityCollection, civ:String, templateName:String = null, position:Point = null):Void
	{
		var me:MachinaSexualAgent = this;
		var onlyFirstTime:Bool = false;
		
		var debugString:String = "";
		//Debug0AD.log("build "+Math.random());
		debugString += "build ";
		
		//units.toEntityArray()[0];
		buildings.forEach(function(ent:Entity, str:String) 
		{
			if (ent.trainingQueue() != null && ent.trainingQueue().length == 0)
			{
				if (onlyFirstTime == false)
				{
					// automatic choice of a good template
					if (templateName == null) 
						templateName = me.getBestTemplate(ent.trainableEntities());
					// if this building can produce something good
					if (templateName != null)
					{
						//Debug0AD.log("TRAIN A "+templateName+" ! ");
						ent.train(templateName, 1, { ENTITY_META_OWNER_ID:Std.string(me.onNewUnitStart(ent, templateName).agentUID) } ); 
						onlyFirstTime = true;
					}
				}
			}
			else
			{
/*				var prop;
				for (prop in Reflect.fields(ent.trainingQueue()[0]))
					debugString += prop + " = " + Reflect.field(ent.trainingQueue()[0], prop) + "; ";
*/			}
			return true; 
		} );
//		Debug0AD.log(debugString);
	}
}