/** 
 * This is just the smoke cloud the smoke bomb makes after it explodes.  After a while, it disappears.  Recycled and preloaded since there are probably
 * gonna be lots of particle effects.
 */ 

package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.Registry;
	
	public class Explosion extends FlxSprite
	{		
		protected var explodeTime:int;
		protected var explodeTimer:FlxDelay;
		
		public function Explosion() 
		{
			super(0, 0);
			
			explodeTimer = new FlxDelay(explodeTime);
			explodeTimer.callback = recycleKill;
			
			// TODO: later on this will be represented using particles
			// maybe it will be a little bigger too
			
			exists = false;
			
		}
		
		/**
		 * Emit the smoke cloud at the specified x, y position.
		 */
		public function explode(X:int, Y:int):void
		{
			x = X;
			y = Y;
			
			exists = true;
			explodeTimer.start();
		}
		
		/**
		 * Make the smoke cloud disappear.
		 */
		public function recycleKill():void
		{
			exists = false;
		}
	}

}