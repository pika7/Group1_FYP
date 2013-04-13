package ui 
{
	import org.flixel.*;
	
	public class SmokeBombButton extends WeaponButton
	{
		[Embed(source = '../../assets/img/ui/button_smoke.png')] private var smokePNG:Class;
		
		public function SmokeBombButton(X:int, Y:int)
		{
			super(X, Y);
			loadGraphic(smokePNG, false, false, 46, 52, false);
		}	
	}
}