package ui 
{
	import org.flixel.*;
	
	public class StunGrenadeButton extends WeaponButton
	{
		[Embed(source = '../../assets/img/ui/button_stun.png')] private var stunPNG:Class;
		
		public function StunGrenadeButton(X:int, Y:int)
		{
			super(X, Y);
			loadGraphic(stunPNG, false, false, 46, 52, false);
		}	
	}
}