package org.zeroad.splitbot.helper;

/**
 * a class used for debugging
 */
class Debug0AD 
{
	private function new(){}
	
	/**
	 * reference to the bot ai
	 */
	private static var botAI:BotAI;
	
	public static inline var activated:Bool = true;
	
	/**
	 * set by BotAI::OnUpdate
	 */
	public static function init(botAI:BotAI)
	{
		Debug0AD.botAI = botAI;
	}
	/**
	 * called by BotAI::OnUpdate
	 * do not keep a reference to the AI, since the game engine serializes everything between turns
	 */
	public static function cleanup()
	{
		Debug0AD.botAI = null;
	}
	/**
	 * log an error
	 */
	public static function error(message:String):Void 
	{
		botAI.chat("SplitBoat ERROR - " + message);
	}
	/**
	 * log a message
	 */
	public static function log(message:String):Void 
	{
		if (activated == true)
		{
			botAI.chat("SplitBoat - " + message);
		}
	}
	/**
	 * log an object
	 */
	public static function inspectObject(object:Dynamic):String
	{
		var str:String = "{";
		var ff:String;
		for( ff in Reflect.fields(object) )
			str += "" + ff + "=" + Reflect.field(object, ff)+", ";
		str += "}";
		return str;
	}
	
}
