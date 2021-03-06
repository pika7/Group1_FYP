/** 
 * This is just the smoke cloud the smoke bomb makes after it explodes.  After a while, it disappears.  Recycled and preloaded since there are probably
 * gonna be lots of particle effects.
 */ 

package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.Registry;
	
	public class SmokeCloud extends Explosion
	{
		[Embed(source = '../../assets/img/player/weapons/smoke_cloud.png')] private var cloudPNG:Class
		
		public function SmokeCloud() 
		{
			explodeTime = 3500;
			
			super();
			loadGraphic(cloudPNG, false, false, 256, 256, false);
			
			alpha = 0.7;
		}
	}

}