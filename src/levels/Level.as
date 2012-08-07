/*
 * This is an abstract class that should not be called.
 * The use of this class is to enable us to place a variable
 * in the Registry that can hold any level.
 */

package levels 
{
	import org.flixel.*;
	
	public class Level extends FlxGroup
	{
		public var map:FlxTilemap;
		public var background:FlxTilemap;
		
		public var width:int;
		public var height:int;
		
		public function Level() 
		{
			
		}
		
		/* insert parse functions later */
		
	}

}