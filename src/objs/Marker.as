/* these invisible markers can be placed on the map to trigger events or interact with the player or enemies */

package objs 
{
	import org.flixel.*;
	import util.Registry;
	
	public class Marker extends ParsableObject
	{
		/* these represent the different types of markers */
		public static const LADDER_BOTTOM:int = 1;
		public static const LADDER_TOP:int = 2;
		public static const HOOKSHOTABLE:int = 3;
		
		public var type:int;
		
		/* embed some invisible picture later */
		[Embed(source = '../../assets/img/objs/blank.png')] private var blankPNG:Class;
		
		public function Marker(xInTiles:int, yInTiles:int, markerType:int) 
		{
			super(xInTiles, yInTiles, 32, 5);
			loadGraphic(blankPNG, true, true, 32, 32, true);
			
			width = 32;
			height = 5;
			type = markerType;
			
			/* depending on the marker type, place into the corresponding Registry group */
			switch (markerType)
			{
				case LADDER_BOTTOM:
					Registry.markers_ladderBottom.add(this);
					break;
				case LADDER_TOP:
					offset.y = 128;
					y -= 64;
					Registry.markers_ladderTop.add(this);
					break;
				case HOOKSHOTABLE:
					Registry.markers_hookshotable.add(this);
					break;
				default:
					trace("ERR: invalid marker");
					break;
			}
		}
		
	}

}