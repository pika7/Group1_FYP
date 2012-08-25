/** 
 * This is just the smoke cloud the smoke bomb makes after it explodes.  After a while, it disappears.  Recycled and preloaded since there are probably
 * gonna be lots of particle effects.
 */ 

package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.Registry;
	
	public class SmokeCloud extends FlxSprite
	{
		[Embed(source = '../../assets/img/player/weapons/smoke_cloud.png')] private var cloudPNG:Class
		
		private const EMIT_TIME:int = 3500;
		private var emitTimer:FlxDelay;
		
		public function SmokeCloud() 
		{
			super(0, 0);
			loadGraphic(cloudPNG, false, false, 256, 256, false);
			alpha = 0.7;
			emitTimer = new FlxDelay(EMIT_TIME);
			emitTimer.callback = kill;
			
			// TODO: later on this will be represented using particles
			// maybe it will be a little bigger too
			
			exists = false;
		}
		
		/**
		 * Emit the smoke cloud cented at the specified x, y position.
		 */
		public function emit(X:int, Y:int):void
		{
			x = X;
			y = Y;
			
			exists = true;
			emitTimer.start();
		}
		
		/**
		 * Make the smoke cloud disappear.
		 */
		override public function kill():void
		{
			exists = false;
		}
	}

}