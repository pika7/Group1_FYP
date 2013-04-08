/* ABSTRACT CLASS, DO NOT INSTANTIATE */

package ui 
{
	import org.flixel.*;
	
	public class WeaponButton extends FlxButton
	{	
		public function WeaponButton(X:int, Y:int) 
		{
			super(X, Y);
			frame = 0;
			on = true; // checkbox behaviour
		}
	}
}