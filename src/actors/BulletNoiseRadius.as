/* just a bigger version of the NoiseRadius class. */

package actors 
{
	import org.flixel.*;
	
	public class BulletNoiseRadius extends NoiseRadius
	{
		[Embed(source = '../../assets/img/player/footstep_noise_radius.png')] private var circlePNG:Class;
		
		/**
		 * Create a BulletNoiseRadius centered at the specified location.
		 * 
		 * @param	X			X value of noise origin.
		 * @param	Y			Y value of noise origin.
		 * @param	doesExist	Whether or not to start making noise right away.  Default is true.
		 */
		public function BulletNoiseRadius(X:int, Y:int, doesExist:Boolean = true) 
		{
			super(X, Y, doesExist);
			loadGraphic(circlePNG, true, true, 400, 400, false);
			x = x - width / 2;
			y = y - height / 2;
		}
		
		/**
		 * Returns various INTs depending on what noise radius type it is.
		 * Returns 0 if it is the player.
		 * Returns 1 if it is a tranq bullet.
		 * Returns 2 if it is a stun grenade.
		 * 
		 * @return	The type of noise.
		 */
		override public function getNoiseType():int
		{
			return 1;
		}
	}
}