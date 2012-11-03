package cutscenes 
{
	import org.flixel.*;
	
	public class TextBox extends FlxSprite
	{
		[Embed(source = '../../assets/img/cutscene/textbox.png')] private var textboxPNG:Class;
		
		public function TextBox() 
		{
			super(15, 390);
			loadGraphic(textboxPNG, false, false, 760, 200);
			
			alpha = 0.9;
		}
	}
}