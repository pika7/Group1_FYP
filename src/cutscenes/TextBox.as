/* contains all elements of the textbox, such as frame, buttons, names, and text */

package cutscenes 
{
	import org.flixel.*;
	
	public class TextBox extends FlxGroup
	{
		protected var textFrame:TextFrame;
		protected var name:FlxText;
		protected var text:FlxText;
		protected var nextButton:NextButton
		
		public function TextBox()
		{
			add(textFrame = new TextFrame(10, 390));
			
			name = new FlxText(40, 400, 400);
			name.size = 23;
			name.color = 0xFFCCCC00;
			name.text = "Name"
			
			/* the maximum number of characters in the text block is 116 */
			text = new FlxText(20, 440, 760);
			text.size = 23;
			text.text =  "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm";
			
			add(name);
			add(text);
			
			add(nextButton = new NextButton(680, 565));
		}
	}
}