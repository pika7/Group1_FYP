/**
 * Because instantiating things in the Registry causes trouble, this is the only object that should be
 * instantiated in the Registry.
 * 
 * It holds all the various game values that persist from state to state.
 * 
 * Things can be added here as needed.
 */

package util 
{
	import org.flixel.*;
	
	public class GameStats extends FlxBasic
	{
		/* public constants */
		public const STARTING_LIFE:int = 100;
		
		/* these are public because sometimes they need to be accessed and stuff */
		public var health:int;
		public var money:int;
		
		public function GameStats() 
		{
			health = STARTING_LIFE;
			money = 0;
		}
		
		////////////////////////////////////////////////////////////
		// PUBLIC FUNCTIONS
		////////////////////////////////////////////////////////////
		
		/**
		 * Damages the player.
		 * 
		 * @param	amount		The amount to damage the player by.
		 */
		public function damage(amount:int):void
		{
			// TODO: some other stuff with the life bar
			health -= amount;
		}
		
		/**
		 * Heals the player.
		 * 
		 * @param	amount		The amount to heal the player by.
		 */
		public function heal(amount:int):void
		{
			// TODO: some other stuff with the life bar
			health += amount;
		}
		
	}

}