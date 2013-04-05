/* a version of the NoiseRadius class for the bullet striking walls */

package actors 
{
	import org.flixel.*;
	
	public class BulletNoiseRadius extends NoiseRadius
	{
		[Embed(source = '../../assets/img/player/footstep_noise_radius.png')] private var circlePNG:Class;
		
		public function BulletNoiseRadius(X:int, Y:int, doesExist:Boolean) 
		{
			super(X, Y, doesExist);
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