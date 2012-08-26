/**
 * This manager recylces bullets fired by the player. Repetitive, but since actionscript doesn't seem to support generics...
 */

package util 
{
	import org.flixel.*;
	import weapons.SmokeBomb;
	import weapons.SmokeCloud;
	
	public class SmokeBombHandler extends FlxGroup
	{	
		private const SMOKEBOMB_NUMBER:int = 15; // need a lot of them because they linger!
		
		public var smokeCloudGroup:FlxGroup;
		private var tempSmokeCloud:SmokeCloud;
		
		public function SmokeBombHandler() 
		{
			super();
			smokeCloudGroup = new FlxGroup();
			
			/* create 5 bullets */
			for (var i:int = 0; i <= SMOKEBOMB_NUMBER; i++)
			{
				add(new SmokeBomb());
			}
			
			/* create 5 smoke clouds in the smokeCloudGroup */
			for (var j:int = 0; j <= SMOKEBOMB_NUMBER; j++)
			{
				smokeCloudGroup.add(new SmokeCloud());
			}
		}
		/**
		 * Fires a <code>TranqBullet</code> from the specified location at the mouse.
		 * 
		 * @param	bx		The X position that the bullet is fired from.
		 * @param	by		The Y position that the bullet is fired from.
		 * @param	angle	The angle at which the bullet is fired.
		 */
		public function fire(bx:int, by:int, angle:Number):void
		{
			if (getFirstAvailable())
			{
				SmokeBomb(getFirstAvailable()).fire(bx, by, angle);
			}
		}
		
		/**
		 * Emit a <code>SmokeCloud</code> centered at the specified location.
		 * 
		 * @param	bx		The x position that the smoke cloud comes from.
		 * @param	by		The y position that the smoke cloud comes from.
		 */
		public function emitSmoke(bx:int, by:int):void
		{
			tempSmokeCloud = SmokeCloud(smokeCloudGroup.getFirstAvailable());
			
			if (tempSmokeCloud)
			{
				SmokeCloud(tempSmokeCloud.emit(bx - tempSmokeCloud.width/2, by - tempSmokeCloud.height/2));
			}
		}
		
		/**
		 * Kill everything inside the handler.
		 */
		override public function clear():void
		{
			for (var i:int = 0; i <= SMOKEBOMB_NUMBER; i++)
			{
				callAll("recycleKill");
				smokeCloudGroup.callAll("recycleKill");
				
				/* abort all the timers */
				callAll("abortTimers");
			}
		}
	}
}