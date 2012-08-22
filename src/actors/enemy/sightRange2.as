package actors.enemy 
{
	import org.flixel.FlxSprite;
	import util.Registry;
	

	public class sightRange2 extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/sightRange2.png')] private var sightRange2PNG:Class;
		
		
		public function sightRange2(X:int, Y:int) 
		{
			super(X, Y);
			acceleration.y = 600;
			loadGraphic(sightRange2PNG, false, true, 384, 128);
			width = 384;
			height = 128;
			facing = RIGHT;
			visible = true;
		}
		
		override public function update():void
		{
			velocity.x = Registry.guard.velocity.x;
			checkAlertLevel();
			checkFacing();
		}
		
		public function checkAlertLevel():void
		{
			if (Registry.guard.getAlertLevel() == 2)
			{
				exists = true;
				visible = true;
			}
			else
			{
				exists = false;
				visible = false;
			}
		}
		
		private function checkFacing():void
		{
			facing = Registry.guard.facing;
			if (facing == RIGHT)
			{
				x = Registry.guard.x + 100;
				y = Registry.guard.y;
			}
			else
			{
				x = Registry.guard.x - 340;
				y = Registry.guard.y;
			}
		}
		
		}
	}
