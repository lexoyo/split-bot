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
import org.zeroad.common_api.Entity;

/**
 * This class is an extern which links at runtime to 
 * 0A.D. game engine classes exposed to javascript in the common API
 * @author lexa
 */
extern class BaseAI 
{
	public function new(settings:Settings):Void;
	public function GetTemplate(name:String):EntityTemplate;
	public function HandleMessage(state:State):Void;
	public function ApplyEntitiesDelta(state:State):Void;
	public function OnUpdate(state:State):Void;
	public function chat(message:String):Void;
	
	private var _rawEntities:Array<EntityCollection>;
	private var _player:Player;
	private var _templates:Array<EntityTemplate>;
	private var _derivedTemplates:Dynamic;
	
	
	public var entities:EntityCollection;
	public var player:Player;
	public var playerData:PlayerData;
	public var templates:Array <EntityTemplate>;
	public var timeElapsed:Int;
	// support 0ad alpha7 and alpha8
	public var map:Map; // alpha7 
	public var passabilityMap:Map; // alpha8
	public var passabilityClasses:Dynamic;

}