/*
 * This is an abstract class that should not be called.
 * The use of this class is to enable us to place a variable
 * in the Registry that can hold any level.
 */

package levels 
{
	import objs.GoalItem;
	import org.flixel.*;
	
	public class Level extends FlxGroup
	{
		public var map:FlxTilemap;
		public var background:FlxTilemap;
		public var items:FlxTilemap;
		public var markers:FlxTilemap;
		
		public var width:int;
		public var height:int;
		
		public function Level() 
		{
			
		}
		
		/////////////////////////////////////////
		// PARSING FUNCTIONS
		/////////////////////////////////////////
		
		public function parseGoalItem(map:FlxTilemap):void
		{
			for (var ty:int = 0; ty < map.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < map.widthInTiles; tx++)
				{
					/* Change this according to the tile number in DAME */
					if (map.getTile(tx, ty) == 1)
					{
						new GoalItem(tx, ty);
					}
				}
			}
		}
		
	}

}