package actors 
{
	import org.flixel.*;
	import objs.Marker;	
	
	public class Player extends FlxSprite
	{	
		[Embed(source = '../../assets/img/player/test_player.png')] private var playerPNG:Class;
		
		private const FRICTION:int = 900;
		private const GRAVITY:int = 600;
		private const MAX_RUNNING_VELOCITY_X:int = 200;
		private const MAX_SNEAKING_VELOCITY_X:int = 100;
		private const MAX_VELOCITY_Y:int = 700;
		private const RUNNING_ACCELERATION:int = 800;
		private const SNEAKING_ACCELERATION:int = 400;
		private const LADDER_VELOCITY:int = 100;
		
		/* private variables */
		private var tempMarker:FlxPoint;
		
		/* private booleans */
		// private var sneakingFlag:Boolean = false; // true if was sneaking. used for changing modes.
		
		/* what mode the player is in */
		private var mode:int;
		
		/* constants enumerating the mode */
		private const NORMAL:int = 0;
		private const SNEAKING:int = 1;
		private const LADDER:int = 2;
		private const REACHING_LADDER_TOP:int = 3;
		
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
			mode = NORMAL;
		}
		
		override public function update():void
		{	
			/* normal mode */
			if (mode == NORMAL)
			{
				/* control left and right movement */
				if (FlxG.keys.pressed("A"))
				{
					facing = FlxObject.LEFT;
					acceleration.x = -RUNNING_ACCELERATION;
				}
				else if (FlxG.keys.pressed("D"))
				{
					facing = FlxObject.RIGHT;
					acceleration.x = RUNNING_ACCELERATION;
				}
				else
				{
					acceleration.x = 0;
				}
				
				/* enter sneaking mode */
				if (FlxG.keys.justPressed("SPACE"))
				{
					mode = SNEAKING;
					maxVelocity.x = MAX_SNEAKING_VELOCITY_X;
					
					/* TEMPORARY: frame change */
					frame = 1;
				}
			}
			/* sneaking mode */
			else if (mode == SNEAKING)
			{
				/* control left and right movement */
				if (FlxG.keys.pressed("A"))
				{
					facing = FlxObject.LEFT;
					acceleration.x = -SNEAKING_ACCELERATION;
				}
				else if (FlxG.keys.pressed("D"))
				{
					facing = FlxObject.RIGHT;
					acceleration.x = SNEAKING_ACCELERATION;
				}
				else
				{
					acceleration.x = 0;
				}
				
				/* return to normal mode */
				if (FlxG.keys.justPressed("SPACE"))
				{
					mode = NORMAL;
					maxVelocity.x = MAX_RUNNING_VELOCITY_X;
					
					/* TEMPORARY: frame change */
					frame = 0;
				}
			}
			/* ladder */
			else if (mode == LADDER)
			{
				/* make absolutely sure that there is no sideways movement */
				velocity.x = 0;
				acceleration.x = 0;
				
				if (FlxG.keys.pressed("W"))
				{
					velocity.y = -LADDER_VELOCITY;
				}
				else if (FlxG.keys.pressed("S"))
				{
					velocity.y = LADDER_VELOCITY;
				}
				else
				{
					velocity.y = 0;
				}
			}
			/* reaching the top of the ladder */
			else if (mode == REACHING_LADDER_TOP)
			{
				/* just move up 128 pixels*/
				velocity.y = -LADDER_VELOCITY;
				
				if (y <= tempMarker.y)
				{
					mode = NORMAL;
				}
			}
			
			super.update();
		}
		
		////////////////////////////////////////////////////////////
		// PRIVATE HELPER FUNCTIONS
		////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS (for use in PlayState)
		////////////////////////////////////////////////////////////
		
		/* handle the event when overlapping with a ladder bottom */
		public function handleLadderBottom(player:Player, marker:Marker):void
		{
			/* if W pressed start ladder mode */
			if (FlxG.keys.pressed("W"))
			{
				mode = LADDER;
				velocity.x = 0;
				velocity.y = 0;
				acceleration.y = 0;
			}
			/* if S pressed end ladder mode */
			else if (FlxG.keys.pressed("S"))
			{
				mode = NORMAL;
				acceleration.y = GRAVITY;
			}			
		}
		
		/* handle the event when overlapping with a ladder top */
		public function handleLadderTop(player:Player, marker:Marker):void
		{
			/* if S pressed start ladder mode */
			if (FlxG.keys.pressed("S"))
			{
				mode = LADDER;
				acceleration.y = 0;
			}
			/* if W pressed end ladder mode */
			else if (FlxG.keys.pressed("W") && mode == LADDER)
			{
				mode = REACHING_LADDER_TOP;
				acceleration.y = GRAVITY;
				tempMarker = new FlxPoint(x, y - 120);
			}
		}
		
		////////////////////////////////////////////////////////////
		// GETTERS / SETTERS
		////////////////////////////////////////////////////////////
		
		public function onLadder():Boolean
		{
			if (mode == LADDER)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
	}
}