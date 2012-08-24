/* abstract class, for fireable weapons.  projectile flies in a straight line towards mouse */

package weapons 
{
	import org.flixel.*;
	
	public class FireableWeapon extends FlxSprite
	{
		protected var shotVelocity:int = 500;
		protected var gravity:int = 0;
		
		public function FireableWeapon()
		{
			super(0, 0);
			acceleration.y = gravity;
			exists = false;
		}
		
		/**
		 * Fires the <code>FireableWeapon</code> from the specified location at the specified angle.
		 * 
		 * @param	X		X coordinate of the starting location.
		 * @param	Y		Y coordinate of the starting location.
		 * @param	angle	Angle at which to fire the bullet. (In radians)
		 */
		public function fire(X:int, Y:int, angle:Number):void
		{
			x = X;
			y = Y;
			
			velocity.x = shotVelocity * Math.cos(angle);
			velocity.y = shotVelocity * Math.sin(angle);
			
			exists = true;
		}
		
		override public function kill():void
		{
			exists = false;
		}
		
	}

}