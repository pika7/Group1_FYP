package ui 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import util.Registry;
	
	public class UIHandler extends FlxGroup
	{
		private var aimline:Aimline;
		private var lifeBar:LifeBar;
		
		public function UIHandler() 
		{
			add(aimline = new Aimline());
			add(lifeBar = new LifeBar());
		}
		
		override public function update():void
		{
			super.update();
		}
		
		///////////////////////////////////////////////////
		// PUBLIC FUNCTIONS
		///////////////////////////////////////////////////
		
		/**
		 * Set the <code>Aimline</code> centered at the specified location that follows the mouse pointer.
		 * 
		 * @param	X		x-coordinate of the location.
		 * @param	Y		y-coordinate of the location.
		 */
		public function showAimline(X:int, Y:int):void
		{
			aimline.x = X - aimline.width / 2;
			aimline.y = Y;
			
			aimline.exists = true;
		}
		
		public function hideAimline():void
		{
			aimline.exists = false;
		}
		
	}
}