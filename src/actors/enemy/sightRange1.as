/*
 *  Represents the sight range of guards. Will change according to their alert level.
 */

package actors.enemy 
{
	import org.flixel.FlxSprite;
	import util.Registry;
	

	public class sightRange1 extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/sightRange1.png')] private var sightRange1PNG:Class;
		
		
		public function sightRange1(X:int, Y:int) 
		{
			super(X, Y);
			acceleration.y = 600;
			loadGraphic(sightRange1PNG, false, true, 256, 128);
			width = 256;
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
			if (Registry.guard.getAlertLevel() == 1)
			{
				exists = true;
				visible = true;
			}
			else
			{
				exists = false;
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
				x = Registry.guard.x - 200;
				y = Registry.guard.y;
			}
		}
		
		}
	}

