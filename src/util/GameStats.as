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

	public class GameStats
	{
		/* public constants */
		public const STARTING_LIFE:int = 100;
		
		public var health:int;
		
		public function GameStats() 
		{
			health = STARTING_LIFE;
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