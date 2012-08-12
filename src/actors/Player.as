package actors 
{
	import org.flixel.*;
	import objs.Marker;
	import org.flixel.plugin.photonstorm.FlxDelay;
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
		private const RELOAD_TIME:int = 750;
		private const HOOKSHOT_PULL_SPEED:int = 400;
		private const HOOKSHOT_DANGLE_DISTANCE:int = 100;
		
		/* noise raadius for player footsteps */
		private var noiseRadius:NoiseRadius;
		
		/* temp variables for storage */
		private var tempPoint:FlxPoint;
		private var tempMarker:Marker;
		
		/* timers */
		private var reloadTimer:FlxDelay;
		
		/* private booleans */
		
		/* what mode the player is in */
		private var mode:int;
		
		/* constants enumerating the mode */
		public static const NORMAL:int = 0;
		public static const SNEAKING:int = 1;
		public static const LADDER:int = 2;
		public static const REACHING_LADDER_TOP:int = 3;
		public static const PREPARE_LADDER:int = 4; // the player moves to the center of the ladder to prepare for ascent/descent
		public static const INITIAL_LADDER_ASCENT:int = 5; // the player climbs a little bit intially
		public static const INITIAL_LADDER_DESCENT:int = 6;
		public static const RELOADING_NORMAL:int = 7; // the player reloads for a in normal mode and can't move
		public static const RELOADING_SNEAKING:int = 8; // the player reloads for a while in sneaking mode and can't move
		public static const HOOKSHOT_PULLING:int = 9; // the player is being dragged to the hookshot location
		public static const HOOKSHOT_DANGLING:int = 10; // the player is dangling from the hookshot
		
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
			weapon = HOOKSHOT;
			
			/* instantiate timers */
			reloadTimer = new FlxDelay(RELOAD_TIME);
			
			/* instantiate other things */
			noiseRadius = new NoiseRadius(x, y, false);
			tempPoint = new FlxPoint(0, 0);
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
					noiseRadius.on();
				}
				else if (FlxG.keys.pressed("D"))
				{
					facing = FlxObject.RIGHT;
					acceleration.x = RUNNING_ACCELERATION;
					noiseRadius.on();
				}
				else
				{
					acceleration.x = 0;
					noiseRadius.off();
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
			/* reloading */
			else if (mode == RELOADING_NORMAL)
			{
				/* if reloading, stand there and do nothing for a while */
				if (!reloadTimer.isRunning)
				{
					setMode(NORMAL);
				}
				
			}
			/* reloading in sneaking mode */
			else if (mode == RELOADING_SNEAKING)
			{
				/* if reloading, stand there and do nothing for a while */
				if (!reloadTimer.isRunning)
				{
					setMode(SNEAKING);
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
			/* get pulled to the hookshot */
			else if (mode == HOOKSHOT_PULLING)
			{
				/* pull the player to the hookshot's location until a certain distance */
				tempPoint.x = Registry.hookshot.x + Registry.player.width/2; // this needs to be fixed
				tempPoint.y = Registry.hookshot.y + HOOKSHOT_DANGLE_DISTANCE;
				FlxVelocity.moveTowardsPoint(this, tempPoint, HOOKSHOT_PULL_SPEED);
				
				if (FlxVelocity.distanceBetween(this, Registry.hookshot) <= HOOKSHOT_DANGLE_DISTANCE)
				{
					setMode(HOOKSHOT_DANGLING);
				}
			}
			else if (mode == HOOKSHOT_DANGLING)
			{
				/* make a dangling effect from the rope */
				if (FlxVelocity.distanceBetween(this, Registry.hookshot) > HOOKSHOT_DANGLE_DISTANCE)
				{
					
				}
				
				/* if press the mouse, then drop back to the ground */
				if (FlxG.mouse.pressed())
				{
					Registry.hookshot.remove();
					setMode(NORMAL);
					/* TODO: make another mode for dropping down from the hookshot so the player can't spiderman on the ceiling */
				}
			}
			
			/* make the noise radius follow the player */
			noiseRadius.follow(this);
			
			super.update();
		}
		
		////////////////////////////////////////////////////////////
		// HELPER FUNCTIONS
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
				
				case RELOADING_NORMAL:
					mode = RELOADING_NORMAL;
					velocity.x = 0;
					acceleration.x = 0;
					reloadTimer.start();
					break;
					
				case RELOADING_SNEAKING:
					mode = RELOADING_SNEAKING;
					velocity.x = 0;
					acceleration.x = 0;
					reloadTimer.start();
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
					tempPoint.x = x;
					tempPoint.y = y - 60;
					break;
					
				case PREPARE_LADDER:
					mode = PREPARE_LADDER;
					velocity.x = 0;
					velocity.y = 0;
					acceleration.x = 0;
					acceleration.y = 0;
					break;
					
				case INITIAL_LADDER_ASCENT:
					mode = INITIAL_LADDER_ASCENT;
					tempPoint.x = x;
					tempPoint.y = y - 10;
					break;
					
				case INITIAL_LADDER_DESCENT:
					mode = INITIAL_LADDER_DESCENT;
					tempPoint.x = x;
					tempPoint.y = y + 70;
					break;
					
				case HOOKSHOT_PULLING:
					velocity.x = 0;
					velocity.y = 0;
					acceleration.x = 0;
					acceleration.y = 0;
					mode = HOOKSHOT_PULLING;
					break;
					
				case HOOKSHOT_DANGLING:
					mode = HOOKSHOT_DANGLING;
					acceleration.y = GRAVITY;
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
					
					if (mode == NORMAL)
					{
						setMode(RELOADING_NORMAL);
					}
					else if (mode == SNEAKING)
					{
						setMode(RELOADING_SNEAKING);
					}
					
					break;
				case HOOKSHOT:
					Registry.hookshot.fire(x, y, FlxVelocity.angleBetweenMouse(this, false));
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
			if (mode == SNEAKING || mode == RELOADING_SNEAKING)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * For use with hookshot.  Pulls the player towards it.
		 */
		public function pullToHookshot():void
		{
			if (mode != HOOKSHOT_DANGLING)
			{
				setMode(HOOKSHOT_PULLING);
			}
		}
		
	}
}