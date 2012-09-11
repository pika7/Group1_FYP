/* this class shows a lifebar in the corner */

package ui 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import util.Registry;
	import actors.Player;
	
	public class LifeBar extends FlxGroup
	{
		private var lifeBorder:LifeBorder;
		private var bar:FlxBar;
		private var health:int;
		
		public function LifeBar() 
		{
			super();
			health = Registry.gameStats.STARTING_LIFE;
			
			bar = new FlxBar(590, 10, FlxBar.FILL_LEFT_TO_RIGHT, 200, 20, Registry.gameStats, "health", 0, 100, false);
			bar.createFilledBar(0xff770000, 0xff11cc11);
			bar.scrollFactor.x = 0;
			bar.scrollFactor.y = 0;
			
			/* add all the things */
			add(bar);
			add(lifeBorder = new LifeBorder(590, 10));
		}
	}
}