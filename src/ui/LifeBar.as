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
			health = Player.STARTING_LIFE;
			
			//bar = new FlxBar(590, 10, FlxBar.FILL_LEFT_TO_RIGHT, 200, 20, Registry.player, "health", 0, 100, false);
			
			/* add all the things */
			add(bar);
			add(lifeBorder = new LifeBorder(590, 10));
		}
		
		public function getLife():int
		{
			return 0;
		}
		
		public function damage(amount:int):void
		{
			
		}
		
		public function heal(amount:int):void
		{
			
		}
	}
}