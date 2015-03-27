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
 * This package groups several "extern" classes which link at runtime to 
 * 0A.D. game engine classes exposed to javascript in the common API
 * @author lexa
 */

package org.zeroad.common_api;
import org.zeroad.common_api.Utils;

/**
 * Objects of type Template represent the templates XML files in 0 A.D. alpha/binaries/data/mods/public/simulation/templates/ * / *.xml
 * It should not be used as is, but instead create an EntityTemplate object with <code>entityTemplate = new EntityTemplate(Reflect.field(baseAI.templates,templateName));<code>
 * Then use entityTemplate.civ() for example
 * @example	template.Identity.Civ
 * @example	template.Identity.Rank
 * @example	template.Identity.Classes._string.split(/\s+/);
 * @example	template.Cost.Resources[type]
 * @example	template.Obstruction.Static["@depth"]
 * @example	template.Health.Repairable
 */
typedef Template = Dynamic;

extern class EntityTemplate
{
	
	public function new(template:Template):Void;
	public function rank():Int;
	public function classes():Array<String>;
	public function hasClass(name:String):Bool;
	public function civ():String;
	public function cost():Array<Int>;
	/**
	 * Returns the radius of a circle surrounding this entity's
	 * obstruction shape, or undefined if no obstruction.
	 */
	public function obstructionRadius():Float;
	public function maxHitpoints():Int;
	public function isHealable():Bool;
	public function isRepairable():Bool;
	public function buildableEntities():Array<String>;
	public function trainableEntities():Array<String>;
	/**
	 * @return { "generic": type, "specific": subtype }
	 * subtypes: treasure, 
	 */
	public function resourceSupplyType():Dynamic;
	public function resourceSupplyMax():Int;
	public function resourceGatherRates():Array<Int>;
	public function resourceDropsiteTypes():Array<String>;
	public function garrisonableClasses():Array<String>;
	public function isUnhuntable():Bool;
}
extern class Entity extends EntityTemplate
{
	public function new(baseAI:BaseAI, entity:Dynamic):Void;
	public function toString():String;
	public function id():String;
	public function position():ArrayPoint;
	public function templateName():String;
	public function isIdle():Bool;
	/**
	 * the more hit points a structure has, the more healthy it is
	 * when a structure is under construction, it starts with hitpoints set to 1 and it increases untill completion
	 */
	public function hitpoints():Int;
	public function isHurt():Bool;
	public function needsHeal():Bool;
	public function needsRepair():Bool;
	/**
	 * Returns the current training queue state, of the form
	 * [ { "id": 0, "template": "...", "count": 1, "progress": 0.5, "metadata": ... }, ... ]
	 */
	public function trainingQueue():Array<Dynamic>;
	public function trainingQueueTime():Int;
	public function foundationProgress():Int;
	/**
	 * @return Player object
	 */
	public function owner():Int;
	public function isOwn():Bool;
	public function isFriendly():Bool;
	public function isEnemy():Bool;
	public function resourceSupplyAmount():Dynamic;
	public function resourceCarrying():Dynamic;
	public function garrisoned():EntityCollection;
	public function move(x:Float,z:Float):Entity;
	public function destroy():Entity;
	public function gather(target:Entity):Entity;
	public function repair(target:Entity):Entity;
	public function train(type:String, count:Int, metadata:Dynamic):Entity;
	public function construct(template:String, x:Float, z:Float, angle:Float):Entity;
	public function getMetadata(id:String):Dynamic;
	public function setMetadata(id:String, value:Dynamic):Void;
}
