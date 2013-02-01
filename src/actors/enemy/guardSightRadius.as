package actors.enemy 
{
	import org.flixel.FlxSprite;
	import util.Registry;
	/**
	 * ...
	 * @author 
	 */
	public class guardSightRadius extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/guardAlertcircle3.png')] private var sightRadiusPNG:Class;
	
		public function guardSightRadius(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(sightRadiusPNG, false, true, 100, 100, false);
			alpha = 0.5;
			width = 100;
			height = 100;
			exists = true;
			visible = false;
		}
		
		public function checkExists():void
		{
			if (Registry.guard.radiusChange == true)
			{
				visible = true;
				x = Registry.guard.x;
				y = Registry.guard.y - (Registry.TILESIZE * 2) ;
				
				if (Registry.guard.facing == RIGHT)
				{
					facing = RIGHT;
				}
				else
				{
					facing = LEFT;
					x = Registry.guard.x - (Registry.TILESIZE *2);
				}
				
			}
			if(Registry.guard.radiusChange == false)
			{
				visible = false;
			}
		}
		override public function update():void
		{
			checkExists();
		}
		
	}

}