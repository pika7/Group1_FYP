package cutscenes 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	
	public class TextBox extends FlxGroup
	{
		public static const CHAR_DELAY = 10;
		
		protected var textFrame:TextFrame;
		protected var name:FlxText;
		protected var text:FlxText;
		protected var nextButton:NextButton
		protected var sayText:String;
		protected var currChar:int;
		
		/* timers */
		protected var charDelay:FlxDelay = new FlxDelay(CHAR_DELAY);
		
		public function TextBox()
		{
			add(textFrame = new TextFrame(10, 390));
			
			name = new FlxText(40, 410, 400);
			name.size = 23;
			name.color = 0xFFCCCC00;
			name.text = ""
			
			/* the maximum number of characters in the text block is 116 */
			text = new FlxText(50, 440, 700);
			text.size = 20;
			text.text = "";
			
			add(name);
			add(text);
			
			add(nextButton = new NextButton(680, 545));
			
			/* timers */
			charDelay.callback = nextChar;
		}
		
		override public function update():void
		{
			/* make the characters appear one by one */
		}
		
		/**
		 * The textbox displays the name and text provided.
		 * 
		 * @param	name	The name of the character.
		 * @param	text	What the character says.
		 */
		public function say(paramName:String, paramText:String):void
		{
			name.text = paramName;
			sayText = paramText;
			currChar = 0;
			charDelay.start();
		}
		
		///////////////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS
		///////////////////////////////////////////////////////////////////////
		
		/* make the next character in the textbox appear */
		private function nextChar():void
		{
			text.text = text.text + sayText.charAt(currChar);
			
			if (currChar < sayText.length)
			{
				currChar++;
				charDelay.start();
			}
		}
	}
}