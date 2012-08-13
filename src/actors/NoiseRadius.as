/**
 * this class represents the amount of noise the player is making.  if any guard is within the noise radius,
 * he can hear the player
 * */

package actors 
{
	import org.flixel.*;
	import util.Registry;
	
	
	public class NoiseRadius extends FlxSprite
	{
		[Embed(source = '../../assets/img/player/footstep_noise_radius.png')] private var circlePNG:Class;
		
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
			Registry.noiseRadii.add(this);
			exists = doesExist;
		}
		
		/**
		 * Turn the noise radius on.
		 */
		public function on():void
		{
			exists = true;
		}
		
		/**
		 * Turn the noise radius off
		 */
		public function off():void
		{
			exists = false;
		}
		
		/**
		 * The <code>noiseRadius</code> will follow the specified target.  Should be called
		 * in <code>update</code> function.
		 * 
		 * @param	target	The target for the <code>noiseRadius</code> to follow.
		 */
		public function follow(target:FlxSprite):void
		{
			x = target.x - width/2 + target.width/2;
			y = target.y - height/2 + target.height/2;
		}
		
		
		/* TODO: make a noise radius handler */
		/* TODO: make a variety of different noise radii.  Maybe three: quiet, medium, and loud. */
	}

}