package actors.enemy 
{
	/* Node class for representing each tile in patrol path
	 */
	
	import org.flixel.*;
	
	public class patrolPathNode extends FlxSprite
	{
		public var cost:int = 0; //assign weight depending on the distance to target
		public var g:int = 0; //distance from the start point to the current tile
		public var h:int = 0; //heuristic distance
		public var f:int = 0; //f = g + h 
		public var prev:patrolPathNode = null; //pointer for pointing to previous node
		
		public function patrolPathNode(X:Number, Y:Number) 
		{
			super(X, Y);
			width = 32;
			height = 32;			
		}
		
	}

}