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
			
			name = new FlxText(40, 400, 400, "Name");
			name.size = 23;
			name.color = 0xFFCCCC00;
			
			text = new FlxText(20, 440, 760, "test test test test test test test test test asdas asd asd as ad awd a sda dwa das da w das da dw da d awd ad a wdasdsadasd w da d dwa da da wd aw da da sd asd awwd");
			text.size = 23;
			
			add(name);
			add(text);
			
			add(nextButton = new NextButton(0, 0));
		}
	}
}