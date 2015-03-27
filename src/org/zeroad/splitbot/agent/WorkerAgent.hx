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
import org.zeroad.common_api.ResourceSupply;
import org.zeroad.common_api.Utils;
import org.zeroad.splitbot.agent.Agent;
import org.zeroad.splitbot.core.Point;
import org.zeroad.splitbot.core.Statistic;
import org.zeroad.splitbot.helper.Debug0AD;
import org.zeroad.splitbot.helper.MapHelper;
import org.zeroad.splitbot.core.Sequencer;

/**
 * the worker agent is in charge of hunting and gathering resources
 * the chief agent give this agent units so that it is able to do his job
 * @author lexa
 */
class WorkerAgent extends Agent 
{
	/**
	 * constant used to determine when a resource is really far away
	 * for now, the bot just says "it is far from home" and still go and get the resource
	 */
	public static inline var MAX_ACCEPTABLE_DISTANCE_OF_A_RESOURCE:Int = 200;
	/**
	 * constructor
	 */
	public function new(botAI:BotAI, parentAgentUID:AgentUID) 
	{
		super(botAI, parentAgentUID);
	}
	/**
	 * update method called by the parent of this agent
	 */
	override public function onUpdate(botAI:BotAI):Void 
	{
		super.onUpdate(botAI);
		var entities:EntityCollection = botAI.entities;
		work(botAI.entities, botAI.playerData.civ, ResourceSupply.getRessourceArray(botAI));
	}
	/**
	 * returns the lowest ressource we have
	 */
	public function getBestResourceTemplate(resourcesArray:Array<ResourceSupply>):String
	{
		resourcesArray[2].count *= 2;
		resourcesArray[3].count *= 2;
		resourcesArray.sort(function(obj1:ResourceSupply, obj2:ResourceSupply):Int {
			return obj1.count - obj2.count;
		});
		return resourcesArray[0].generic;
		//return Statistic.choose([ResourceSupplyTypeValue.FOOD, ResourceSupplyTypeValue.WOOD, ResourceSupplyTypeValue.STONE, ResourceSupplyTypeValue.METAL], [45, 30, 15, 10]);
	}
	/**
	 * put all my units to work
	 */
	public function work(entities:EntityCollection, civ:String, resourcesArray:Array<ResourceSupply>):Void
	{
		// get my units
		var units:EntityCollection;
		units = getWorkers();
		//units.toEntityArray()[0];
		gatherIdle(entities, units, getBestResourceTemplate(resourcesArray));
	}
	/**
	 * put all the given units to work
	 */
	public function gatherIdle(entities:EntityCollection, builders:EntityCollection, resourceTemplateName:String)
	{
		var me:WorkerAgent = this;
		var resources:Array<Entity> = getResources(entities, resourceTemplateName).toEntityArray();
		builders.forEach(function(ent:Entity, str:String) 
		{
			if (ent.isIdle())
			{
				var targetEntity:Entity;
				resources.sort(function(e1:Entity, e2:Entity):Int 
				{ 
					return	Math.round(Utils.VectorDistance(ent.position(), e1.position()) - Utils.VectorDistance(ent.position(), e2.position()));
				});
				// random in the 10 closest resources
//				var idx:Int = Math.round(Math.random()*Math.min(resources.length-1, 10));
				targetEntity = resources[0];//resources[idx];
				// gather 
				ent.gather(targetEntity);
				// order a building if needed
				var dist:Float = Utils.VectorDistance(targetEntity.position(), ent.position());
				if (dist > MAX_ACCEPTABLE_DISTANCE_OF_A_RESOURCE)
				{
					// to do
					Debug0AD.log("WorkerAgent - work is very far from home!! :( "+dist);
				}
			}
			return true; 
		} );
	}
}