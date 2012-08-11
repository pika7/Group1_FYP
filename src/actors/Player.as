package actors 
{
	import org.flixel.*;
	import objs.Marker;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import util.Registry;
	
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
		private const PREPARE_LADDER_VELOCITY:int = 100;
		
		/* temp variables for storage */
		private var tempPoint:FlxPoint;
		private var tempMarker:Marker;
		
		/* private booleans */
		
		/* what mode the player is in */
		private var mode:int;
		
		/* constants enumerating the mode */
		private const NORMAL:int = 0;
		private const SNEAKING:int = 1;
		private const LADDER:int = 2;
		private const REACHING_LADDER_TOP:int = 3;
		private const PREPARE_LADDER:int = 4; // the player moves to the center of the ladder to prepare for ascent/descent
		private const INITIAL_LADDER_ASCENT:int = 5; // the player climbs a little bit intially
		private const INITIAL_LADDER_DESCENT:int = 6;
		
		/* what weapon the player currently has equipped */
		private var weapon:int;
		
		/* constants enumerating the currently equipped weapon */
		private const TRANQ:int = 0;
		private const HOOKSHOT:int = 1;
		
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
				
				/* use equipped weapon */
				if (FlxG.mouse.justPressed())
				{
					useWeapon(weapon);
				}
				
				/* enter sneaking mode */
				if (FlxG.keys.justPressed("SPACE"))
				{
					setMode(SNEAKING);
					
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
				
				/* use weapon */
				if (FlxG.mouse.justPressed())
				{
					useWeapon(weapon);
				}
				
				/* return to normal mode */
				if (FlxG.keys.justPressed("SPACE"))
				{
					setMode(NORMAL);
					
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
				
				if (y <= tempPoint.y)
				{
					setMode(NORMAL);
				}
			}
			/* repositioning to the center of the ladder */
			else if (mode == PREPARE_LADDER)
			{
				/* make sure absolutely no sideways movement */
				acceleration.x = 0;
				velocity.x = 0;

				/* move the player so it is centered on the ladder */
				if (Math.abs(x - (tempMarker.x)) < 5)
				{
					x = (tempMarker.x);
					
					if (tempMarker.type == Marker.LADDER_BOTTOM)
					{
						setMode(INITIAL_LADDER_ASCENT);
					}
					else if (tempMarker.type == Marker.LADDER_TOP)
					{
						setMode(INITIAL_LADDER_DESCENT);
					}
				}
				else if (x < tempMarker.x)
				{
					velocity.x = PREPARE_LADDER_VELOCITY;
				}
				else if (x > tempMarker.x)
				{
					velocity.x = -PREPARE_LADDER_VELOCITY;
				}

			}
			/* climb the ladder a little bit */
			else if (mode == INITIAL_LADDER_ASCENT)
			{
				/* move the player up by 10 */
				velocity.y = -LADDER_VELOCITY;
				if (y <= tempPoint.y)
				{
					setMode(LADDER);
				}
			}
			/* climb down the ladder a little bit */
			else if (mode == INITIAL_LADDER_DESCENT)
			{
				/* move the player down by 32 */
				velocity.y = LADDER_VELOCITY;
				if (y >= tempPoint.y)
				{
					setMode(LADDER);
				}
			}
			
			super.update();
		}
		
		////////////////////////////////////////////////////////////
		// PRIVATE HELPER FUNCTIONS
		////////////////////////////////////////////////////////////
		
		/* set the mode of the player */
		private function setMode(m:int):void
		{
			switch (m)
			{
				case NORMAL:
					mode = NORMAL;
					maxVelocity.x = MAX_RUNNING_VELOCITY_X;
					acceleration.y = GRAVITY;
					break;
					
				case SNEAKING:
					mode = SNEAKING;
					maxVelocity.x = MAX_SNEAKING_VELOCITY_X;
					acceleration.y = GRAVITY;
					break;
				
				case LADDER:
					mode = LADDER;
					velocity.x = 0;
					velocity.y = 0;
					acceleration.x = 0;
					acceleration.y = 0;
					break;
					
				case REACHING_LADDER_TOP:
					mode = REACHING_LADDER_TOP;
					tempPoint = new FlxPoint(x, y - 60);
					break;
					
				case PREPARE_LADDER:
					velocity.x = 0;
					velocity.y = 0;
					acceleration.x = 0;
					acceleration.y = 0;
					mode = PREPARE_LADDER;
					break;
					
				case INITIAL_LADDER_ASCENT:
					mode = INITIAL_LADDER_ASCENT;
					tempPoint = new FlxPoint(x, y - 10);
					break;
					
				case INITIAL_LADDER_DESCENT:
					mode = INITIAL_LADDER_DESCENT;
					tempPoint = new FlxPoint(x, y + 70);
					break;
			}
		}
		
		/* use the currently equipped weapon */
		private function useWeapon(weapon:int):void
		{
			switch (weapon)
			{
				case TRANQ:
					/* fire a tranq bullet aimed at the mouse */
					Registry.tranqBulletHandler.fire(x, y, FlxVelocity.angleBetweenMouse(this, false));
					break;
				case HOOKSHOT:
					break;
			}
		}
		
		////////////////////////////////////////////////////////////
		// CALLBACK FUNCTIONS (for use in PlayState)
		////////////////////////////////////////////////////////////
		
		/* handle the event when overlapping with a ladder bottom */
		public function handleLadderBottom(player:Player, marker:Marker):void
		{
			/* if W pressed start ladder mode */
			if (FlxG.keys.justPressed("W"))
			{
				setMode(PREPARE_LADDER);
				tempMarker = marker;
			}
			/* if S pressed end ladder mode */
			else if (FlxG.keys.pressed("S"))
			{
				setMode(NORMAL);
			}			
		}
		
		/* handle the event when overlapping with a ladder top */
		public function handleLadderTop(player:Player, marker:Marker):void
		{
			/* if S pressed start ladder mode */
			if (FlxG.keys.justPressed("S"))
			{
				setMode(PREPARE_LADDER);
				tempMarker = marker;
			}
			/* if W pressed end ladder mode */
			else if (FlxG.keys.pressed("W") && mode == LADDER)
			{
				setMode(REACHING_LADDER_TOP);
			}
		}
		
		////////////////////////////////////////////////////////////
		// GETTERS / SETTERS
		////////////////////////////////////////////////////////////
		
		/**
		 * Returns true if the player is currently on a ladder.
		 */
		public function onLadder():Boolean
		{
			if (mode == LADDER || mode == INITIAL_LADDER_ASCENT || mode == INITIAL_LADDER_DESCENT)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Returns true if the player is currently in sneaking mode.
		 */
		public function isSneaking():Boolean
		{
			if (mode == SNEAKING)
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