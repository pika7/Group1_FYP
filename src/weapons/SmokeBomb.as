package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.SmokeBombHandler;
	import util.Registry;
	
	public class SmokeBomb extends FireableWeapon
	{
		[Embed(source = '../../assets/img/player/weapons/smoke_bomb.png')] private var bombPNG:Class;
		
		public const REDUCE_VELOCITY_X_MULTIPLIER:Number = 0.7;
		private const EMIT_SMOKE_DELAY:int = 2000;
		private const GRAVITY_DELAY:int = 150;
		private const SPIN_SPEED:int = 900;
		private const GRAVITY:int = 800;
		
		private var emitSmokeTimer:FlxDelay; // the amount of the time that elapses before smoke is emitted
		private var gravityTimer:FlxDelay; // gravity kicks in later so that aiming feels better
		private var smokeCloud:SmokeCloud; // each smoke bomb has an associated smoke cloud
		
		/* called by SmokeBombHandler */
		public function SmokeBomb() 
		{
			shotVelocity = 100;
			
			super();
			loadGraphic(bombPNG, false, false, 16, 16, false);
			
			/* this needs to go after for some reason */
			elasticity = 0.2;
			
			/* initialise timers */
			emitSmokeTimer = new FlxDelay(EMIT_SMOKE_DELAY);
			emitSmokeTimer.callback = emitSmoke;
			
			gravityTimer = new FlxDelay(GRAVITY_DELAY);
			gravityTimer.callback = startGravity;
			
			/* initialise the smoke cloud */
			smokeCloud = new SmokeCloud();

			exists = false;
		}
		
		////////////////////////////////////////////////////////////
		// PUBLIC FUNCTIONS
		////////////////////////////////////////////////////////////
		override public function fire(X:int, Y:int, angle:Number):void
		{
			super.fire(X, Y, angle);
			angularVelocity = SPIN_SPEED;
			emitSmokeTimer.start();
			gravityTimer.start();
			acceleration.y = 0;
			
			exists = true;
		}
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS for internal timers
		////////////////////////////////////////////////////////////
		/* begin to emit smoke to blind the enemies */
		private function emitSmoke():void
		{
			Registry.smokeBombHandler.emitSmoke(x, y); // this is bad practice imo
			kill();
		}
		
		/* gravity kicks in */
		private function startGravity():void
		{
			acceleration.y = GRAVITY;
		}
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS (for use in PlayState) these look stupid
		////////////////////////////////////////////////////////////
		/* slow down and/or stop the x velocity when it hits the ground */
		public static function bounce(level:FlxTilemap, smokebomb:SmokeBomb):void
		{
			smokebomb.velocity.x = smokebomb.REDUCE_VELOCITY_X_MULTIPLIER * smokebomb.velocity.x;
			
			if (smokebomb.velocity.x <= 2 && smokebomb.velocity.x >= -2)
			{
				smokebomb.velocity.x = 0;
				smokebomb.angularVelocity = 0;
			}
		}
	}

}