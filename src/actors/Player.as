package actors 
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{	
		[Embed(source = '../../assets/img/player/test_player.png')] private var playerPNG:Class;
		
		private const FRICTION:int = 700;
		private const GRAVITY:int = 600;
		private const MAX_RUNNING_VELOCITY_X:int = 200;
		private const MAX_SNEAKING_VELOCITY_X:int = 100;
		private const MAX_VELOCITY_Y:int = 400;
		private const RUNNING_ACCELERATION:int = 800;
		private const SNEAKING_ACCELERATION:int = 400;
		
		/* private booleans */
		private var isSneakingFlag:Boolean = false;
		
		/* public booleans, because I'm lazy */
		public var gotGoalItem:Boolean = false;
		
		public function Player(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(playerPNG, true, true, 128, 128, true);
			width = 64;
			height = 128;
			centerOffsets();
			
			drag.x = FRICTION;
			acceleration.y = GRAVITY;
			maxVelocity.x = MAX_RUNNING_VELOCITY_X;
			maxVelocity.y = MAX_VELOCITY_Y;
		}
		
		override public function update():void
		{	
			/* control left and right movement */
			if (FlxG.keys.pressed("A"))
			{
				facing = FlxObject.LEFT;
				
				if (!isSneakingFlag)
				{
					acceleration.x = -RUNNING_ACCELERATION;
				}
				else
				{
					acceleration.x = -SNEAKING_ACCELERATION;
				}
			}
			else if (FlxG.keys.pressed("D"))
			{
				facing = FlxObject.RIGHT;
				
				if (!isSneakingFlag)
				{
					acceleration.x = RUNNING_ACCELERATION;
				}
				else
				{
					acceleration.x = SNEAKING_ACCELERATION;
				}
			}
			else
			{
				acceleration.x = 0;
			}
			
			/* enter or exit sneaking mode */
			if (FlxG.keys.justPressed("SPACE"))
			{
				toggleSneakingMode();
			}
			
			super.update();
		}
		
		////////////////////////////////////////////////////////////
		// PRIVATE HELPER FUNCTIONS
		////////////////////////////////////////////////////////////
		
		private function toggleSneakingMode():void
		{
			isSneakingFlag = !isSneakingFlag;
			
			/* TEMPORARY, remove the frame change later */
			if (!isSneakingFlag)
			{
				maxVelocity.x = MAX_RUNNING_VELOCITY_X;
				frame = 0;
			}
			else
			{
				maxVelocity.x = MAX_SNEAKING_VELOCITY_X;
				frame = 1;
			}			
		}
		
	}
}