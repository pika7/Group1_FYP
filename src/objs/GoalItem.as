/* this should be parsed, not directly placed on the level */

package objs 
{
	import org.flixel.*;
	import util.Registry;
	
	public class GoalItem extends ParsableObject
	{
		/* later on this image can be invisible / have different frames depending on what goal items that level is supposed to have */
		[Embed(source = '../../assets/img/objs/goal_item.png')] private var itemPNG:Class;
		
		public function GoalItem(X:int, Y:int) 
		{			
			super(X, Y, 64, 64);
			loadGraphic(itemPNG, true, true, 64, 64, true);
			
			width = 32;
			height = 32;
			centerOffsets(true);
			
			/* set this item into the Registry */
			Registry.goalItem = this;
		}	
	}

}