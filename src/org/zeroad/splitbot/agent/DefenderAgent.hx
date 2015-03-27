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
 * the defender agent is in charge of the defense of the bot village
 * it detects intrusion and defend the village
 * @author lexa
 */
class DefenderAgent extends Agent 
{
	/**
	 * frequency at which the agent is updated by the sequencer
	 */
	private static inline var DefenderAgentUpdateFrequency:Int = 50;
	/**
	 * the number of turns we tolerate the enemy in the village before being under attack
	 */
	private static inline var ENEMY_PRESENCE_TIME_TOLERANCE:Int = 1;
	/**
	 * the distance from the CC we tolelrate
	 */
	private static inline var ENEMY_DISTANCE_TOLERANCE:Int = 160;
	/**
	 * the time elapsed since the enemy was detected
	 */
	private var _enemyPresenceTime:Int;
	/**
	 * indicates wether the village is under attack
	 */
	public var isUnderAttack:Bool;
	/**
	 * under attack callback, defined by the ChiefAgent
	 * it is called when we are under attack, and we expect the ChiefAgent to provide warriors to defend the village
	 */
	public var onAttackStart:Void->Void;
	/**
	 * attack stopped callback, defined by the ChiefAgent
	 * it is called when an attack has stopped, and we expect the ChiefAgent to take the warriors back
	 */
	public var onAttackStop:Void->Void;
	/**
	 * constructor
	 */
	public function new(botAI:BotAI, parentAgentUID:AgentUID) 
	{
		super(botAI, parentAgentUID);
		_enemyPresenceTime = 0;
		isUnderAttack = false;
		Sequencer.getInstance().addTimer(this, defend, 1, DefenderAgentUpdateFrequency);
	}
	/**
	 * main agent loop
	 */
	public function defend(botAI:BotAI):Void
	{
		// enemy is detected if tehere is a unit nearest than ENEMY_DISTANCE_TOLERANCE
		var nearestOponentEntity:Entity = null;
		var nearestOponentEntityDistance:Float = ENEMY_DISTANCE_TOLERANCE;
		var civCenter:Entity = getCivicCenter();
		if (civCenter != null)
		{
			EntityHelper.enemyEntities.forEach(function (ent:Entity, str:String) 
			{
				var tmpDistance:Float;
				if ((tmpDistance = Utils.VectorDistance(ent.position(), civCenter.position())) < nearestOponentEntityDistance)
				{
					nearestOponentEntityDistance = tmpDistance;
					nearestOponentEntity = ent;
				}
				return false;
			});
		}
			
		// the enemy is detected near the village
		if (nearestOponentEntity != null)
		{
			//Debug0AD.log("nearest enemy is at distance " + nearestOponentEntityDistance + " - " + nearestOponentEntity.templateName());
			// is under attack
			if (_enemyPresenceTime++ > ENEMY_PRESENCE_TIME_TOLERANCE)
			{
				// first time
				if (isUnderAttack == false)
				{
					isUnderAttack = true;
					if (onAttackStart != null)
						onAttackStart();
				}
			}
		}
		else
		{
			// no enemy detected
			if (isUnderAttack == true)
			{
				isUnderAttack = false;
				if (onAttackStop != null)
					onAttackStop();
			}
			_enemyPresenceTime = 0;
		}
	}
}