/*
 * This is an abstract class that should not be called.
 * The use of this class is to enable us to place a variable
 * in the Registry that can hold any level.
 */

package levels 
{
	import objs.GoalItem;
	import org.flixel.*;
	import objs.Marker;
	
	public class Level extends FlxGroup
	{
		protected var map:FlxTilemap;
		protected var background:FlxTilemap;
		protected var items:FlxTilemap;
		protected var markers:FlxTilemap;
		protected var over:FlxTilemap;
		
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
		
		public function parseMarkers(map:FlxTilemap):void
		{
			for (var ty:int = 0; ty < map.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < map.widthInTiles; tx++)
				{
					/* Change this according to the tile number in DAME */
					/* TODO: improve this, clumsy */
					
					switch (map.getTile(tx, ty))
					{
						case 0:
							break;
						case Marker.LADDER_BOTTOM:
							new Marker(tx, ty, Marker.LADDER_BOTTOM);
							break;
						case Marker.LADDER_TOP:
							new Marker(tx, ty, Marker.LADDER_TOP);
							break;
						default:
							trace("Parsing error: invalid marker: " + map.getTile(tx, ty));
							break;
					}
				}
			}
		}
		
	}

}