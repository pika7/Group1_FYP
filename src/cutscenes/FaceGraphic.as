package cutscenes 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	
	public class FaceGraphic extends FlxSprite
	{
		[Embed(source = '../../assets/img/cutscene/facegraphics.png')] private var facePNG:Class;

		/* place all of the graphics into an associated array */
		public static var faceGraphics:Array;

		public static const ENTER_VELOCITY:int = 500;
		public static const EXIT_VELOCITY:int = 500;
		public static const FACING_RIGHT_START_X:int = -100;
		public static const FACING_LEFT_START_X:int = 400;
		public static const ENTER_DELAY:int = 100;
		public static const EXIST_DELAY:int = 100;
		
		private var completeCallback:Function; // just used to transfer this var between functions, fucking callbacks.....
		
		/* timers */
		private var enterDelay:FlxDelay = new FlxDelay(ENTER_DELAY);
		private var exitDelay:FlxDelay = new FlxDelay(EXIST_DELAY);
		
		public function FaceGraphic(character:int = 0) 
		{
			super(0, 0);
			loadGraphic(facePNG, false, true, 500, 600, false);
			visible = false;
			frame = character;
			
			/* set callbacks */
			enterDelay.callback = stop;
			exitDelay.callback = stopAndDisappear;
			
			/* set up face graphic array */
			faceGraphics = new Array();
			faceGraphics["NONE"] = 0;
			faceGraphics["JANE"] = 1;
			faceGraphics["CHRISTINE"] = 2;
			faceGraphics["CHRIS"] = 3;
			faceGraphics["HOLLOW"] = 4;
			faceGraphics["MM"] = 5;
			
			
			/* start faded */
			fade();
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
		 * @param callback	The callback function to call after the character has finished
		 * 					entering.
		 */
		public function enter(character:int, callback:Function):void
		{
			completeCallback = callback;
			frame = character;
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
		 * 
		 * @param	THe callback function to call after the character has finished exiting.
		 */
		public function exit(callback:Function):void
		{
			completeCallback = callback;
			exitDelay.start();
			
			if (facing == FlxObject.RIGHT)
			{
				velocity.x = -ENTER_VELOCITY;
			}
			else
			{
				velocity.x = ENTER_VELOCITY;
			}
		}
		
		/**
		 * Fade the character to show that they are not talking.
		 */
		public function fade():void
		{
			color = 0x444444;
		}
		
		/**
		 * Unfade the character to show that they are talking or that nobody is talking.
		 * 
		 */
		public function unfade():void
		{
			color = 0xFFFFFF;
		}
		///////////////////////////////////////////////////////
		// TIMER CALLBACKS (fuck these)
		///////////////////////////////////////////////////////
		
		public function stop():void
		{
			velocity.x = 0;
			completeCallback.call();
		}
		
		public function stopAndDisappear():void
		{
			velocity.x = 0;
			completeCallback.call();
			visible = false;
		}
	}
}