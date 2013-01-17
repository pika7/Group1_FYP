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
		[Embed(source = '../../../assets/img/enemies/guardAlertcircle.png')] private var sightRadiusPNG:Class;
	
		public function guardSightRadius(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(sightRadiusPNG, false, true, 200, 200, false);
			alpha = 0.5;
			width = 200;
			height = 200;
			exists = true;
			visible = false;
		}
		
		public function checkExists():void
		{
			if (Registry.guard.radiusChange == true)
			{
				visible = true;
				x = Registry.guard.x - width / 2 + 10;
				y = Registry.guard.y - height / 2 + 30;
			}
			if(Registry.guard.radiusChange ==false)
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