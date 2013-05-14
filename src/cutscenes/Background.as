package cutscenes 
{
	import org.flixel.*;
	
	public class Background extends FlxSprite 
	{
		[Embed(source = '../../assets/img/cutscene/backgrounds.png')] private var bgPNG:Class;
		
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
			backgrounds["CLASSROOM"] = 0;
			backgrounds["HOME"] = 1;
			backgrounds["MUSEUM"] = 2;
			backgrounds["GALLERY"] = 3;
			backgrounds["MANSION"] = 4;
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