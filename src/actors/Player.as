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
		
		/* dummy sprite located at the firing location of the sprite used for FlxVelocity */
		public var firePoint:FlxSprite;
		
		/* general constants */
		private const FRICTION:int = 900;
		private const GRAVITY:int = 600;
		private const MAX_RUNNING_VELOCITY_X:int = 200;
		private const MAX_SNEAKING_VELOCITY_X:int = 100;
		private const MAX_VELOCITY_Y:int = 700;
		private const RUNNING_ACCELERATION:int = 800;
		private const SNEAKING_ACCELERATION:int = 400;
		
		/* ladders */
		private const LADDER_VELOCITY:int = 100;
		private const PREPARE_LADDER_VELOCITY:int = 100;
		
		/* tranq */
		private const RELOAD_TIME:int = 600;
		
		/* hookshot */
		private const HOOKSHOT_PULL_SPEED:int = 400;
		private const HOOKSHOT_DANGLE_DISTANCE:int = 100;
		private const BASE_ANGULAR_ACCELERATION:Number = -10;
		private const DAMPING:Number = 0.99;
		private const SWING_CONVERSION:Number = 0.6; // this is just to transition the normal movement to swing movement smoothly
		private const ROPE_SHORTEN_SPEED:int = 60;
		private const SWING_EXTEND_STRENGTH:Number = 1.02;
		private const MAXIMUM_SWING_VELOCITY:Number = 1;
		private const HOOKSHOT_FLY_VELOCITY_MULTIPLIER:Number = 1.5; // how much the amplify the velocity after coming off a hookshot
		private const HOOKSHOT_FLY_GRAVITY:int = 400; // the gravity after coming off a hookshot
		private const HOOKSHOT_FLY_ACCELERATION:int = 100; // how well the player can control themselves in the air after flying off a hookshot
		private const START_SWING_THRESHOLD:int = 10; // the smaller the value the closer to 0 the swinging speed must be to start a swing extend
		private const START_SWING_STRENGTH:int = 30;
		private const SWING_BOUNCEBACK_VELOCITY:int = 50; // the speed at which the rope "bounces back" after hitting horizontal
		private const HOOKSHOT_RELOAD_TIME:int = 500;
		
		/* bombs */
		private const PREPARE_BOMB_TIME:int = 500;
		
		/* noise raadius for player footsteps */
		private var noiseRadius:NoiseRadius;
		
		/* temp variables for storage */
		private var tempPoint:FlxPoint;
		private var tempMarker:Marker;
		private var tempAngle:Number;
		
		/* timers */
		private var reloadTimer:FlxDelay;
		private var prepareBombTimer:FlxDelay;
		private var hookshotReloadTimer:FlxDelay;
		
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
		public static const HOOKSHOT_FLY:int = 11; // the player is in the air after having dropped from a hookshot
		public static const IN_AIR:int = 12; // just in air after stepping off a platform etc.
		public static const PREPARE_BOMB_NORMAL:int = 13; // preparing to throw a bomb or grenade in normal mode
		public static const PREPARE_BOMB_SNEAKING:int = 14; // preparing to throw a bomb or grenade in sneaking mode
		public static const AIMING_NORMAL:int = 15; // aiming in normal mode
		public static const AIMING_SNEAKING:int = 16; // aiming in sneaking mode
		public static const HOOKSHOT_RELOADING_NORMAL:int = 17;
		public static const HOOKSHOT_RELOADING_SNEAKING:int = 18;
		
		/* what weapon the player currently has equipped */
		private var weapon:int;
		
		/* used to calculate swinging from a rope */
		private var swingAngularVelocity:Number;
		private var swingAngularAcceleration:Number;
		private var ropeLength:Number = 0;
		private var ropeAngle:Number; // how far it is from the 6 o'clock position
		private var moveAngle:Number; // at what angle the player should anctually move
		
		/* constants enumerating the currently equipped weapon */
		private const TRANQ:int = 0;
		private const HOOKSHOT:int = 1;
		private const SMOKEBOMB:int = 2;
		
		/* public booleans, because I'm lazy */
		public var gotGoalItem:Boolean = false;
		public var isClimbingUpLadder:Boolean = false; // returns true if player started at the bottom of the ladder and is on the ladder.
		public var isClimbingDownLadder:Boolean = false; // returns true if the player started at the top of the ladder and is on the ladder.
		public var doneClimbingUpLadder:Boolean = false; // returns true if the player just finished climbing to the top of the ladder.
		public var doneClimbingDownLadder:Boolean = false; // returns true if the player just finished climbing to the bottom of the ladder.
		
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
			mode = IN_AIR;
			weapon = TRANQ;
			
			/* instantiate timers */
			reloadTimer = new FlxDelay(RELOAD_TIME);
			prepareBombTimer = new FlxDelay(PREPARE_BOMB_TIME);
			hookshotReloadTimer = new FlxDelay(HOOKSHOT_RELOAD_TIME);
			
			/* instantiate other things */
			noiseRadius = new NoiseRadius(x, y, false);
			tempPoint = new FlxPoint(0, 0);
			firePoint = new FlxSprite(x + width / 2, y + height / 2);
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
					if (weapon == TRANQ || weapon == HOOKSHOT)
					{
						setMode(AIMING_NORMAL);
					}
					else
					{
						useWeapon();
					}
				}
				
				/* enter sneaking mode */
				if (FlxG.keys.justPressed("SPACE"))
				{
					setMode(SNEAKING);
				}
				
				/* step off a platform */
				if (!isTouching(FlxObject.FLOOR))
				{
					setMode(IN_AIR);
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
				
				/* use equipped weapon */
				if (FlxG.mouse.justPressed())
				{
					if (weapon == TRANQ || weapon == HOOKSHOT)
					{
						setMode(AIMING_SNEAKING);
					}
					else
					{
						useWeapon();
					}
				}
				
				/* return to normal mode */
				if (FlxG.keys.justPressed("SPACE"))
				{
					setMode(NORMAL);
				}
				
				/* step off a platform */
				if (!isTouching(FlxObject.FLOOR))
				{
					setMode(IN_AIR);
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
					noiseRadius.on();
				}
				else if (FlxG.keys.pressed("S"))
				{
					velocity.y = LADDER_VELOCITY;
					noiseRadius.on();
				}
				else
				{
					velocity.y = 0;
					noiseRadius.off();
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
					isClimbingUpLadder = true;
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
					isClimbingDownLadder = true;
					setMode(LADDER);
				}
			}
			/* get pulled to the hookshot */
			else if (mode == HOOKSHOT_PULLING)
			{
				/* reset the angular velocities */
				swingAngularAcceleration = 0;
				swingAngularVelocity = 0;
				
				/* pull the player to the hookshot's location until a certain distance */
				tempPoint.x = Registry.hookshot.x + Registry.player.width/2; // this needs to be fixed
				tempPoint.y = Registry.hookshot.y + HOOKSHOT_DANGLE_DISTANCE;
				FlxVelocity.moveTowardsPoint(this, tempPoint, HOOKSHOT_PULL_SPEED);
				
				/* change to dangling mode if within a certain length */
				if (FlxVelocity.distanceBetween(this, Registry.hookshot) <= HOOKSHOT_DANGLE_DISTANCE)
				{
					setMode(HOOKSHOT_DANGLING);
				}
			}
			/* dangling from the hookshot, can swing */
			else if (mode == HOOKSHOT_DANGLING)
			{	
				ropeAngle = (0.5 * Math.PI) - FlxVelocity.angleBetweenPoint(Registry.hookshot, tempPoint);
				ropeLength = FlxVelocity.distanceBetween(this, Registry.hookshot);
				tempPoint.x = Registry.player.x + Registry.player.width / 2;
				tempPoint.y = Registry.player.y;
				
				/* the angular acceleration is directly proportional to how far the player is from the centerpoint (6oclock) */
				swingAngularAcceleration = ropeAngle * BASE_ANGULAR_ACCELERATION;
				
				/* now change the angularVelocity depending on what the angular acceleration is */
				swingAngularVelocity += swingAngularAcceleration;
				
				/* however, do not allow the player to swing above horizontal or weird things happen (shouldnt really get here ever) */
				if (ropeAngle <= -(0.5 * Math.PI))
				{
					swingAngularVelocity = -SWING_BOUNCEBACK_VELOCITY;
				}
				
				if (ropeAngle >= (0.5 * Math.PI))
				{
					swingAngularVelocity = SWING_BOUNCEBACK_VELOCITY;
				}
							
				/* first, find the angle to move the player at... this depends on the rope angle */
				moveAngle = (0.5 * Math.PI) - ropeAngle;			
				
				/* apply damping ... swings get gradually smaller */
				swingAngularVelocity = swingAngularVelocity * DAMPING;
				
				/* if press A or D, swing more */
				/* the speed at which you swing is proportional to the length of the rope */
				if (FlxG.keys.pressed("A"))
				{
					if (swingAngularVelocity > -(MAXIMUM_SWING_VELOCITY * ropeLength) && swingAngularVelocity < 0)
					{
						swingAngularVelocity = swingAngularVelocity * SWING_EXTEND_STRENGTH;
					}
					else if (swingAngularVelocity <= START_SWING_THRESHOLD && swingAngularVelocity >= -START_SWING_THRESHOLD && ropeAngle <= Math.PI/8 && ropeAngle >= -Math.PI/20)
					{
						swingAngularVelocity -= START_SWING_STRENGTH;
					}
				}
				else if (FlxG.keys.pressed("D"))
				{
					if (swingAngularVelocity < (MAXIMUM_SWING_VELOCITY * ropeLength) && swingAngularVelocity > 0)
					{
						swingAngularVelocity = swingAngularVelocity * SWING_EXTEND_STRENGTH;
					}
					else if (swingAngularVelocity <= START_SWING_THRESHOLD && swingAngularVelocity >= -START_SWING_THRESHOLD && ropeAngle <= Math.PI/8 && ropeAngle >= -Math.PI/20)
					{
						swingAngularVelocity += START_SWING_STRENGTH;
					}
				}
				
				/* now actually move the player */
				velocity.x = swingAngularVelocity * Math.sin(moveAngle);
				velocity.y = swingAngularVelocity * -Math.cos(moveAngle);	
				
				/* if press W or S, change the length of the rope... move towards or away from hookshot */
				if (FlxG.keys.pressed("W") && ropeLength > Registry.hookshot.MIN_ROPE_LENGTH)
				{
					velocity.x -= Math.sin(ropeAngle) * ROPE_SHORTEN_SPEED;
					velocity.y -= Math.cos(ropeAngle) * ROPE_SHORTEN_SPEED;
					
				}
				else if (FlxG.keys.pressed("S") && ropeLength < Registry.hookshot.MAX_ROPE_LENGTH - 50) // just to make sure it doesnt actually hit it
				{
					velocity.x += Math.sin(ropeAngle) * ROPE_SHORTEN_SPEED;
					velocity.y += Math.cos(ropeAngle) * ROPE_SHORTEN_SPEED;
				}
				
				/* if click the mouse, then drop back to the ground */
				if (FlxG.mouse.pressed())
				{
					Registry.hookshot.remove();
					setMode(HOOKSHOT_FLY);
				}
				
				/* if you hit the floor or a wall, stop hookshotting and just drop to the ground */
				if (isTouching(FlxObject.FLOOR) || isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT))
				{
					Registry.hookshot.remove();
					setMode(IN_AIR);
				}
			}
			/* released the hookshot, amplify the horizontal and vertical motion so that it feels better */
			else if (mode == HOOKSHOT_FLY)
			{	
				/* allow very limited air control */
				if (FlxG.keys.pressed("A"))
				{
					acceleration.x = -HOOKSHOT_FLY_ACCELERATION;
				}
				else if (FlxG.keys.pressed("D"))
				{
					acceleration.x = HOOKSHOT_FLY_ACCELERATION;
				}
				
				/* go back to normal mode on ground */
				if (isTouching(FlxObject.FLOOR))
				{
					setMode(NORMAL);
				}
			}
			/* just in air after stepping off a platform or something */
			else if (mode == IN_AIR)
			{
				/* TODO: allow some control of air movement, maybe? */
				
				/* go back to normal mode on ground */
				if (isTouching(FlxObject.FLOOR))
				{
					setMode(NORMAL);
				}
			}
			/* preparing to throw a bomb in normal mode */
			else if (mode == PREPARE_BOMB_NORMAL)
			{
				if (!prepareBombTimer.isRunning)
				{
					Registry.smokeBombHandler.fire(x, y, tempAngle);
					setMode(NORMAL);
				}
			}
			/*preparing to throw a bomb in sneaking mode */
			else if (mode == PREPARE_BOMB_SNEAKING)
			{
				if (!prepareBombTimer.isRunning)
				{
					Registry.smokeBombHandler.fire(x, y, tempAngle);
					setMode(SNEAKING);
				}
			}
			/* aiming in normal mode */
			else if (mode == AIMING_NORMAL)
			{
				/* make a red line follow the mouse around */
				Registry.uiHandler.showAimline(firePoint.x, firePoint.y);
				
				/* on mouse release, actually fire the bullet and return to normal mode */
				if (!FlxG.mouse.pressed())
				{
					useWeapon();
					Registry.uiHandler.hideAimline();
					
					if (weapon == TRANQ)
					{
						setMode(RELOADING_NORMAL);
					}
					else if (weapon == HOOKSHOT)
					{
						setMode(HOOKSHOT_RELOADING_NORMAL);
					}
				}
			}
			/* aiming in sneaking mode */
			else if (mode == AIMING_SNEAKING)
			{
				/* make a red line follow the mouse around */
				Registry.uiHandler.showAimline(firePoint.x, firePoint.y);
				
				/* on mouse release, actually fire the bullet and return to sneaking mode */
				if (!FlxG.mouse.pressed())
				{
					useWeapon();
					Registry.uiHandler.hideAimline();
					
					if (weapon == TRANQ)
					{
						setMode(RELOADING_SNEAKING);
					}
					else if (weapon == HOOKSHOT)
					{
						setMode(HOOKSHOT_RELOADING_SNEAKING);
					}
				}
				
			}
			/* reloading the hookshot in normal mode after missing */
			else if (mode == HOOKSHOT_RELOADING_NORMAL)
			{
				/* go back to normal mode after finished reloading */
				if (!hookshotReloadTimer.isRunning)
				{
					setMode(NORMAL);
				}
			}
			/* reloading the hookshot in sneaking mode after missing */
			else if (mode == HOOKSHOT_RELOADING_SNEAKING)
			{
				/* go back to normal mode after finished reloading */
				if (!hookshotReloadTimer.isRunning)
				{
					setMode(SNEAKING);
				}
			}
			
			/* make the noise radius follow the player */
			noiseRadius.follow(this);
			
			/* move the firepoint to the right place */
			firePoint.x = x + width / 2;
			firePoint.y = y + height / 2;
			
			/* TEMP: switching weapons, maybe need a delay later? */
			if (FlxG.keys.pressed("ONE"))
			{
				weapon = TRANQ;
			}
			else if (FlxG.keys.pressed("TWO"))
			{
				weapon = HOOKSHOT;
			}
			else if (FlxG.keys.pressed("THREE"))
			{
				weapon = SMOKEBOMB;
			}
			
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
					frame = 0; // TEMPORARY
					maxVelocity.x = MAX_RUNNING_VELOCITY_X;
					acceleration.y = GRAVITY;
					drag.x = FRICTION;
					break;
					
				case SNEAKING:
					mode = SNEAKING;
					frame = 1; // TEMPORARY
					noiseRadius.off();
					maxVelocity.x = MAX_SNEAKING_VELOCITY_X;
					acceleration.y = GRAVITY;
					break;
				
				case RELOADING_NORMAL:
					mode = RELOADING_NORMAL;
					noiseRadius.off();
					velocity.x = 0;
					acceleration.x = 0;
					reloadTimer.start();
					break;
					
				case RELOADING_SNEAKING:
					mode = RELOADING_SNEAKING;
					noiseRadius.off();
					velocity.x = 0;
					acceleration.x = 0;
					reloadTimer.start();
					break;
					
				case LADDER:
					mode = LADDER;
					noiseRadius.off();
					stopAllMovement();
					break;
					
				case REACHING_LADDER_TOP:
					mode = REACHING_LADDER_TOP;
					noiseRadius.on();
					tempPoint.x = x;
					tempPoint.y = y - 60;
					
					/* booleans */
					doneClimbingUpLadder = true;
					break;
					
				case PREPARE_LADDER:
					mode = PREPARE_LADDER;
					noiseRadius.on();
					stopAllMovement();
					break;
					
				case INITIAL_LADDER_ASCENT:
					mode = INITIAL_LADDER_ASCENT;
					noiseRadius.on();
					tempPoint.x = x;
					tempPoint.y = y - 10;
					
					/* booleans */
					isClimbingUpLadder = true;
					break;
					
				case INITIAL_LADDER_DESCENT:
					mode = INITIAL_LADDER_DESCENT;
					noiseRadius.on();
					tempPoint.x = x;
					tempPoint.y = y + 70;
					
					/* booleans */
					isClimbingDownLadder = true;
					break;
					
				case HOOKSHOT_PULLING:
					stopAllMovement();
					mode = HOOKSHOT_PULLING;
					noiseRadius.off();
					break;
					
				case HOOKSHOT_DANGLING:
					mode = HOOKSHOT_DANGLING;
					
					/* smoothly convert the existing velocity to the swing velocity */
					swingAngularVelocity = velocity.x * SWING_CONVERSION;
					stopAllMovement();
					noiseRadius.off();
					break;
					
				case HOOKSHOT_FLY:
					mode = HOOKSHOT_FLY;
					drag.x = 0;
					
					/* amplify the velocity off the swing so it feels better, but don't amplify the downwards velocity */
					velocity.x = velocity.x * HOOKSHOT_FLY_VELOCITY_MULTIPLIER;
					if (velocity.y < 0)
					{
						velocity.y = velocity.y * HOOKSHOT_FLY_VELOCITY_MULTIPLIER; 
					}
					acceleration.y = HOOKSHOT_FLY_GRAVITY;
					noiseRadius.off();
					break;
					
				case IN_AIR:
					mode = IN_AIR;
					drag.x = 0;
					acceleration.x = 0;
					velocity.x = 0;
					acceleration.y = GRAVITY;
					noiseRadius.off();
					break;
					
				case PREPARE_BOMB_NORMAL:
					mode  = PREPARE_BOMB_NORMAL;
					stopAllMovement();
					noiseRadius.off();
					break;
					
				case PREPARE_BOMB_SNEAKING:
					mode = PREPARE_BOMB_NORMAL;
					stopAllMovement();
					noiseRadius.off();
					break;
					
				case AIMING_NORMAL:
					mode = AIMING_NORMAL;
					stopAllMovement();
					noiseRadius.off();
					break;
					
				case AIMING_SNEAKING:
					mode = AIMING_SNEAKING;
					stopAllMovement();
					noiseRadius.off();
					break;
					
				case HOOKSHOT_RELOADING_NORMAL:
					mode = HOOKSHOT_RELOADING_NORMAL;
					velocity.x = 0;
					acceleration.x = 0;
					noiseRadius.off();
					hookshotReloadTimer.start();
					break;
					
				case HOOKSHOT_RELOADING_SNEAKING:
					mode = HOOKSHOT_RELOADING_SNEAKING;
					velocity.x = 0;
					acceleration.x = 0;
					noiseRadius.off();
					hookshotReloadTimer.start();
					break;
					
				default:
					trace("ERROR: invalid mode");
					break;
			}
		}
		
		/* simply zeroes out all the acceleration and velocity values */
		private function stopAllMovement():void
		{
			velocity.x = 0;
			velocity.y = 0;
			acceleration.x = 0;
			acceleration.y = 0;
		}
		
		/* use the currently equipped weapon */
		private function useWeapon():void
		{
			switch (weapon)
			{
				case TRANQ:
					/* fire a tranq bullet aimed at the mouse */
					Registry.tranqBulletHandler.fire(firePoint.x, firePoint.y, FlxVelocity.angleBetweenMouse(firePoint, false));
					
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
					Registry.hookshot.fire(firePoint.x, firePoint.y, FlxVelocity.angleBetweenMouse(firePoint, false));
					break;
					
				case SMOKEBOMB:
					prepareBombTimer.start();
					if (mode == NORMAL)
					{
						setMode(PREPARE_BOMB_NORMAL);
					}
					else if (mode == SNEAKING)
					{
						setMode(PREPARE_BOMB_SNEAKING);
					}
					
					tempAngle = FlxVelocity.angleBetweenMouse(this, false);
					
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
			if ((mode == NORMAL || mode == SNEAKING) && FlxG.keys.justPressed("W"))
			{
				setMode(PREPARE_LADDER);
				tempMarker = marker;
			}
			/* if S pressed end ladder mode */
			else if (mode == LADDER && FlxG.keys.pressed("S"))
			{
				isClimbingUpLadder = false;
				isClimbingDownLadder = false;
				doneClimbingDownLadder = true; // wow this is messy
				setMode(NORMAL);
			}	
		}
		
		/* handle the event when overlapping with a ladder top */
		public function handleLadderTop(player:Player, marker:Marker):void
		{
			/* if S pressed start ladder mode */
			if ((mode == NORMAL || mode == SNEAKING) && FlxG.keys.justPressed("S"))
			{
				setMode(PREPARE_LADDER);
				tempMarker = marker;
			}
			/* if W pressed end ladder mode */
			else if (mode == LADDER && FlxG.keys.pressed("W") && mode == LADDER)
			{
				isClimbingUpLadder = false;
				isClimbingDownLadder = false;
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