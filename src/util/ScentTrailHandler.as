package util 
{
	import objs.ScentTrail;
	import org.flixel.*;
	
	public class ScentTrailHandler extends FlxGroup
	{
		public function ScentTrailHandler() 
		{
			super();
			
			/* create 10 scent trails */
			for (var i:int = 0; i <= 10; i++)
			{
				add(new ScentTrail());
			}
		}
		
		/**
		 * Start emitting a scent trail.
		 * 
		 * @param	followPlayer	If true, then the scent trail follows the player.
		 */
		public function start(followPlayer:Boolean = true):void
		{
			if (getFirstAvailable())
			{
				ScentTrail(getFirstAvailable()).start();
			}
		}
	}
}