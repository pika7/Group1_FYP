package actors.enemy 
{
	import util.Registry;
	import org.flixel.FlxSprite;
	
	
	public class sightRangesFar extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/sightRangeFar.png')] private var sightRangeFarPNG:Class;
		
		public function sightRangesFar(X:int, Y:int) 
		{
			super(X, Y);
			x = Registry.sightranges.x +1;
			width = 30;
			height = 128;
			facing = RIGHT;
			visible =false;
			loadGraphic(sightRangeFarPNG, false, true, 30, 128);
			addAnimation("sightRangeFar", [0], 0, false);
		}
		
		override public function update():void
		{
			//velocity.x = Registry.guard.velocity.x;
			
			//checkFacing();
			//play("sightRangeFar");
		
		}
		
		private function checkFacing():void
		{
			facing = Registry.sightranges.facing;
			if (Registry.guard.radiusChange == false)
			{
				if (Registry.guard.getAlertLevel() == 0)
				{
			
					if (facing == RIGHT)
					{	
						x = Registry.sightranges.x + 90;
						y = Registry.sightranges.y;
					}
					else if (facing == LEFT)
					{
						x = Registry.sightranges.x + 200;
						y = Registry.sightranges.y;
					}
				}
				if (Registry.guard.getAlertLevel() == 1)
				{
					if (facing == RIGHT)
					{	
						x = Registry.sightranges.x + 260;
						y = Registry.sightranges.y;
					}
					else if (facing == LEFT)
					{
						x = Registry.sightranges.x+30;
						y = Registry.sightranges.y;
					}
				}
			if (Registry.guard.getAlertLevel() == 2)
			{
				if (facing == RIGHT)
				{	
					x = Registry.sightranges.x + 330;
					y = Registry.sightranges.y;
				}
				else if (facing == LEFT)
				{
					x = Registry.sightranges.x-30;
					y = Registry.sightranges.y;
				}
				
			}
		}
	
		}
		
		
	}

}