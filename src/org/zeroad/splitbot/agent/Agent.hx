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
/**
 * @author lexa
 */

package org.zeroad.splitbot.agent;
import org.zeroad.common_api.Entity;
import org.zeroad.common_api.EntityCollection;
import org.zeroad.common_api.EntityTypeValues;
import org.zeroad.common_api.ResourceSupply;
import org.zeroad.common_api.Utils;
import org.zeroad.splitbot.helper.EntityHelper;

typedef AgentUID = Int;

/**
 * this class is the base class for all agents
 * Agents control several Behaviors to achieve a given goal.
 */
class Agent 
{
	/**
	 * name of the field in the meta data of the entities
	 * in which we will store the owner Agent UID
	 */
	static inline var ENTITY_META_OWNER_ID:String = "ENTITY_META_OWNER_ID";
	/**
	 * UID of this agent
	 */
	public var agentUID:AgentUID;
	/**
	 * the uid of the parent agent 
	 */
	private var parentAgentUID:AgentUID;
	/**
	 * constructor
	 */
	public function new(botAI:BotAI, parentAgentUID:AgentUID) 
	{
		agentUID = _nextId++;
		this.parentAgentUID = parentAgentUID;
	}
	/**
	 * deconstructor
	 */
	public function cleanup() 
	{
	}
	/**
	 * update method called by the parent of this agent
	 */
	public function onUpdate(botAI:BotAI):Void 
	{
	}
	/**
	 * store next id
	 */
	static private var _nextId:AgentUID = 0;
	/**
	 * determine if this is one of my entities
	 */
	public function isMyEntity(entitiy:Entity):Bool
	{
		return entitiy.getMetadata(Agent.ENTITY_META_OWNER_ID) == Std.string(agentUID);
	}
	/**
	 * determine if this is one of my parent's entities
	 */
	public function isMyParentEntity(entitiy:Entity):Bool
	{
		return parentAgentUID != null && entitiy.getMetadata(Agent.ENTITY_META_OWNER_ID) == Std.string(parentAgentUID);
	}
	/**
	 * set this entity as my entity
	 */
	public function setAsMyEntity(entitiy:Entity):Void
	{
		entitiy.setMetadata(Agent.ENTITY_META_OWNER_ID, Std.string(agentUID));
	}
	/**
	 * take a given number of entities among an entity list
	 * call setAsMyEntity for each chosen entity
	 */
	public function takeEntities(entities:EntityCollection, ownerAgentUID:AgentUID = null, classesRequired:Array<String> = null, maxNumEntities:Int = -1):EntityCollection
	{
		//if (maxNumEntities < 0) maxNumEntities = entities.toIdArray.length;
		if (classesRequired == null) classesRequired = new Array();

		var me:Agent = this;
		var numEntities:Int = 0;
		var myEntities:EntityCollection = entities.filter(function(ent:Entity, str:String) 
		{
			if ((ownerAgentUID==null
				|| ent.getMetadata(Agent.ENTITY_META_OWNER_ID) == null 
				|| ent.getMetadata(Agent.ENTITY_META_OWNER_ID) == ownerAgentUID)
				&& ent.isOwn() 
				&& EntityHelper.hasClasses(ent, classesRequired))
			{
				// take only the required number of elements
				if (maxNumEntities < 0 || numEntities++ < maxNumEntities)
				{
					me.setAsMyEntity(ent);
					return true;
				}
			}
			return false; 
		});
		
		return myEntities;
	}
	/**
	 * retrieve my civic center
	 */
	public function getCivicCenter():Entity
	{
		var me:Agent = this;
		var civicCenterEntity:Entity = EntityHelper.myBuildingStructures.filter(function(ent:Entity, str:String) 
		{ 
			return (me.isMyEntity(ent) || me.isMyParentEntity(ent))
				&& ent.templateName() == EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER; 
		}).toEntityArray()[0];
		
		return civicCenterEntity;
	}
	/**
	 * get my entities
	 */
	public function getMyEntities():EntityCollection
	{
		var me:Agent = this;
		return EntityHelper.myEntities.filter(function(ent:Entity, str:String) 
		{ 
			return me.isMyEntity(ent); 
		} );
	}
	/**
	 * get builders in my entities
	 */
	public function getBuilders(entities:EntityCollection):EntityCollection
	{
		var me:Agent = this;
		return entities.filter(function(ent:Entity, str:String) 
		{ 
			return me.isMyEntity(ent) && ent.buildableEntities() != null; 
		} );
	}
	/**
	 * get workers in my entities
	 */
	public function getWorkers():EntityCollection
	{
		var me:Agent = this;
		return EntityHelper.myBuilderUnits.filter(function(ent:Entity, str:String) 
		{ 
			return me.isMyEntity(ent) && ent.buildableEntities() != null; 
		} );
	}
	/**
	 * retrieve the under construction buildings
	 */
	public function getFondations():EntityCollection
	{
		var me:Agent = this;
		return EntityHelper.myBuildingStructures.filter(function(ent:Entity, str:String) 
		{ 
			return /*me.isMyEntity(ent) && */ ent.isOwn() && ent.foundationProgress() != null; 
		} );
	}
	/**
	 * get all my buildings + civic center
	 */
	public function getBuildings(allowedTemplateNames:Array<String> = null):EntityCollection
	{
		var me:Agent = this;
		
		if (EntityHelper.myBuildingStructures.length <= 0)
			return EntityHelper.myBuildingStructures;
			
		return EntityHelper.myBuildingStructures.filter(function(ent:Entity, str:String) 
		{
			return ((me.isMyEntity(ent) && ent.trainableEntities() != null)
				|| (me.isMyParentEntity(ent) && ent.templateName() == EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER))
				&& (allowedTemplateNames == null || Utils.isInArray(allowedTemplateNames, ent.templateName())); 
		} );
	}
	/**
	 * get the ressources on the map
	 */
	public function getResources(entities:EntityCollection, type:ResourceSupplyType = null):EntityCollection
	{
		return entities.filter(function(ent:Entity, str:String) 
		{
			var entType:ResourceSupply = ent.resourceSupplyType();
			if (entType!=null && (type == null || entType.generic == type)) 
				return true;
			else
				return false;
		});
	}
}

