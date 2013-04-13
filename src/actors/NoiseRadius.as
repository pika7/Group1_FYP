/**
 * this class represents the amount of noise the player is making.  if any guard is within the noise radius,
 * he can hear the player
 * */

package actors 
{
	import org.flixel.*;
	import util.Registry;
	import org.flixel.plugin.photonstorm.FlxDelay;
	
	public class NoiseRadius extends FlxSprite
	{
		[Embed(source = '../../assets/img/player/footstep_noise_radius.png')] private var circlePNG:Class;
		
		private var noiseTimer:FlxDelay;
		
		/**
		 * Create a noiseRadius centered at the specified location.
		 * 
		 * @param	X			X value of noise origin.
		 * @param	Y			Y value of noise origin.
		 * @param	doesExist	Whether or not to start making noise right away.  Default is true.
		 */
		public function NoiseRadius(X:int, Y:int, doesExist:Boolean = true) 
		{
			super(X, Y);
			loadGraphic(circlePNG, true, true, 400, 400, false);
			x = x - width / 2;
			y = y - height / 2;
			
			alpha = 0.2;
			exists = doesExist;
			
			/* initialise the timer */
			noiseTimer = new FlxDelay(0);
		}
		
		/**
		 * Turn the noise radius on for a certain amount of time, default is on indefinitely.
		 * 
		 * @param	timeToRun		The amount of time to make noise.  Default is on forever.
		 */
		public function on(timeToRun:int = 0):void
		{
			exists = true;
			
			if (timeToRun > 0)
			{
				noiseTimer = new FlxDelay(timeToRun);
				noiseTimer.start();
				noiseTimer.callback = off;
			}
		}
		
		/**
		 * Turn the noise radius off
		 */
		public function off():void
		{
			exists = false;
			noiseTimer.abort();
		}
		
		/**
		 * The <code>NoiseRadius</code> will follow the specified target.  Should be called
		 * in <code>update</code> function.
		 * 
		 * @param	target	The target for the <code>noiseRadius</code> to follow.
		 */
		public function follow(target:FlxSprite):void
		{
			x = target.x - width/2 + target.width/2;
			y = target.y - height/2 + target.height/2;
		}
		
		/**
		 * Set the <code>NoiseRadius</code> centered at the specified location.
		 * 
		 * @param	X	The x-coordinate.
		 * @param	Y	The y-coordinate.
		 */
		public function setAt(X:int, Y:int):void
		{
			x = X - width / 2;
			y = Y - height / 2;
		}
		
		/**
		 * Returns various INTs depending on what noise radius type it is.
		 * Returns 0 if it is the player.
		 * Returns 1 if it is a tranq bullet.
		 * Returns 2 if it is a stun grenade.
		 * 
		 * @return	The type of noise.
		 */
		public function getNoiseType():int
		{
			return 0;
		}
	}

}