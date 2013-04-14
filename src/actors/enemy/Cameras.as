package actors.enemy 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import actors.enemy.Camera

	public class Cameras extends FlxGroup
	{
	
		public function Cameras() 
		{
			super();
		}
		
		public function addCamera(X:int, Y:int):void
		{
			var tempCamera:Camera = new Camera(X,Y); 
			add(tempCamera);
		}
		
		
		override public function update():void
		{
			super.update();
		}
		
	}

}