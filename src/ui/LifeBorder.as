/* this class is just the border of the LifeBar */

package ui 
{
	import org.flixel.*;
	
	public class LifeBorder extends FlxSprite
	{	
		[Embed(source = '../../assets/img/ui/lifebar.png')] private var barPNG:Class;
		
		public function LifeBorder(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(barPNG, false, false, 200, 20);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
		}	
	}
}