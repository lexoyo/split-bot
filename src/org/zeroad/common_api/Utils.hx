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

package org.zeroad.common_api;

import org.zeroad.common_api.Entity;
import org.zeroad.common_api.ResourceSupply;

/**
 * this class is a placeholder for several useful global functions
 * these functions are present in 0A.D. common API and they are grouped here in a class
 * @author lexa
 */
class Utils 
{
	
	/**
	 * this class is static, do not create an instance
	 */
	private function new() {}
	/**
	 * compute the distance between 2 points
	 */
	public static function VectorDistance(a:ArrayPoint, b:ArrayPoint):Float
	{
		var dx = a[0] - b[0];
		var dz = a[1] - b[1];
		return Math.sqrt(dx*dx + dz*dz);
	}
	public static function applyCiv(civ:String, templateName:String):String
	{
		return civ + "_" + templateName;
	}
	/**
	 * look if the given element is in the array
	 */
	public static function isInArray(array:Array<Dynamic>, element:Dynamic):Bool
	{
		var idx:Int = 0;
		while (idx < array.length && array[idx] != element)
		{
			idx++;
		}
		return idx < array.length;
	}
	
}

typedef ArrayPoint = Array<Float>;

// non, EntityTemplate instead of: typedef Template = Dynamic;

/*
 * Structure, comes from http://trac.wildfiregames.com/wiki/AIEngineAPI
 * "pathfinderObstruction": 1,
 * "foundationObstruction": 2,
 * "building-land": ..., // these are all the PassabilityClasses defined in simulation/data/pathfinder.xml
 * ...
 */
typedef PassabilityClasses = Dynamic;

typedef Player = PlayerData;

/**
 * Map structure, comes from http://trac.wildfiregames.com/wiki/AIEngineAPI
 */
typedef Map = {
	/**
	 * has to be multiplied by 4
	 */
	var width:Int;
	/**
	 * has to be multiplied by 4
	 */
	var height:Int;
	var data:Array<Int>; // Uint16Array with width*height entries
};

/**
 * Settings passed to the entry point of the application by the game engine
 */
typedef Settings = { 
	var player:Player;
	var templates:Array<EntityTemplate>;
};
typedef PlayerData = { 
	var name:String;
	var civ:String;
	var colour:Dynamic;
	var resourceCounts:Dynamic;
	var popCount:Int;
	var popLimit:Int;
	var trainingQueueBlocked:Bool;
	var state:String; // active
	var phase:String; // village
	var team:Int;
	var isAlly:Array<Bool>;
	var isEnemy:Array<Bool>;
};
