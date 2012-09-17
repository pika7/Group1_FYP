package cutscenes 
{
	import org.flixel.*;
	
	public class Background extends FlxSprite 
	{
		[Embed(source = '../../assets/img/cutscene/background.png')] private var bgPNG:Class;
		
		/* constants enumerating which background it is */
		public static const NONE:int = 0;
		public static const BACKGROUND_A:int = 1;
		public static const BACKGROUND_B:int = 2;
		
		/**
		 * Create a new background.  Default is a blank black background.
		 */
		public function Background() 
		{
			super(0, 0);
			loadGraphic(bgPNG, false, false, 800, 600, false);
			
			frame = NONE; // no background by default
		}
		
		/**
		 * Set the background number.
		 * 
		 * @param	number	The background to show.
		 */
		public function setBackground(number:int):void
		{
			frame = number;
		}
	}
}