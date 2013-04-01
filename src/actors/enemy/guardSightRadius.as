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
	
		public var radiusChange:Boolean = false;
		
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
		
		
		
	}

}