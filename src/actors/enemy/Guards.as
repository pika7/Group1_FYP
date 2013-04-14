package actors.enemy 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import actors.enemy.Guard;
	
	public class Guards extends	FlxGroup
	{
	
		public function Guards() 
		{
			super();
		}
		
		public function addGuard(X:int, Y:int, patrolStartX:int, patrolStartY:int, patrolEndX:int, patrolEndY:int):void
		{
			var tempGuard:Guard = new Guard(X, Y, patrolStartX, patrolStartY, patrolEndX, patrolEndY); 
			add(tempGuard);
		}
		
		
		
		override public function update():void
		{
			super.update();
		}
		
	}

}