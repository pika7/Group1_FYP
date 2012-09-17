package cutscenes 
{
	import org.flixel.*;
	
	public class FaceGraphic extends FlxSprite
	{
		[Embed(source = '../../assets/img/cutscene/facegraphics.png')] private var facePNG:Class;

		/* enumerate all the different types of graphics */
		public static const NONE:int = 0;
		public static const GIRL_1:int = 1;
		public static const GIRL_2:int = 2;
		
		public function FaceGraphic(character:int = 0) 
		{
			super(0, 0);
			loadGraphic(facePNG, false, true, 500, 600, false);
			
			frame = character;
		}
		
		/**
		 * Set the character of the face graphics.
		 * 
		 * @param	character	The character to show.
		 */
		public function setCharacter(character:int):void
		{
			frame = character;
		}
	}
}