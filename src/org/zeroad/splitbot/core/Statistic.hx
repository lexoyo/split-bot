/**
 * ...
 * @author lexa
 */

package org.zeroad.splitbot.core;
import org.zeroad.common_api.Entity;
import org.zeroad.common_api.EntityCollection;
import org.zeroad.common_api.ResourceSupply;
import org.zeroad.splitbot.helper.EntityHelper;

class Statistic 
{

	/**
	 * 
	 */
	public static var peopleNumber:Int;
	public static var buildersNumber:Int;
	public static var buildingsNumber:Int;
	public static var foodCount:Int;
	public static var woodCount:Int;
	public static var stoneCount:Int;
	public static var metalCount:Int;
	
	/**
	 * Choose one object among choicesArray elements and return it. 
	 * The element with index idx has the probability percentProbabilities[idx]
	 * @param	choicesArray
	 * @param	percentProbabilities
	 * @return
	 */
	public static function choose(choicesArray:Array<Dynamic>, percentProbabilities:Array<Int>=null):Dynamic
	{
		if (choicesArray.length <= 0)
			return null;
		
		// choose equally
		if (percentProbabilities == null)
		{
			var randomInt:Int = Math.floor(Math.random() * choicesArray.length);
			return choicesArray[randomInt];
		}

		// choose with % probabilities
		var randomPercent:Int = Math.round(Math.random() * 100);
		var choice:Dynamic;
		var idx:Int, value:Int = 0;
		for (idx in 0...percentProbabilities.length)
		{
			value += percentProbabilities[idx];
			if (randomPercent <= value)
			{
				return choicesArray[idx];
			}
		}
		// should be impossible to get here
		return null;
	}
	/**
	 * update statistics with new game data
	 */
	public static function update(botAI:BotAI)
	{
		// food, wood, stone, metal
		var resources:Array<ResourceSupply> = ResourceSupply.getRessourceArray(botAI);
		
		foodCount = resources[0].count;
		woodCount = resources[1].count;
		stoneCount = resources[2].count;
		metalCount = resources[3].count;

		// entities
		var entities:EntityCollection = botAI.entities;
		
		peopleNumber = EntityHelper.myPeopleUnits.length;
		buildersNumber = EntityHelper.myBuilderUnits.length;
		buildingsNumber = EntityHelper.myBuildingStructures.length;
	}
}