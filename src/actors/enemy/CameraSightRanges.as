package actors.enemy 
{
	import org.flixel.FlxGroup;
	
	public class CameraSightRanges extends FlxGroup
	{	
		public function CameraSightRanges() 
		{
			super();
		}
		
		public function addCameraSightRange(X:int, Y:int):void
		{
			var tempCameraSR:CameraSightRange = new CameraSightRange(X,Y); 
			add(tempCameraSR);
		}
		
		
		override public function update():void
		{
			super.update();
		}
		
		
	}

}