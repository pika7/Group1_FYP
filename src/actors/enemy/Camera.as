package actors.enemy 
{
	import org.flixel.*;

	public class Camera extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/camera.png')] private var cameraPNG:Class;
		
		private var rotateCounter:Number = 0;
		
		public function Camera(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(cameraPNG, true, true, 32, 32, true);
			width = 32;
			height = 32;
			visible = true;
		}
		
		override public function update():void
		{
			rotateCounter += FlxG.elapsed;
			if (rotateCounter > 2)
			{
				if (facing == RIGHT)
				{
					facing = LEFT;
					rotateCounter = 0;
				}
				else
				{
					facing = RIGHT;
					rotateCounter = 0;
				}
			}
			
		}
		
	}

}