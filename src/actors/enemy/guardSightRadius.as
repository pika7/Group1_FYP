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
			loadGraphic(sightRadiusPNG, false, true, 400, 400, false);
			alpha = 0.5;
			x = x - width / 2;
			y = y - height / 2;
			exists = false;
		}
		
		public function checkExists():void
		{
		
		}

		override public function update():void
		{
			checkExists();
		}
		
	}

}