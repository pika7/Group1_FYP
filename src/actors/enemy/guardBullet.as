package actors.enemy 
{
	import org.flixel.*;
	import util.Registry;
	import org.flixel.plugin.photonstorm.*;
	
	public class guardBullet extends FlxSprite 
	{
		private var bulletDelay:FlxDelay;
		[Embed(source = '../../../assets/img/bullets/scentBomb.png')] private var bulletPNG:Class;
		
		public function guardBullet() 
		{
			super(0, 0);
			loadGraphic(bulletPNG, false, false, 10, 10);
			exists = false;
			bulletDelay = new FlxDelay(2000);
		}
		
		
		override public function update():void
		{
			super.update();
			if (exists && (x < 0) && justTouched(FLOOR))
			{
				exists = false;
			}
		}
		
	}

}