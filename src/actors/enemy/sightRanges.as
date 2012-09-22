package actors.enemy 
{
	import util.Registry;
	import org.flixel.FlxSprite;
	
	public class sightRanges extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/sightRanges.png')] private var sightRangePNG:Class;
		
		public function sightRanges(X:int, Y:int) 
		{	
			super(X, Y);
			x = Registry.guard.x+100;
			y = Registry.guard.y;
			width = 341;
			height = 128;
			facing = RIGHT;
			visible = true;
			
			loadGraphic(sightRangePNG, false, true, 321, 128);
			addAnimation("alert0", [0], 0, false);
			addAnimation("alert1", [1], 0, false);
			addAnimation("alert2", [2], 0, false);
			
		}
		
		override public function update():void
		{
			velocity.x = Registry.guard.velocity.x;
			checkAlertLevel();
			checkFacing();
			play("alert0");
		
		}
		
		public function checkAlertLevel():void
		{
			switch (Registry.guard.getAlertLevel())
			{
				case 0:
					play("alert0");
					break;
				case 1:
					play("alert1");
					break;
				case 2:
					play("alert2");
					break;
			}
		}
		
		private function checkFacing():void
		{
			facing = Registry.guard.facing;
			if (facing == RIGHT)
			{
				x = Registry.guard.x +100;
				y = Registry.guard.y;
			}
			else if (facing == LEFT)
			{
				x = Registry.guard.x - 320;
				y = Registry.guard.y;
			}
		}
		
	}

}