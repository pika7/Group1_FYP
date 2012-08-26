/**
 * This manager recylces bullets fired by the player. Repetitive, but since actionscript doesn't seem to support generics...
 */

package util 
{
	import org.flixel.*;
	import weapons.TranqBullet;
	
	public class TranqBulletHandler extends FlxGroup
	{
		public function TranqBulletHandler() 
		{
			super();
			
			/* create 10 bullets */
			for (var i:int = 0; i <= 10; i++)
			{
				add(new TranqBullet());
			}
		}
		/**
		 * Fires a <code>TranqBullet</code> from the specified location at the mouse.
		 * 
		 * @param	X		The X position that the bullet is fired from.
		 * @param	Y		The Y position that the bullet is fired from.
		 * @param	angle	The angle at which the bullet is fired.
		 */
		public function fire(bx:int, by:int, angle:Number):void
		{
			if (getFirstAvailable())
			{
				TranqBullet(getFirstAvailable()).fire(bx, by, angle);
			}
		}
		/**
		 * Kill everything inside the handler.
		 */
		override public function clear():void
		{
			callAll("recycleKill");
		}
	}
}