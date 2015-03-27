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
package ;

import js.Lib;

import org.zeroad.common_api.BaseAI;
import org.zeroad.common_api.Utils;

/**
 * This class is unused, only for compilation
 * The game engine creates directly an instance of BotAI
 * @author lexa
 */

class Main 
{
	static var botAI:BotAI;
	static var settings:Settings = {player:null,templates:[]};
	static function main() 
	{ 
		botAI = new BotAI(settings);
	}
	
}