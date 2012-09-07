/* abstract class for hiding spots */

package objs 
{
	import org.flixel.*;
	import util.Registry;
	
	public class HidingSpot extends ParsableObject
	{
		public function HidingSpot(X:int, Y:int, spriteWidth:int, spriteHeight:int) 
		{
			super(X, Y, spriteWidth, spriteHeight);
			Registry.hidingSpots.add(this);
		}
	}
}