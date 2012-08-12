/**
 * This creates the Exit of the level.  It will complete the level if you reach here with the GoalItem.
 * This should be parsed, not directly placed on the level.
 */

package objs 
{
	import org.flixel.*;
	import util.Registry;
	
	public class Exit extends ParsableObject
	{
		/* later on this image can have invisible or have different frames to change the look of it */
		[Embed(source = '../../assets/img/objs/exit.png')] private var exitPNG:Class;
		
		public function Exit(X:int, Y:int) 
		{
			super(X, Y, 150, 150);
			loadGraphic(exitPNG, true, true, 150, 150, true);
			
			width = 75;
			height = 150;
			centerOffsets(true);
			
			/* set the exit into the Registry */
			Registry.exit = this;
		}
	}
}