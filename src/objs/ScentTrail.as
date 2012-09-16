/* contains a number of ScentBlobs and the point to where the beginning of the trail is */

package objs 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import util.Registry;
	
	public class ScentTrail extends FlxGroup
	{
		public var x:int;
		public var y:int;
		public var followPlayer:Boolean;

		private const EMIT_INTERVAL:int = 500;
		private var emitTimer:FlxDelay;
		
		public function ScentTrail() 
		{
			super();
			x = 0;
			y = 0;
			followPlayer = true;
			
			/* create 10 scentblobs */
			for (var i:int = 0; i <= 10; i++ )
			{
				add(new ScentBlob());
			}
			
			/* intitialise timer */
			emitTimer = new FlxDelay(EMIT_INTERVAL);
			
			exists = false;
		}
		
		override public function update():void
		{
			/* check if following player */
			if (followPlayer)
			{
				x = Registry.player.x;
				y = Registry.player.y;
			}
			
			/* place a blob down at x, y every few seconds */
			if (!emitTimer.isRunning)
			{
				emitBlob();
				emitTimer.start();
			}
		}
		
		/**
		 * Emit a <code>ScentBlob</code> at current location location.
		 */
		public function emitBlob():void
		{
			if (getFirstAvailable())
			{
				ScentBlob(getFirstAvailable()).emit(x, y);
			}
		}
		
		/**
		 * Start emitting a scent.
		 */
		public function start():void
		{
			exists = true;
		}
		
		/**
		 * Stop emitting a scent.
		 */
		public function stop():void
		{
			exists = false;
		}
	
	}

}