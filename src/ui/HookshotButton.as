package ui 
{
	import org.flixel.*;
	
	public class HookshotButton extends WeaponButton
	{
		[Embed(source = '../../assets/img/ui/button_hookshot.png')] private var hookshotPNG:Class;
		
		public function HookshotButton(X:int, Y:int)
		{
			super(X, Y);
			loadGraphic(hookshotPNG, false, false, 46, 52, false);
		}	
	}
}