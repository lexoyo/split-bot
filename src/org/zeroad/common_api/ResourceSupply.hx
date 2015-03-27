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

/**
 * This package groups several "extern" classes which link at runtime to 
 * 0A.D. game engine classes exposed to javascript in the common API
 * @author lexa
 */
class ResourceSupply
{
	public function new(resourceSupplyType:ResourceSupplyType, resourceSupplySubType:ResourceSupplySubType, resourceCount:Int)
	{
		generic = resourceSupplyType;
		specific = resourceSupplySubType;
		count = resourceCount;
	}
	/**
	 * returns the current count of each resource, in that order: food, wood, stone, metal
	 */
	public static function getRessourceArray(botAI:BotAI):Array<ResourceSupply>
	{
		return [
			new ResourceSupply(ResourceSupplyTypeValue.FOOD, "", Reflect.field(botAI.playerData.resourceCounts, ResourceSupplyTypeValue.FOOD)),
			new ResourceSupply(ResourceSupplyTypeValue.WOOD, "", Reflect.field(botAI.playerData.resourceCounts, ResourceSupplyTypeValue.WOOD)),
			new ResourceSupply(ResourceSupplyTypeValue.STONE, "", Reflect.field(botAI.playerData.resourceCounts, ResourceSupplyTypeValue.STONE)),
			new ResourceSupply(ResourceSupplyTypeValue.METAL, "", Reflect.field(botAI.playerData.resourceCounts, ResourceSupplyTypeValue.METAL))
		];
	}
	public var generic:ResourceSupplyType;
	public var specific:ResourceSupplySubType;
	public var count:Int;
}
class ResourceSupplyTypeValue
{
	public static inline var FOOD:String = "food";
	public static inline var WOOD:String = "wood";
	public static inline var STONE:String = "stone";
	public static inline var METAL:String = "metal";
}
typedef ResourceSupplyType = String;
typedef ResourceSupplySubType = String;