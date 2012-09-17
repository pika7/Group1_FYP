/* this class shows a lifebar in the corner */

package ui 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.Registry;
	import actors.Player;
	
	public class LifeBar extends FlxGroup
	{
		private const START_BAR:int = 590; // x coordinate of the bar
		private const BAR_LENGTH:int = 200; // length of the bar
		private const DEGEN_INTERVAL:int = 10; // the time between each degen "tick"
		private const START_DEGEN_DELAY:int = 250; // how long it takes before the damage bar begins to degen
		
		private var lifeBorder:LifeBorder;
		private var bar:FlxBar;
		
		/* these variables deal with the "red" part of the lifebar after getting hit */
		private var degenTimer:FlxDelay;
		private var startDegenTimer:FlxDelay;
		private var damageBar:FlxBar;
		private var startDamageBar:int;
		public var damageValue:int; // the actual value of the damage bar, needs to be public because FlxBar dumb
		public var health:int; // the health of the normal bar, needs to be public because FlxBar dumb
		
		
		
		public function LifeBar() 
		{
			super();
			
			degenTimer = new FlxDelay(DEGEN_INTERVAL);
			degenTimer.callback = degenDamageBar;
			
			startDegenTimer = new FlxDelay(START_DEGEN_DELAY);
			startDegenTimer.callback = startDegenDamageBar;
			
			health = Registry.gameStats.STARTING_LIFE;
			
			bar = new FlxBar(590, 10, FlxBar.FILL_LEFT_TO_RIGHT, BAR_LENGTH, 20, this, "health", 0, 100, false);
			bar.createFilledBar(0xff000000, 0xff11cc11);
			bar.scrollFactor.x = 0;
			bar.scrollFactor.y = 0;
			
			startDamageBar = START_BAR + BAR_LENGTH;
			damageValue = 0;
			damageBar = new FlxBar(590, 10, FlxBar.FILL_LEFT_TO_RIGHT, BAR_LENGTH, 20, this, "damageValue", 0, 100, false);
			damageBar.createFilledBar(0x00000000, 0xffCC0000);
			damageBar.scrollFactor.x = 0;
			damageBar.scrollFactor.y = 0;
			
			/* add all the things */
			add(bar);
			add(damageBar);
			add(lifeBorder = new LifeBorder(590, 10));
		}
		
		override public function update():void  
		{
			/* stupid bit because it does weird things when the damageValue is 0 */
			if (damageValue == 0)
			{
				damageBar.visible = false;
			}
			else
			{
				damageBar.visible = true;
			}
			
			/* move the start of the damageBar to the end of the health (green part) */
			damageBar.x = START_BAR + (health * 2); // each 1 point of health is 2 px
			
			super.update();
		}
		
		public function damage(amount:int):void
		{
			if (!startDegenTimer.isRunning)
			{
				startDegenTimer.start();
			}
			damageValue += amount;
			health -= amount;
		}
		
		public function heal(amount:int):void
		{
			damageValue -= amount;
			health += amount;
		}
		
		//////////////////////////////////////////////
		// CALLBACK FUNCTIONS FOR TIMERS
		/////////////////////////////////////////////
		
		private function degenDamageBar():void
		{
			if (damageValue > 0)
			{
				damageValue--;
				degenTimer.start();
			}
		}
		
		private function startDegenDamageBar():void
		{
			degenTimer.start();
		}
	}
}