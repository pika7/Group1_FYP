package weapons 
{
	import levels.Level;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import util.Registry;
	
	public class TranqBullet extends FireableWeapon
	{
		[Embed(source = '../../assets/img/player/weapons/tranq_bullet.png')] private var bulletPNG:Class;
		
		/**
		 * Makes a tranquiliser bullet.  Generally, only the TranqBulletHandler should
		 * call this.
		 */
		public function TranqBullet() 
		{		
			super();
			loadGraphic(bulletPNG, true, true, 4, 4, true);
			shotVelocity = 1200;
		}
		
		override public function update():void
		{
			/* If the bullet goes offscreen, remove it. (Place it back into the pool of available bullets) */
			if (exists && !onScreen())
			{
				recycleKill();
			}
		}
		
		//////////////////////////////////////////////////////
		// PRIVATE HELPER FUNCTIONS
		/////////////////////////////////////////////////////
		
		/* what happens when the bullet collides with the level */
		private function ping():void
		{
			Registry.noiseHandler.makeNoise(x, y, 10);
			recycleKill();
		}
		
		///////////////////////////////////////////////////////
		// PUBLIC CALLBACK FUNCTIONS for PlayState
		//////////////////////////////////////////////////////
		public static function ping_callback(level:FlxTilemap, bullet:TranqBullet):void
		{
			bullet.ping();
		}
	}
}