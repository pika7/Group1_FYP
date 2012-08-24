package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.SmokeBombHandler;
	
	public class SmokeBomb extends FireableWeapon
	{
		[Embed(source = '../../assets/img/player/weapons/smoke_bomb.png')] private var bombPNG:Class;
		
		public const REDUCE_VELOCITY_X_MULTIPLIER:Number = 0.7;
		private const EMIT_SMOKE_DELAY:int = 2000;
		private const SPIN_SPEED:int = 900;
		
		private var emitSmokeTimer:FlxDelay; // the amount of the time that elapses before smoke is emitted
		
		/* called by SmokeBombHandler */
		public function SmokeBomb() 
		{
			gravity = 600;
			shotVelocity = 100;
			
			super();
			loadGraphic(bombPNG, false, false, 16, 16, false);
			
			/* this needs to go after for some reason */
			elasticity = 0.2;
			
			/* initialise timers */
			emitSmokeTimer = new FlxDelay(EMIT_SMOKE_DELAY);
			emitSmokeTimer.callback = emitSmoke;
		}
		
		////////////////////////////////////////////////////////////
		// PUBLIC FUNCTIONS
		////////////////////////////////////////////////////////////
		override public function fire(X:int, Y:int, angle:Number):void
		{
			super.fire(X, Y, angle);
			angularVelocity = SPIN_SPEED;
			emitSmokeTimer.start();
		}
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS for internal timers
		////////////////////////////////////////////////////////////
		/* begin to emit smoke to blind the enemies */
		private function emitSmoke():void
		{
			trace("smoke bomb activate");
			kill();
		}
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS (for use in PlayState) these look stupid
		////////////////////////////////////////////////////////////
		/* slow down and/or stop the x velocity when it hits the ground */
		public static function bounce(level:FlxTilemap, smokebomb:SmokeBomb):void
		{
			smokebomb.velocity.x = smokebomb.REDUCE_VELOCITY_X_MULTIPLIER * smokebomb.velocity.x;
			
			if (smokebomb.velocity.x <= 2)
			{
				smokebomb.velocity.x = 0;
				smokebomb.angularVelocity = 0;
			}
		}
	}

}