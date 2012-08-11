package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	
	public class TranqBullet extends FlxSprite
	{
		[Embed(source = '../../assets/img/player/weapons/tranq_bullet.png')] private var bulletPNG:Class;
		
		private const VELOCITY:int = 1200;
		
		/**
		 * Makes a tranquiliser bullet.  Generally, only the TranqBulletHandler should
		 * call this.
		 */
		public function TranqBullet() 
		{
			super(0, 0);
			loadGraphic(bulletPNG, true, true, 4, 4, true);
			exists = false;
		}
		
		override public function update():void
		{
			/* If the bullet goes offscreen, remove it. (Place it back into the pool of available bullets) */
			if (exists && !onScreen())
			{
				exists = false;
			}
		}
		
		/**
		 * Fires the <code>TranqBullet</code> from the specified location at the specified angle.
		 * Should only be called by TranqBulletHandler.
		 * 
		 * @param	X		X coordinate of the starting location.
		 * @param	Y		Y coordinate of the starting location.
		 * @param	angle	Angle at which to fire the bullet
		 */
		public function fire(X:int, Y:int, angle:Number):void
		{
			x = X;
			y = Y;
			
			velocity.x = VELOCITY * Math.cos(angle);
			velocity.y = VELOCITY * Math.sin(angle);
			
			exists = true;
		}
	}
}