import org.zeroad.splitbot.core.Point;
import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class UnitTestsPoint 
{
    
    public function new()
	{
        var runner = new Runner();
        runner.addCase(this);
        Report.create(runner);
        runner.run();
    }
        
	/**
	 * unit tests 
	 */
    public function testPoint() 
	{
		var xOffset:Float, yOffset:Float, angleOffset:Float;
		// case of a coordinate system which is in (10,0) and with a rotation of PI so that the 0° goes through (0,0)
		// coord of the polar coor system center in the cartesian coord system
		//var originPoint:Point; 
		// coord of the cartesian coor system center in the polar coord system
		//var originepolarCoord:PolarCoord;
		// simple conversion from (10,0) <-> (10,0)
		Assert.isTrue(checkThisPolarCoord(new PolarCoord(10, 0), (new Point(10, 0)).toPolarCoord()));
		Assert.isTrue(checkThisPoint(new Point(10, 0), (new PolarCoord(10, 0)).toPoint()));
		Assert.isTrue(checkThisPolarCoord(new PolarCoord(10, Math.PI/2), (new Point(0, 10)).toPolarCoord()));
		Assert.isTrue(checkThisPoint(new Point(0, 10), (new PolarCoord(10, Math.PI/2.0)).toPoint()));
		// with offset and rotation 
		Assert.isTrue(checkThisPoint(new Point(0, 0), (new PolarCoord(10, 0)).toPoint(10,0,Math.PI)));
		Assert.isTrue(checkThisPoint(new Point(0, 0), (new PolarCoord(10, 0)).toPoint(0,10,Math.PI/2)));
		Assert.isTrue(checkThisPolarCoord(new PolarCoord(10, 0), (new Point(0, 0)).toPolarCoord(10,0,Math.PI)));
		Assert.isTrue(checkThisPolarCoord(new PolarCoord(10, 0), (new Point(0, 0)).toPolarCoord(0,10,-Math.PI/2)));
		
		// case of a coordinate system which is in (10,10) and with a rotation of 5PI/4 so that the 0° goes through (0,0)
	}
	
	private function checkThisPolarCoord(pc1:PolarCoord, pc2:PolarCoord):Bool
	{
		Assert.floatEquals(pc1.distance, pc2.distance);
		Assert.floatEquals(pc1.angle, pc2.angle);
		return Math.abs(pc1.distance - pc2.distance) < 0.0001 && Math.abs(pc1.angle - pc2.angle) < 0.0001;
	}
	private function checkThisPoint(pc1:Point, pc2:Point):Bool
	{
		Assert.floatEquals(pc1.x, pc2.x);
		Assert.floatEquals(pc1.y, pc2.y);
		return Math.abs(pc1.x - pc2.x) < 0.0001 && Math.abs(pc1.y - pc2.y) < 0.0001;
	}
}