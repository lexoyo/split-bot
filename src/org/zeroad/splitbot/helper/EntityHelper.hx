package org.zeroad.splitbot.helper;

import org.zeroad.common_api.Entity;
import org.zeroad.common_api.EntityCollection;
import org.zeroad.common_api.Utils;

class EntityHelper 
{
	private function new(){}
	
	/**
	 * passability classes
	 * comes from 0ad\binaries\data\mods\public\simulation\data\pathfinder.xml
	 */
	public static inline var FOUNDATION_OBSTRUCTION:String = "foundationObstruction";
	public static inline var BUILDING_LAND_OBSTRUCTION:String =  "building-land";
	public static inline var PATHFINDER_OBSTRUCTION:String =  "pathfinderObstruction";
	public static inline var DEFAULT_OBSTRUCTION:String =  "default";
	public static inline var SHIP_OBSTRUCTION:String =  "ship";
	public static inline var BUILDING_SHORE_OBSTRUCTION:String =  "building-shore";
	public static inline var UNRESTRICTED_OBSTRUCTION:String =  "unrestricted";
	
	/**
	 * entity class names
	 */
	static public inline var CLASS_STRUCTURE:String = "Structure";
	static public inline var CLASS_MECHANICAL:String = "Mechanical";
	static public inline var CLASS_SIEGE:String = "Siege";
	static public inline var CLASS_BUILDER:String = "Builder";
	static public inline var CLASS_WORKER:String = "Worker";
	static public inline var CLASS_CITIZEN_SOLDIER:String = "CitizenSoldier";
/*
javelinist
	Ranged
	Cavalry CitizenSoldier Organic
	Unit ConquestCritical
	
wooman
	Worker
	Support Organic
	Unit ConquestCritical
	
Hero
	Hero Cavalry
	Cavalry
	Super Organic
	Unit ConquestCritical
*/	
	
	/**
	 * entity collections
	 */
	public static var enemyEntities:EntityCollection;
	public static var myEntities:EntityCollection;
	public static var myPeopleUnits:EntityCollection;
	public static var myBuilderUnits:EntityCollection;
	public static var myBuildingStructures:EntityCollection;
	
	/**
	 * civilizations 
	 */
	static public inline var CIV_HELE:String = "hele";
	static public inline var CIV_CELT:String = "celt";
	static public inline var CIV_IBER:String = "iber";
	static public inline var CIV_CART:String = "cart";
	static public inline var CIV_GAIA:String = "gaia";
	/**
	 * civic center template
	 */
	static public var TEMPLATE_STRUCTURE_CIVIC_CENTER:String;

	/**
	 * towers and walls
	 */
	static public var TEMPLATE_STRUCTURE_SCOUT_TOWER:String;
	static public var TEMPLATE_STRUCTURE_WALL:String;
	static public var TEMPLATE_STRUCTURE_WALL_TOWER:String;
	/**
	 * fortress template
	 */
	static public var TEMPLATE_STRUCTURE_FORTRESS:String;
	/**
	 * barracks template
	 */
	static public var TEMPLATE_STRUCTURE_BARRACKS:String;
	/**
	 * houses template
	 */
	static public var TEMPLATE_STRUCTURE_HOUSE:String;
	/**
	 * fields template
	 */
	static public var TEMPLATE_STRUCTURE_FIELD:String;
	/**
	 * weemen template
	 */
	static public var UNIT_SUPPORT_FEMALE_CITIZEN:String;
	/**
	 * unit template
	 */
	static public var UNIT_CAVALRY_JAVELINIST:String;
	/**
	 * unit template
	 */
	static public var UNIT_CAVALRY_SPEARMAN:String;
	/**
	 * unit template
	 */
	static public var UNIT_CAVALRY_SWORDSMAN:String;
	/**
	 * unit template
	 */
	static public var UNIT_CHAMPION_CAVALRY_BRIT:String;
	/**
	 * unit template
	 */
	static public var UNIT_CHAMPION_CAVALRY_GAUL:String;
	/**
	 * attack templates
	 */
	static public var TEMPLATE_STRUCTURE_ATTACK_ARRAY:Array<String>;
	/**
	 * called by BotAI::OnUpdate at each turn
	 */
	public static function init(botAI:BotAI)
	{
		// init the constants with civilization (to do: should be done only one time, not at each turn like this)
		TEMPLATE_STRUCTURE_CIVIC_CENTER = "structures/"+Utils.applyCiv(botAI.playerData.civ, "civil_centre");
		TEMPLATE_STRUCTURE_HOUSE = "structures/" + Utils.applyCiv(botAI.playerData.civ, "house");
		TEMPLATE_STRUCTURE_FIELD = "structures/" + Utils.applyCiv(botAI.playerData.civ, "field");
		TEMPLATE_STRUCTURE_FORTRESS = "structures/" + Utils.applyCiv(botAI.playerData.civ, "fortress");
		TEMPLATE_STRUCTURE_SCOUT_TOWER = "structures/" + Utils.applyCiv(botAI.playerData.civ, "scout_tower");
		TEMPLATE_STRUCTURE_WALL = "structures/" + Utils.applyCiv(botAI.playerData.civ, "wall");
		TEMPLATE_STRUCTURE_WALL_TOWER = "structures/" + Utils.applyCiv(botAI.playerData.civ, "wall_tower");
		TEMPLATE_STRUCTURE_BARRACKS = "structures/" + Utils.applyCiv(botAI.playerData.civ, "barracks");
		UNIT_SUPPORT_FEMALE_CITIZEN = "units/" + Utils.applyCiv(botAI.playerData.civ, "support_female_citizen");
		UNIT_CAVALRY_JAVELINIST = "units/" + Utils.applyCiv(botAI.playerData.civ, "cavalry_javelinist_b");
		UNIT_CAVALRY_SPEARMAN = "units/" + Utils.applyCiv(botAI.playerData.civ, "cavalry_spearman_b");
		UNIT_CAVALRY_SWORDSMAN = "units/" + Utils.applyCiv(botAI.playerData.civ, "cavalry_swordsman_b");
		UNIT_CHAMPION_CAVALRY_BRIT = "units/" + Utils.applyCiv(botAI.playerData.civ, "champion_cavalry_brit");
		UNIT_CHAMPION_CAVALRY_GAUL = "units/" + Utils.applyCiv(botAI.playerData.civ, "champion_cavalry_gaul");
		
		// attack structures
		switch(botAI.playerData.civ)
		{
			case EntityHelper.CIV_HELE:
				TEMPLATE_STRUCTURE_ATTACK_ARRAY = ["structures/hele_tholos", "structures/hele_fortress", "structures/hele_gymnasion"];
			case EntityHelper.CIV_CELT:
				TEMPLATE_STRUCTURE_ATTACK_ARRAY = ["structures/celt_fortress_g", "structures/celt_fortress_b", "structures/celt_kennel"];
			case EntityHelper.CIV_IBER:
				TEMPLATE_STRUCTURE_ATTACK_ARRAY = ["structures/iber_fortress"];
			case EntityHelper.CIV_CART:
				TEMPLATE_STRUCTURE_ATTACK_ARRAY = ["structures/cart_fortress"];
		}
		
		// filter units
		enemyEntities = botAI.entities.filter(function(ent:Entity, str:String) 
		{
			return !ent.isOwn() && ent.isEnemy() && ent.owner() > 0 && !ent.isFriendly() 
				&& ent.civ() != EntityHelper.CIV_GAIA;
		} );
		myEntities = botAI.entities.filter(function(ent:Entity, str:String) 
		{ 
			return ent.isOwn();
		} );
		myPeopleUnits = myEntities.filter(function(ent:Entity, str:String) 
		{ 
			return ent.isHealable();
		} );
		myBuilderUnits = myPeopleUnits.filter(function(ent:Entity, str:String) 
		{ 
			return ent.buildableEntities() != null;
		} );
		myBuildingStructures = myEntities.filter(function(ent:Entity, str:String) 
		{ 
			return ent.trainableEntities() != null || ent.foundationProgress() != null;
		} );
	}
	/**
	 * called by BotAI::OnUpdate
	 * do not keep a reference to the AI, since the game engine serializes everything between turns
	 */
	public static function cleanup()
	{
		// filter units
		enemyEntities = null;
		myEntities = null;
		myPeopleUnits = null;
		myBuilderUnits = null;
		myBuildingStructures = null;
	}
	/**
	 * determine if all the required classes are in the entity classes
	 */	
	static public function hasClasses(entity:Entity, requiredClasses:Array<String>):Bool
	{
		var idx:Int;
		for (idx in 0...requiredClasses.length)
		{
			if (entity.hasClass(requiredClasses[idx]) == false)
				return false;
		}
		return true;
	}
	/**
	 * determine if one of the allowed classes are in the entity classes
	 */	
	static public function hasOneOfTheClasses(entity:Entity, classesAllowed:Array<String>):Bool
	{
		var idx:Int;
		for (idx in 0...classesAllowed.length)
		{
			if (entity.hasClass(classesAllowed[idx]) == true)
				return true;
		}
		return false;
	}
}