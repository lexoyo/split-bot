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

import org.zeroad.common_api.Utils;

/**
 * This package groups several "extern" classes which link at runtime to 
 * 0A.D. game engine classes exposed to javascript in the common API
 * 
 * State structure, comes from http://trac.wildfiregames.com/wiki/AIEngineAPI
 * @author lexa
 */
typedef State =
{

//	public function new():Void;
//no, only in jubot's gamestate -	public function getPassabilityClassMask(entityType:EntityType):Int;

	public var entities:EntityCollection;
	public var events: Dynamic;
	public var players: Array<Player>;
	public var timeElapsed: Int; // seconds since the start of the match
	public var map: Map;
	public var passabilityClasses:PassabilityClasses;
}
