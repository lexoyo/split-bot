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

package org.zeroad.splitbot.helper;

import org.zeroad.common_api.BaseAI;
import org.zeroad.common_api.EntityTypeValues;
import org.zeroad.common_api.Utils;
import org.zeroad.splitbot.core.Point;
import org.zeroad.splitbot.helper.Debug0AD;

/**
 * Class with useful methods for map manipulation
 * @author lexa
 */
class MapHelper 
{
	public static inline var TILE_SIZE:Int = 4;
	/**
	 * reference to the map
	 * updated by BotAI::OnUpdate
	 */
	public static var passabilityMap:Map;
	/**
	 * reference to the BaseAI::passabilityClasses
	 * updated by BotAI::OnUpdate
	 */
	public static var passabilityClasses:Dynamic;
	
	/**
	 * this class is static, do not create an instance
	 */
	private function new(){}
	
	/**
	 * called by BotAI::OnUpdate
	 */
	public static function init(botAI:BotAI)
	{
		MapHelper.passabilityClasses = botAI.passabilityClasses;
		
		// support 0ad alpha7 and alpha8
		if (botAI.map != null) // alpha7
			MapHelper.passabilityMap = botAI.map;
		else // alpha8
			MapHelper.passabilityMap = botAI.passabilityMap;
	}
	/**
	 * called by BotAI::OnUpdate
	 * do not keep a reference to the AI, since the game engine serializes everything between turns
	 */
	public static function cleanup()
	{
		MapHelper.passabilityClasses = null;
		MapHelper.passabilityMap = null;
	}
	/**
	 * retrive the obstruction mask of a Map object at a given position for a given type of entity
	 * @return	true if you can't place any unit of this type there
	 */
	static public function isObstructed1Point(x:Float, y:Float, obstructionMask:Int):Bool
	{
		var mapData:Int = getMapDataAtCoord(x, y);

		// it is obstructed if it is out of the map
		if (mapData == null)
			return true;

		return mapData & obstructionMask > 0;
	}
	/**
	 * Retrieve the obstruction mask of a Map object at a given position for a given type of entity.
	 * This function checks the obstruction for the 4 corners of the building.
	 * @return	true if you can't place any unit of this type there
	 */
	static public function isObstructed(point:Point, width:Float, height:Float, entityTypes:Array<EntityType>):Bool
	{
		if (entityTypes.length <= 0) return null;
		
		// build the obstruction mask for this map for all the types of entityTypes
		var idx:Int;
		var obstructionMask:Int = getPassabilityClassMask(entityTypes[0]);
		for (idx in 1...entityTypes.length)
		{
			obstructionMask |= getPassabilityClassMask(entityTypes[idx]);
		}
		
/*
		// Get the bitmask for all tiles 
		var left:Int = Math.floor(point.x - (width / 2.0));
		var right:Int = Math.ceil(left + width);
		var top:Int =  Math.floor(point.y - (height / 2.0));
		var bottom:Int =  Math.ceil(top + height);
		
		if (isObstructed1Point(point.x, point.y, obstructionMask)
			|| isObstructed1Point(top, left, obstructionMask)
			|| isObstructed1Point(top, right, obstructionMask)
			|| isObstructed1Point(bottom, left, obstructionMask)
			|| isObstructed1Point(bottom, right, obstructionMask)
		)
		{
			//Debug0AD.log("isObstructed TRUE " + point.x + "," + point.y + " -> " + Std.string(getMapDataAtCoord(point.x, point.y) & obstructionMask) + " - " + left + "," + right + "' - " + width + "," + height);
			return true;
		}
		
		//Debug0AD.log("isObstructed FALSE '" + point.x+","+point.y + "' - "+ left+","+right + "' - "+ width+","+height);
		return false;
*/

		// Get the bitmask for all "pixels" 
		var left:Int = Math.floor(point.x - (width / 2.0));
		var right:Int = Math.ceil(left + width);
		var top:Int =  Math.floor(point.y - (height / 2.0));
		var bottom:Int =  Math.ceil(top + height);
		
		var posX:Int, posY:Int;
		
		for (posX in left...right)
		{
			for (posY in top...bottom)
			{
				if (isObstructed1Point(posY, posX, obstructionMask))
					return true;
			}
		}
		//Debug0AD.log("isObstructed FALSE '" + point.x+","+point.y + "' - "+ left+","+right + "' - "+ width+","+height);
		return false;
	}
	/**
	 * comes from JuBot's GameState class
	 * @param	name
	 */
	static public function getPassabilityClassMask(name:String):Int
	{
		if (!(Reflect.hasField(passabilityClasses, name)))
			Debug0AD.error("Tried to use invalid passability class name '" + name + "'");
			
		return Reflect.field(passabilityClasses, name);
	}
	/**
	 * get the bitmask for tile at the given position
	 */
//	static function getMapDataAtCoord(point:Point):Int
	static function getMapDataAtCoord(x:Float, y:Float):Int
	{
//		var arrayPoint:ArrayPoint = point.toArrayPoint();
		// copute the position in the map data array
//		var position1D:Int = Math.round((x + MapHelper.passabilityMap.width * y)/MapHelper.TILE_SIZE);
		
		// quantumstate fix from http://www.wildfiregames.com/forum/index.php?showtopic=15121&st=30
		// fixes an approximation bug
		var scaledX:Int = Math.round(x / MapHelper.TILE_SIZE);
		var scaledY:Int = Math.round(y / MapHelper.TILE_SIZE);
		var position1D:Int = scaledX + MapHelper.passabilityMap.width * scaledY;
		
		// it is obstructed if it is out of the map
		if (position1D >= MapHelper.passabilityMap.data.length || position1D < 0)
			return null;

		// returns the map data at this point
		return MapHelper.passabilityMap.data[position1D];
	}
	/**
	 * determine if a point is in the map boundaries or not
	 */
//	static function isInTheMap(point:Point):Bool
	static function isInTheMap(x:Float, y:Float):Bool
	{
		return x < 0 || y < 0 || ((x + MapHelper.passabilityMap.width * y) / MapHelper.TILE_SIZE) < MapHelper.passabilityMap.data.length;
	}
}