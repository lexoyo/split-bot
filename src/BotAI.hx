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

//package org.zeroad.splitbot;
package ;
import org.zeroad.common_api.BaseAI;
import org.zeroad.common_api.Entity;
import org.zeroad.common_api.EntityCollection;
import org.zeroad.common_api.Utils;
import org.zeroad.common_api.State;
import org.zeroad.splitbot.agent.Agent;
import org.zeroad.splitbot.agent.BuilderAgent;
import org.zeroad.splitbot.agent.ChiefAgent;
import org.zeroad.splitbot.agent.MachinaSexualAgent;
import org.zeroad.splitbot.agent.WorkerAgent;
import org.zeroad.splitbot.core.Sequencer;
import org.zeroad.splitbot.core.Statistic;
import org.zeroad.splitbot.helper.MapHelper;
import org.zeroad.splitbot.helper.Debug0AD;
import org.zeroad.splitbot.helper.EntityHelper;

/**
 * This class is called directly by the 0 ad game engine, Pyrogenesis
 * @author lexa
 */
class BotAI extends BaseAI
{
	/**
	 * the chief agent, which will create and manage all other bots
	 */
	private var agent1:ChiefAgent;
	
	/**
	 * the state of the simulation
	 * set at the beginning of onUpdate and removed after that
	 */
	public var state:State;
	
	/**
	 * Created by the game engine, 2 times !!
	 * 
	 */
	public function new(settings:Settings) 
	{
		super(settings);

	}
	/**
	 * initialize helpers, call Sequencer::onUpdate and reset helpers
	 */
	override public function OnUpdate(state:State):Void
	{
		super.OnUpdate(state);
		
		// keep track of state
		this.state = state;
		
		// temporary helpers
		MapHelper.init(this);
		Debug0AD.init(this);
		EntityHelper.init(this);
		 
		// update stats
		Statistic.update(this);
		
		// create the 1st chief agent
		if (agent1 == null)
		{
			agent1 = new ChiefAgent(this, null);
			agent1.takeEntities(EntityHelper.myEntities);
		}
			
		// update the sequencer, will call all the callbacks attached with a Sequencer::addTimer method
		Sequencer.getInstance().onUpdate(this);
		
		// cleanup in order not to keep references to game entities etc
		MapHelper.cleanup();
		Debug0AD.cleanup();
		EntityHelper.cleanup();
		
		// cleanup in order not to keep references to game entities etc
		this.state = null;
	}
}
