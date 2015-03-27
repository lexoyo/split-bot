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
 * This class is used to have sequences started one after another, or after a given number of turns
 * It is a singleton
 * @author lexa
 */

package org.zeroad.splitbot.core;
import org.zeroad.splitbot.helper.Debug0AD;

class Sequencer 
{
	private static var _instance:Sequencer;
	public var turnNumber:Int;
	private var _sequenceArray:Array<Sequence>;
	private var _timerArray:Array<Sequence>;
	private var _isPlayingSequence:Bool;
	private function new() 
	{
		_timerArray = new Array();
		_sequenceArray = new Array();
		_isPlayingSequence = false;
		turnNumber = 0;
	}
	public static function getInstance():Sequencer
	{
		if (_instance == null)
			_instance = new Sequencer();
		return _instance;
	}
	/**
	 * call this every turn
	 */
	public function onUpdate(botAi:BotAI)
	{
		turnNumber++;
		_checkTimers(botAi);
		_checkSequences(botAi);
	}
	/**
	 * check if a sequence should be started
	 */
	private function _checkSequences(botAi:BotAI)
	{
		if (_sequenceArray.length > 0)
		{
			// start the next sequence
			if (_sequenceArray[0].started == false)
			{
				_isPlayingSequence = true;
				
				// started flag
				_sequenceArray[0].started = true;
				
				// call the callback
				Reflect.callMethod(_sequenceArray[0].callerObject, _sequenceArray[0].callbackFunc, [botAi]);
			}
		}
		else
		{
			// stops because there is nothing to play anymore
			_isPlayingSequence = false;
		}
	}
	/**
	 * check if timers should be called
	 */
	private function _checkTimers(botAi:BotAI)
	{
		var idx:Int;
		var length:Int = _timerArray.length;
		var elementsToRemoveArray:Array<Sequence> = new Array();
		
		for (idx in 0...length)
		{
			// bug fix "timerArray error when attack starts" => check if _timerArray[idx] is null 
			if (_timerArray[idx] != null && _timerArray[idx].nextTurn <= turnNumber)
			{
				// call the callback
				Reflect.callMethod(_timerArray[idx].callerObject, _timerArray[idx].callbackFunc, [botAi]);
				// recurrence
				if (_timerArray[idx].recurrence > 0)
				{
					_timerArray[idx].nextTurn = turnNumber + _timerArray[idx].recurrence;
				}
				else
				{
					elementsToRemoveArray.push(_timerArray[idx]);
				}
			}
		}		
		while (elementsToRemoveArray.length > 0)
		{
			var sequence:Sequence = elementsToRemoveArray.shift();
			removeTimer(sequence.callerObject, sequence.callbackFunc);
		}
	}
	/**
	 * Add a timer, which will be called in a given amount of turns
	 * It may be recurrent, then call removeTimer to stop it
	 * @param	callerObject
	 * @param	callbackFunc
	 * @param	argumentsArray
	 * @param	nextTurn	Indicates in how many turn this sequence should be executed for the 1st time
	 * @param	recurrence
	 */
	public function addTimer(callerObject:Dynamic, callbackFunc:BotAI -> Void, startInNTurns : Int=1, recurrence : Int=-1)
	{
		// add sequence
		var sequence:Sequence = { started : false, callerObject : callerObject, callbackFunc : callbackFunc, nextTurn : turnNumber + startInNTurns, recurrence : recurrence};
		_timerArray.push(sequence);
	}
	/**
	 * Remove the given timer, i.e. stop it
	 * @param	callerObject
	 * @param	callbackFunc
	 */
	public function removeTimer(callerObject:Dynamic, callbackFunc:BotAI -> Void)
	{
		var idx:Int;
		var length:Int = _timerArray.length;
		for (idx in 0...length)
		{
			if (_timerArray[idx].callerObject == callerObject 
				&& Reflect.compareMethods(_timerArray[idx].callbackFunc, callbackFunc))
			{
				// then remove it
				_timerArray.splice(idx, 1);
				// and stop searching
				break;
			}
		}
	}
	/**
	 * Add a sequence to the sequencer
	 * You are supposed to call remove after that callbackFunc has been called 
	 * @param	callbackFunc	the callback to call when the sequence starts
	 * @param	argumentsArray	the arguments to pass to the callback
	 */
	public function addSequence(callerObject:Dynamic, callbackFunc:BotAI -> Void)
	{
		// add sequence
		var sequence:Sequence = { started : false, callerObject : callerObject, callbackFunc : callbackFunc, nextTurn : -1, recurrence : -1};
		_sequenceArray.push(sequence);
		
		// start playing if needed
		if (_isPlayingSequence == false)
			nextSequence();
	}
	/**
	 * Remove the given sequence and start to play the next one if needed
	 * @param	callerObject
	 * @param	callbackFunc
	 */
	public function removeSequence(callerObject:Dynamic, callbackFunc:BotAI -> Void)
	{
		var idx:Int;
		var length:Int = _sequenceArray.length;
		for (idx in 0...length)
		{
			if (_sequenceArray[idx].callerObject == callerObject 
				&& Reflect.compareMethods(_sequenceArray[idx].callbackFunc, callbackFunc)
				/*&& _sequenceArray[idx].argumentsArray == argumentsArray*/)
			{
				// then remove it
				_sequenceArray.splice(idx, 1);
				// and stop searching
				break;
			}
		}
		// start playing if needed
		if (_sequenceArray.length > 0 && _sequenceArray[0].started == false)
			nextSequence();
	}
	/**
	 * If the next sequence has allready been called, then remove it
	 * Call the callback of the next sequence
	 */
	public function nextSequence()
	{
		if (_sequenceArray.length == 0)
			return;
		
		// check if the next sequence has allready been called
		if (_sequenceArray[0].started == true)
			// then remove it
			_sequenceArray.shift();
	}
}
/**
 * structure used to store the details about a sequence 
 */
typedef Sequence = {
	var started:Bool;
	var callerObject:Dynamic;
	var callbackFunc:BotAI -> Void;
	var nextTurn:Int;
	var recurrence:Int;
}