package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	
	public class TranqBullet extends FireableWeapon
	{
		[Embed(source = '../../assets/img/player/weapons/tranq_bullet.png')] private var bulletPNG:Class;
		
		/**
		 * Makes a tranquiliser bullet.  Generally, only the TranqBulletHandler should
		 * call this.
		 */
		public function TranqBullet() 
		{		
			/* these have to go first */
			shotVelocity = 1200;
			
			super();
			loadGraphic(bulletPNG, true, true, 4, 4, true);
		}
		
		override public function update():void
		{
			/* If the bullet goes offscreen, remove it. (Place it back into the pool of available bullets) */
			if (exists && !onScreen())
			{
				kill();
			}
		}
	}
}