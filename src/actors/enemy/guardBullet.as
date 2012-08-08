package actors.enemy 
{
	import org.flixel.*;
	import util.Registry;
	
	
	public class guardBullet extends FlxSprite 
	{
		[Embed(source = '../../../assets/img/bullets/scentBomb.png')] private var bulletPNG:Class;
		
		public function guardBullet() 
		{
			super(0, 0);
			loadGraphic(bulletPNG, false, false, 10, 10);
			exists = false;
		}
		
		public function fire(bx:int, by:int):void
		{
			x = bx;
			y = by;
			exists = true;
		}
		
		override public function update():void
		{
			super.update();
			if (exists && (x < 0))
			{
				exists = false;
			}
		}
		
	}

}