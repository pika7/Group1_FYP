/* this handler handles all the noiseRadii and recycles them */
/* the main FlxGroup holds all the precreated nose Radii, which should be only the player */

package util 
{
	import actors.BigNoiseRadius;
	import actors.BulletNoiseRadius;
	import actors.NoiseRadius;
	import org.flixel.*;
	import util.Registry;
	
	public class NoiseHandler extends FlxGroup
	{
		private const NUMBER_OF_RADII:int = 10;
		private const NUMBER_OF_BIG_RADII:int = 10;
		private const NUMBER_OF_BULLET_RADII:int = 10;
		
		public var noiseRadiusGroup:FlxGroup;
		public var bigNoiseRadiusGroup:FlxGroup;
		public var bulletNoiseRadiusGroup:FlxGroup;
		private var tempNoise:NoiseRadius;
		
		public function NoiseHandler()
		{
			super();
			
			noiseRadiusGroup = new FlxGroup();
			bigNoiseRadiusGroup = new FlxGroup();
			bulletNoiseRadiusGroup = new FlxGroup();
			
			/* create 10 noiseRadii */
			for (var i:int = 0; i <= NUMBER_OF_RADII; i++)
			{
				noiseRadiusGroup.add(new NoiseRadius(0, 0, false));
			}
			
			/* create 10 large noiseRadii */
			for (var j:int = 0; j <= NUMBER_OF_BIG_RADII; j++)
			{
				bigNoiseRadiusGroup.add(new BigNoiseRadius(0, 0, false));
			}
			
			/* create 10 bullet noiseRadii */
			for (var k:int = 0; k <= NUMBER_OF_BULLET_RADII; k++)
			{
				bulletNoiseRadiusGroup.add(new BulletNoiseRadius(0, 0, false));
			}
			
			/* add the groups to this group for recursive adding */
			add(noiseRadiusGroup);
			add(bigNoiseRadiusGroup);
			add(bulletNoiseRadiusGroup);
		}
		
		/**
		 * Make some noise for a certain period of time.  Default is forever.
		 * 
		 * @param	X		The X coordinate of the place to make noise.
		 * @param	Y		The Y coordinate of the place to make noise.
		 * @param	time	The amount of time to make noise for.  If 0, then make noise forever.
		 */
		public function makeNoise(X:int, Y:int, time:int = 0):void
		{
			tempNoise = NoiseRadius(noiseRadiusGroup.getFirstAvailable());
			if (tempNoise)
			{
				tempNoise.setAt(X, Y);
				tempNoise.on(time);
			}
		}
		
		/**
		 * Make some bullet noise for a certain period of time.  Default is forever.
		 * 
		 * @param	X		The X coordinate of the place to make noise.
		 * @param	Y		The Y coordinate of the place to make noise.
		 * @param	time	The amount of time to make noise for.  If 0, then make noise forever.
		 */
		public function makeBulletNoise(X:int, Y:int, time:int = 0):void
		{
			tempNoise = BulletNoiseRadius(bulletNoiseRadiusGroup.getFirstAvailable());
			if (tempNoise)
			{
				tempNoise.setAt(X, Y);
				tempNoise.on(time);
			}
		}
		
		/**
		 * Make some big noise for a certain period of time.  Default is forever.
		 * 
		 * @param	X		The X coordinate of the place to make noise.
		 * @param	Y		The Y coordinate of the place to make noise.
		 * @param	time	The amount of time to make noise for.  If 0, then make noise forever.
		 */
		public function makeBigNoise(X:int, Y:int, time:int = 0):void
		{
			tempNoise = BigNoiseRadius(bigNoiseRadiusGroup.getFirstAvailable());
			if (tempNoise)
			{
				tempNoise.setAt(X, Y);
				tempNoise.on(time);
			}
		}
		
	}

}