/**
 * This class contains a scentblob that is part of a trail.
 * it is recyclable
 * expires after a while
 */

package objs 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	
	public class ScentBlob extends FlxSprite
	{
		[Embed(source = '../../assets/img/objs/scent.png')] private var scentPNG:Class;
		
		private const EXPIRY_TIME:int = 2500;
		private var expireTimer:FlxDelay;
		
		public function ScentBlob() 
		{
			super(0, 0);
			loadGraphic(scentPNG, false, false, 64, 128);
			
			expireTimer = new FlxDelay(EXPIRY_TIME);
			expireTimer.callback = fade;
			//TEMP:
			alpha = 0.2;
			
			exists = false;
			
			/* the origin of this object is at the bottom left corner */
			//origin = new FlxPoint(0, 32);
		}
		
		/**
		 * Emit a <code>ScentBlob</code> at the specified location.
		 * 
		 * @param	X	x-coordinate
		 * @param	Y	y-coordinate
		 */
		public function emit(X:int, Y:int):void
		{
			x = X;
			y = Y;
			
			exists = true;
			expireTimer.start();
		}
		
		private function fade():void
		{
			exists = false;
		}
	}
}