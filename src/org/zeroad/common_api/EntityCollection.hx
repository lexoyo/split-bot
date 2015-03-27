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
 * This package groups several "extern" classes which link at runtime to 
 * 0A.D. game engine classes exposed to javascript in the common API
 * @author lexa
 */

package org.zeroad.common_api;
import org.zeroad.common_api.Utils;
import org.zeroad.common_api.Entity;

extern class EntityCollection 
{
	private var _entities:Array<Dynamic>;
	private var _ai:Dynamic;
	public var length:Int;
	
	public function new(baseAI:BaseAI, entities:Array<Entity>):Void;
	public function toIdArray():Array<Dynamic>;
	public function toEntityArray():Array<Entity>;
	public function toString():String;
	/**
	 * Returns the (at most) n entities nearest to targetPos.
	 */
	public function filterNearest(targetPos:ArrayPoint, n:Int):EntityCollection;
	/**
	 * @param	callback = function (ent:Entity, id:String)
	 */
	public function filter(callbackFunc:Entity -> String -> Bool):EntityCollection;
	public function filter_raw(callbackFunc:Entity -> String -> Bool):EntityCollection;
	public function forEach(callbackFunc:Entity -> String -> Bool):EntityCollection;
	public function move(x:Float,z:Float):EntityCollection;
	public function destroy():EntityCollection;
	
}