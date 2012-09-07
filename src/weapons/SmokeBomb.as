package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.SmokeBombHandler;
	import util.Registry;
	
	public class SmokeBomb extends ThrowableWeapon
	{
		[Embed(source = '../../assets/img/player/weapons/smoke_bomb.png')] private var bombPNG:Class;
		
		private const EMIT_SMOKE_DELAY:int = 2000;
		
		private var smokeCloud:SmokeCloud; // each smoke bomb has an associated smoke cloud
		private var emitSmokeTimer:FlxDelay; // the amount of the time that elapses before smoke is emitted
		
		/* called by SmokeBombHandler */
		public function SmokeBomb() 
		{			
			super();
			loadGraphic(bombPNG, false, false, 16, 16, false);
			
			/* this needs to go after for some reason */
			elasticity = 0.2;
			
			/* initialise timers */
			emitSmokeTimer = new FlxDelay(EMIT_SMOKE_DELAY);
			emitSmokeTimer.callback = emitSmoke;

			
			/* initialise the smoke cloud */
			smokeCloud = new SmokeCloud();

			exists = false;
		}
		
		override public function fire(X:int, Y:int, angle:Number):void
		{
			emitSmokeTimer.start();
			super.fire(X, Y, angle);
		}
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS for internal timers
		////////////////////////////////////////////////////////////
		
		/* begin to emit smoke to blind the enemies */
		private function emitSmoke():void
		{
			Registry.noiseHandler.makeNoise(x, y, 100);
			Registry.smokeBombHandler.emitSmoke(x, y); // this is bad practice imo
			recycleKill();
		}
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS (for use in PlayState) these look stupid
		////////////////////////////////////////////////////////////
		
		/* used to stop all the timers */
		override public function abortTimers():void
		{
			emitSmokeTimer.abort();
			super.abortTimers();
		}
	}

}