package util 
{
	import org.flixel.*;
	
	public class CutsceneInfoNode
	{
		public var targetObject:FlxSprite;
		public var action:Function;
		public var initAction:Function // call this once when first running it
		public var destPoint:FlxPoint;
		public var velocityVector:SadVector;
		public var distanceVector:SadVector;
		public var speed:int;
		
		public var hasInitFlag:Boolean = false;
		
		public function CutsceneInfoNode() 
		{
			targetObject = null;
			action = null;
			initAction = null;
			destPoint = new FlxPoint(0,0);
			velocityVector = new SadVector(0, 0);
			distanceVector = new SadVector(0, 0);
			speed = 0;
		}
	}

}