/**
 * This manager recylces stun grenades fired by the player. Repetitive, but since actionscript doesn't seem to support generics...
 */

package util 
{
	import org.flixel.*;
	import weapons.StunGrenade;
	import weapons.StunExplosion;
	
	public class StunGrenadeHandler extends FlxGroup
	{	
		private const STUN_GRENADE_NUMBER:int = 15; // need a lot of them because they linger!
		
		public var stunExplosionGroup:FlxGroup;
		private var tempStunExplosion:StunExplosion;
		
		public function StunGrenadeHandler() 
		{
			super();
			stunExplosionGroup = new FlxGroup();
			
			/* create bullets */
			for (var i:int = 0; i <= STUN_GRENADE_NUMBER; i++)
			{
				add(new StunGrenade());
			}
			
			/* create smoke clouds in the smokeCloudGroup */
			for (var j:int = 0; j <= STUN_GRENADE_NUMBER; j++)
			{
				stunExplosionGroup.add(new StunExplosion());
			}
		}
		/**
		 * Fires a <code>StunGrenade</code> from the specified location at the mouse.
		 * 
		 * @param	bx		The X position that the bullet is fired from.
		 * @param	by		The Y position that the bullet is fired from.
		 * @param	angle	The angle at which the bullet is fired.
		 */
		public function fire(bx:int, by:int, angle:Number):void
		{
			if (getFirstAvailable())
			{
				StunGrenade(getFirstAvailable()).fire(bx, by, angle);
			}
		}
		
		/**
		 * Explode a <code>StunExplosion</code> at the specified location.
		 * 
		 * @param	bx		The x position that the smoke cloud comes from.
		 * @param	by		The y position that the smoke cloud comes from.
		 */
		public function explode(bx:int, by:int):void
		{
			tempStunExplosion = StunExplosion(stunExplosionGroup.getFirstAvailable());
			
			if (tempStunExplosion)
			{
				StunExplosion(tempStunExplosion.explode(bx - tempStunExplosion.width/2, by - tempStunExplosion.height/2));
			}
		}
		
		/**
		 * Kill everything inside the handler.
		 */
		override public function clear():void
		{
			for (var i:int = 0; i <= STUN_GRENADE_NUMBER; i++)
			{
				callAll("recycleKill");
				stunExplosionGroup.callAll("recycleKill");
				
				/* abort all the timers */
				callAll("abortTimers");
			}
		}
	}
}