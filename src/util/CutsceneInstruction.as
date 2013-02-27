package util 
{
	import org.flixel.*;
	
	public class CutsceneInstruction
	{
		public var targetObject:FlxSprite;
		public var action:Function;
		public var initAction:Function // call this once when first running it
		public var destPoint:FlxPoint;
		public var speed:int;
		
		public var hasInitFlag:Boolean = false;
		
		public function CutsceneInstruction() 
		{
			targetObject = null;
			action = null;
			initAction = null;
			destPoint = new FlxPoint(0,0);
			speed = 0;
		}
	}

}