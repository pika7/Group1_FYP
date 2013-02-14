package cutscenes 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	
	public class FaceGraphic extends FlxSprite
	{
		[Embed(source = '../../assets/img/cutscene/facegraphics.png')] private var facePNG:Class;

		/* enumerate all the different types of graphics */
		public static const NONE:int = 0;
		public static const GIRL_1:int = 1;
		public static const GIRL_2:int = 2;
		
		public static const ENTER_VELOCITY:int = 500;
		public static const FACING_RIGHT_START_X:int = -100;
		public static const FACING_LEFT_START_X:int = 400;
		public static const ENTER_DELAY:int = 100;
		
		/* timers */
		private var enterDelay:FlxDelay = new FlxDelay(ENTER_DELAY);
		
		public function FaceGraphic(character:int = 0) 
		{
			super(0, 0);
			loadGraphic(facePNG, false, true, 500, 600, false);
			visible = false;
			frame = character;
			
			/* set callbacks */
			enterDelay.callback = stop;
		}
		
		override public function update():void
		{
			/* adjust the alpha based on timers */
			
			
			super.update();
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
		
		/**
		 * Enter the character.  If a character is already displayed, exit it first
		 * before entering the new one.
		 * 
		 * @param character The character to enter
		 */
		public function enter(character:int):void
		{
			enterDelay.start();
			visible = true;
			
			if (facing == FlxObject.RIGHT) 
			{
				velocity.x = ENTER_VELOCITY;
				x = FACING_RIGHT_START_X;
			}
			else
			{
				velocity.x = -ENTER_VELOCITY;
				x = FACING_LEFT_START_X;
			}
		}
		
		/**
		 * Exit a character.
		 */
		public function exit():void
		{
			
		}
		
		///////////////////////////////////////////////////////
		// TIMER CALLBACKS (fuck these)
		///////////////////////////////////////////////////////
		
		public function stop():void
		{
			velocity.x = 0;
		}
	}
}