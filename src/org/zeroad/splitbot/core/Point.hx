package org.zeroad.splitbot.core;

import org.zeroad.common_api.Utils;

class Point 
{

	public var x:Float;
	public var y:Float;
	
	public function new(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
	}
	public function toArrayPoint():ArrayPoint
	{
		return [x,y,0];
	}
	public function toPolarCoord(xOffset:Float = 0, yOffset:Float = 0, angleOffset:Float = 0):PolarCoord
	{
		var distance:Float = Math.sqrt((Math.pow(x - xOffset, 2) + Math.pow(y - yOffset, 2)));
		var angle:Float = angleOffset;
		
		if (distance != 0)
			angle += Math.acos((x - xOffset) / distance);
		
		return new PolarCoord(distance, angle % (2*Math.PI));
	}
	public static function arrayPoint2Point(ap:ArrayPoint):Point
	{
		return new Point(ap[0],ap[1]);
	}
}
class PolarCoord
{
	/**
	 * distance from the point (0,0)
	 */
	public var distance:Float;
	/**
	 * angle in radians
	 */
	public var angle:Float;
	
	public function new(distance:Float, angle:Float)
	{
		this.distance = distance;
		this.angle = angle % (2*Math.PI);
	}
	/**
	 * convert into Point, given the rotation of the coordinate system
	 */
	public function toPoint(xOffset:Float = 0, yOffset:Float = 0, angleOffset:Float = 0):Point
	{
		var correctedAngle:Float = angle - angleOffset;
		return new Point(distance * Math.cos(correctedAngle) + xOffset, distance * Math.sin(correctedAngle) + yOffset);
	}
	
}