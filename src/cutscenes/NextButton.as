package cutscenes 
{
	import org.flixel.*;
	
	public class NextButton extends FlxSprite
	{		
		[Embed(source = '../../assets/img/cutscene/nextbutton.png')] private var buttonPNG:Class;
		
		public function NextButton(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(buttonPNG, false, false);
			visible = false;
		}	
	}
}