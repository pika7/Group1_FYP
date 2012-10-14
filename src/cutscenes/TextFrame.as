/* this is just the frame below the words */

package cutscenes 
{
	import org.flixel.*;
	
	public class TextFrame extends FlxSprite
	{
		[Embed(source = '../../assets/img/cutscene/textbox.png')] private var framePNG:Class;
		
		public function TextFrame(X:int, Y:int) 
		{
			super(X, Y); // the position of the frame
			alpha = 0.9;
			loadGraphic(framePNG, false, false);
		}	
	}
}