package cutscenes 
{
	import org.flixel.*;
	
	public class Background extends FlxSprite 
	{
		[Embed(source = '../../assets/img/cutscene/background.png')] private var bgPNG:Class;
		
		public static var backgrounds:Array;

		/**
		 * Create a new background.  Default is a blank black background.
		 */	
		public function Background() 
		{
			super(0, 0);
			loadGraphic(bgPNG, false, false, 800, 600, false);
			
			/* set up the background array */
			backgrounds = new Array();
			backgrounds["NONE"] = 0;
			backgrounds["BACKGROUND_A"] = 1;
			backgrounds["BACKGROUND_B"] = 2;
			
			frame = NONE; // no background by default
		}
		
		/**
		 * Set the background number.
		 * 
		 * @param	number		The background to show.
		 * @param	callback	The function to call after setting the background.
		 */
		public function setBackground(number:int, callback:Function):void
		{
			frame = number;
			callback.call();
		}
	}
}