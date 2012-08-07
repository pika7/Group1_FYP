/* this is an abstract class designed to represent objects that can be parsed in the Level
 * having this class ensures that they will be parsed correctly and in the correct location */

package objs 
{
	import org.flixel.*;
	import util.Registry;
	
	public class ParsableObject extends FlxSprite
	{	
		public function ParsableObject(xInTiles:int, yInTiles:int, spriteWidth:int, spriteHeight:int) 
		{
			super(xInTiles * Registry.TILESIZE , yInTiles * Registry.TILESIZE - (spriteHeight - Registry.TILESIZE));
		}
	}

}