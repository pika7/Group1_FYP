/** 
 * This is just the smoke cloud the smoke bomb makes after it explodes.  After a while, it disappears.  Recycled and preloaded since there are probably
 * gonna be lots of particle effects.
 */ 

package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.Registry;
	
	public class StunExplosion extends Explosion
	{
		[Embed(source = '../../assets/img/player/weapons/stun_explosion.png')] private var explodePNG:Class
		
		public function StunExplosion() 
		{
			explodeTime = 100;
			
			super();
			loadGraphic(explodePNG, false, false, 256, 256, false);
		}
	}

}