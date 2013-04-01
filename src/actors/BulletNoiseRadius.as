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
		
	}

}