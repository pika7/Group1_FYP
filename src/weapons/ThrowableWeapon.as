/* smoke bomb and stun grenade can extend this */

package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	
	public class ThrowableWeapon extends FireableWeapon
	{
		public const REDUCE_VELOCITY_X_MULTIPLIER:Number = 0.7;
		private const GRAVITY_DELAY:int = 150;
		private const SPIN_SPEED:int = 900;
		private const GRAVITY:int = 800;
		
		
		private var gravityTimer:FlxDelay; // gravity kicks in later so that aiming feels better
		
		
		public function ThrowableWeapon() 
		{
			shotVelocity = 100;
			
			super();
			
			/* initialise timers */
			gravityTimer = new FlxDelay(GRAVITY_DELAY);
			gravityTimer.callback = startGravity;
		}
		
		////////////////////////////////////////////////////////////
		// INTERNAL CALLBACK FUNCTIONS
		////////////////////////////////////////////////////////////
		/* gravity kicks in */
		private function startGravity():void
		{
			acceleration.y = GRAVITY;
		}
		
		////////////////////////////////////////////////////////////
		// PUBLIC FUNCTIONS
		////////////////////////////////////////////////////////////
		
		override public function fire(X:int, Y:int, angle:Number):void
		{
			super.fire(X, Y, angle);
			angularVelocity = SPIN_SPEED;
			gravityTimer.start();
			acceleration.y = 0;
			
			exists = true;
		}
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS (for use in PlayState) these look stupid
		////////////////////////////////////////////////////////////
		
		/* slow down and/or stop the x velocity when it hits the ground */
		public static function bounce(level:FlxTilemap, bomb:ThrowableWeapon):void
		{
			bomb.velocity.x = bomb.REDUCE_VELOCITY_X_MULTIPLIER * bomb.velocity.x;
			
			if (bomb.velocity.x <= 2 && bomb.velocity.x >= -2)
			{
				bomb.velocity.x = 0;
				bomb.angularVelocity = 0;
			}
		}
		
		/* used to stop all the timers */
		public function abortTimers():void
		{
			gravityTimer.abort();
		}
		
	}

}