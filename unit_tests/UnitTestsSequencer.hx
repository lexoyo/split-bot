import org.zeroad.splitbot.core.Sequencer;
import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class UnitTestsSequencer 
{
    
    public function new()
	{
        var runner = new Runner();
        runner.addCase(this);
        Report.create(runner);
        runner.run();
    }
        
	/**
	 * an array to test the sequencer
	 */
	public var sequencerTestArray:Array<String>;
	/**
	 * unit tests 
	 */
    public function testSequencer() 
	{
		/////////////////////////////////////////////
		// Sequencer
		/////////////////////////////////////////////
		
		// get the singleton
		var sequencer:Sequencer = Sequencer.getInstance();
		
		// ** 
		// timers
		// ** 
		// init
		sequencerTestArray = new Array();
		// adds one timer in the next turn
		sequencer.addTimer(this, sequencerTestCallback);
		// adds one timer in 2 turns, which fires every turn after the 2nd turn
		sequencer.addTimer(this, sequencerTestCallback, 2, 1);

		// 1st turn
		Assert.equals(0, sequencerTestArray.length);
		sequencer.onUpdate(null);
		Assert.equals(1, sequencerTestArray.length);
		// new turn
		sequencer.onUpdate(null);
		Assert.equals(2, sequencerTestArray.length);
		// new turn
		sequencer.addTimer(this, sequencerTestCallback, 2, 2);
		sequencer.onUpdate(null);
		Assert.equals(3, sequencerTestArray.length);
		// new turn
		sequencer.onUpdate(null);
		Assert.equals(5, sequencerTestArray.length);
		// new turn
		sequencer.onUpdate(null);
		Assert.equals(6, sequencerTestArray.length);
		// new turn
		sequencer.onUpdate(null);
		Assert.equals(8, sequencerTestArray.length);
		// remove 1 timer
		sequencer.removeTimer(this, sequencerTestCallback);
		sequencer.onUpdate(null);
		Assert.equals(8, sequencerTestArray.length);
		// remove the last timer
		sequencer.removeTimer(this, sequencerTestCallback);
		sequencer.onUpdate(null);
		Assert.equals(8, sequencerTestArray.length);
		sequencer.onUpdate(null);

		// ** 
		// sequences
		// ** 
		// init
		sequencerTestArray = new Array();
		// add sequences 
		sequencer.addSequence(this, sequencerTestCallback);
		sequencer.addSequence(this, sequencerTestCallback);
		sequencer.addSequence(this, sequencerTestCallback);
		sequencer.onUpdate(null);
		
		// 1st sequence started
		Assert.equals(1, sequencerTestArray.length);
		sequencer.onUpdate(null);
		
		// 1st sequence end = 2d sequence start
		sequencer.nextSequence();
		sequencer.onUpdate(null);
		Assert.equals(2, sequencerTestArray.length);
		
		// 2d sequence end with a remove => 3d sequence start
		sequencer.removeSequence(this, sequencerTestCallback);
		Assert.equals(2, sequencerTestArray.length);
		sequencer.onUpdate(null);
		Assert.equals(3, sequencerTestArray.length);
		
		// 3d sequence ends
		sequencer.nextSequence();
		sequencer.onUpdate(null);
		Assert.equals(3, sequencerTestArray.length);
		sequencer.onUpdate(null);
		Assert.equals(3, sequencerTestArray.length);
    }
	/**
	 * callback for tests of the sequencer
	 * adds an item to sequencerTestArray
	 */
	public function sequencerTestCallback(botAi:Dynamic)
	{
		sequencerTestArray.push("sequence !!");
	}
}