package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.Registry;
	
	public class StunGrenade extends ThrowableWeapon
	{
		[Embed(source = '../../assets/img/player/weapons/stun_grenade.png')] private var grenadePNG:Class;
		[Embed(source = '../../assets/soundeffect/player/stungrenade.mp3')] private var grenadeSound:Class;
		
		private const EXPLODE_DELAY:int = 2000; // time it takes before a stun grenade explodes
		
		private var explodeTimer:FlxDelay;
		
		public function StunGrenade() 
		{
			super();
			loadGraphic(grenadePNG, false, false, 16, 16, false);
			
			/* this needs to go after for some reason */
			elasticity = 0.2;
			
			/* initialise timers */
			explodeTimer = new FlxDelay(EXPLODE_DELAY);
			explodeTimer.callback = explode;
		}
		
		override public function fire(X:int, Y:int, angle:Number):void
		{
			explodeTimer.start();
			super.fire(X, Y, angle);
		}
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS for internal timers
		////////////////////////////////////////////////////////////
		
		private function explode():void
		{
			FlxG.play( grenadeSound, 0.5, false, true);
			Registry.noiseHandler.makeBigNoise(x, y, 100);
			Registry.stunNoiseCoord.x = x;
			Registry.stunNoiseCoord.y = y;
			Registry.stunGrenadeHandler.explode(x, y);
			recycleKill();
		}
	}

}