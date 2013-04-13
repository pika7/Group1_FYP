package ui 
{
	import org.flixel.*;
	
	public class TranqButton extends WeaponButton
	{
		[Embed(source = '../../assets/img/ui/button_tranq.png')] private var tranqPNG:Class;
		
		public function TranqButton(X:int, Y:int)
		{
			super(X, Y);
			loadGraphic(tranqPNG, false, false, 46, 52, false);
		}	
	}
}