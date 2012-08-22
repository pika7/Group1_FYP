/*
 *  Represents the sight range of guards. Will change according to their alert level.
 */

package actors.enemy 
{
	import org.flixel.FlxSprite;
	import util.Registry;
	

	public class sightRange extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/sightRange.png')] private var sightRangePNG:Class;
		
		public function sightRange(X:int, Y:int) 
		{
			super(X, Y);
			acceleration.y = 600;
			x = Registry.guard.x+30;
			y = Registry.guard.y;
			loadGraphic(sightRangePNG, false, true, 128, 128);
			width = 128;
			height = 128;
			facing = RIGHT;
			visible = true;
			
		}
		
		override public function update():void
		{
			velocity.x = Registry.guard.velocity.x;
			checkFacing();
			checkAlertLevel();
		}
		
		public function checkAlertLevel():void
		{
			if (Registry.guard.getAlertLevel() == 0)
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
				x = Registry.guard.x +100;
				y = Registry.guard.y;
			}
			else
			{
				x = Registry.guard.x - 100;
				y = Registry.guard.y;
			}
		}
		
		}
	}

