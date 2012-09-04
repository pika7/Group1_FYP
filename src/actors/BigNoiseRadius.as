/* just a bigger version of the NoiseRadius class. */

package actors 
{
	import org.flixel.*;
	
	public class BigNoiseRadius extends NoiseRadius
	{
		[Embed(source = '../../assets/img/player/big_noise_radius.png')] private var bigcirclePNG:Class;
		
		/**
		 * Create a BigNoiseRadius centered at the specified location.
		 * 
		 * @param	X			X value of noise origin.
		 * @param	Y			Y value of noise origin.
		 * @param	doesExist	Whether or not to start making noise right away.  Default is true.
		 */
		public function BigNoiseRadius(X:int, Y:int, doesExist:Boolean = true) 
		{
			super(X, Y, doesExist);
			loadGraphic(bigcirclePNG, true, true, 800, 800, false);
			x = x - width / 2;
			y = y - height / 2;
		}
	}
}