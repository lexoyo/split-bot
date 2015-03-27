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
import org.zeroad.splitbot.helper.EntityHelper;

/**
 * the attacker agent is in charge of leading a team of units to the enemy 
 * and destroy units and structures
 * @author lexa
 */
class AttackerAgent extends Agent 
{
	/**
	 * frequency at which the agent is updated by the sequencer
	 */
	private static inline var AttackerAgentUpdateFrequency:Int = 250;
	/**
	 * constructor
	 */
	public function new(botAI:BotAI, parentAgentUID:AgentUID) 
	{
		super(botAI, parentAgentUID);
		Sequencer.getInstance().addTimer(this, attack, 1, AttackerAgentUpdateFrequency);
	}
	
	/**
	 * deconstructor
	 */
	override public function cleanup() 
	{
		super.cleanup();
		Sequencer.getInstance().removeTimer(this, attack);
	}
	
	/**
	 * put all my units to war
	 */
	public function attack(botAI:BotAI):Void
	{
		// take the workers
		var me:Agent = this;
		//var workers:EntityCollection = EntityHelper.myPeopleUnits;

		// take 80% of the men 
		//var maxAttackers:Float = workers.length * 0.8;
//		var numAttackers:Int = 0;
		var attackers:EntityCollection = getMyEntities();
		
		if (attackers == null || attackers.length <= 0)
			return;
		
		// compute the center of troups
		var troupsCenter:Point = new Point(0, 0);
		attackers.forEach(function (ent:Entity, str:String) 
		{
			var point:Point = Point.arrayPoint2Point(ent.position());
			troupsCenter.x += point.x;
			troupsCenter.y += point.y;
			return true;
		});
		troupsCenter.x = troupsCenter.x / attackers.length;
		troupsCenter.y = troupsCenter.y / attackers.length;
		
		// take one oponent's nearest building or unit
		var nearestOponentBuilding:Entity = null;
		var nearestOponentBuildingDistance:Float = Math.POSITIVE_INFINITY;
		//var civCenter:Entity = me.getCivicCenter();
		EntityHelper.enemyEntities.forEach(function (ent:Entity, str:String) 
		{
			var tmpDistance:Float;
			if ((tmpDistance = Utils.VectorDistance(ent.position(), troupsCenter.toArrayPoint())) < nearestOponentBuildingDistance
			)
			{
				nearestOponentBuildingDistance = tmpDistance;
				nearestOponentBuilding = ent;
			}
			return false;
		});
			
		// attack nearest enemy building
		if (nearestOponentBuilding != null)
		{
			//Debug0AD.log("A l'attaaaaaaaaque!!!!!! " + attackers.length +" - " + Math.round(nearestOponentBuildingDistance) + " - " + nearestOponentBuilding.templateName() + " - " + nearestOponentBuilding.civ());
			
			// not all the way to the target
			var targetPoint:Point = Point.arrayPoint2Point(nearestOponentBuilding.position());
/*			var civCenterPoint:Point = Point.arrayPoint2Point(civCenter.position());
			var targetPolar:PolarCoord = targetPoint.toPolarCoord(civCenterPoint.x, civCenterPoint.y);
			targetPolar.distance *= 0.5;
			targetPoint = targetPolar.toPoint();
			targetPoint.x += civCenterPoint.x;
			targetPoint.y += civCenterPoint.y;
*/			
			attackers.move(targetPoint.x, targetPoint.y);
		}
		else
		{
			Debug0AD.error("Attack failed: impossible to find the nearest enemy building");
		}
	}
}