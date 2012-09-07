/* this is an abstract class designed to represent objects that can be parsed in the Level
 * having this class ensures that they will be parsed correctly and in the correct location */

package objs 
{
	import org.flixel.*;
	import util.Registry;
	
	public class ParsableObject extends FlxSprite
	{	
		/**
		 * An object that is automatically parsable when a marker is placed in the csv files.  In order to change
		 * the collision size, set the width and height after calling super(), and then centerOffsets(true).
		 * 
		 * @param	xInTiles		X-coordinate of the object, in tiles.
		 * @param	yInTiles		Y-coordinate of the object, in tiles.
		 * @param	spriteWidth		How wide the image itself is, not the collision width.
		 * @param	spriteHeight	How tall the image itself is, not the collision width.
		 */
		public function ParsableObject(xInTiles:int, yInTiles:int, spriteWidth:int, spriteHeight:int) 
		{
			super(xInTiles * Registry.TILESIZE , yInTiles * Registry.TILESIZE - (spriteHeight - Registry.TILESIZE));
		}
	}

}