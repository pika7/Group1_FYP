/* a simple class that just keeps aiming towards the mouse... heh */

package actors 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import util.Registry;
	
	public class AimArm extends FlxSprite
	{
		public var followMouse:Boolean = true; // whether or not the arm follows the mouse around

		/**
		 * Create a new arm and shit.
		 * 
		 * @param	Simple graphic class.
		 */
		public function AimArm() 
		{
			super(0, 0);
			exists = false;
		}
		
		override public function update():void
		{
			if (followMouse)
			{
				/* match the facing of the player */
				facing = Registry.player.facing;
				
				/* adjust for facing */
				if (Registry.player.facing == FlxObject.RIGHT)
				{
					angle = FlxVelocity.angleBetweenMouse(Registry.player.firePoint, true);
				}
				else
				{
					angle = FlxVelocity.angleBetweenMouse(Registry.player.firePoint, true) + 180;
				}	
			}
		}
	}
}