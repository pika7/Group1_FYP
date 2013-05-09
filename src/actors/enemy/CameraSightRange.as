package actors.enemy 
{
	import org.flixel.*;
	
	public class CameraSightRange extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/cameraSightRange.png')] private var cameraSightRangePNG:Class;
		
		private var rotateCounter:Number = 0;
		private var  originalPos:FlxPoint;
		private const moveLeft:int = 200;
		
		public function CameraSightRange(X:int, Y:int)
		{	
			super(X, Y);
			width = 192;
			height = 128;
			facing = RIGHT;
			visible = false;
			loadGraphic(cameraSightRangePNG, false, true, 192, 128);
			
			originalPos = new FlxPoint(X, Y);
			
		}		
		
		override public function update():void
		{
			rotateCounter += FlxG.elapsed;
			if (rotateCounter > 2)
			{
				if (facing == RIGHT)
				{
					facing = LEFT;
					x = x -  moveLeft;
					rotateCounter = 0;
				}
				else
				{
					facing = RIGHT;
					x = originalPos.x;
					y = originalPos.y;
					rotateCounter = 0;
				}
			}
			
		}
	}

}