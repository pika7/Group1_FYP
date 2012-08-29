/*  Guard Class
 *  Will be integrated into GuardGroup later
 */

package actors.enemy 
{
	import actors.NoiseRadius;
	import actors.Player;
	import flash.display.Shape;
	import objs.Marker;
	import util.Registry;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import actors.enemy.guardBullet;
	import actors.enemy.invisibleNoiseTile;

	public class Guard extends Enemy
	{
		[Embed(source = '../../../assets/img/enemies/guard.png')] private var guardPNG:Class;
		
		/* initialization of variables */
		private const GRAVITY:int = 600;
		private const levelZeroVelocity:Number = 100;
		private const levelOneVelocity:Number = 200;
		private const levelTwoVelocity:Number = 300;
		
		private var xVelocity:Number;
		private var bullet:FlxSprite;
		private var currentBullet:FlxSprite;
		private var bulletDelay:FlxDelay = new FlxDelay(1500);
		private var shootingNow:Boolean = false;
		private var lastLocation:FlxPoint = new FlxPoint(0, 0);
		private var stoppingNow:Boolean = false;
		private var sightRangeGraphic:FlxSprite;
		private var climbing:Boolean = false;
		private var canClimb:Boolean = false;
		private var finishedClimbing:Boolean = false;
		private var bulletCounter:Number = 0;
		private var noiseCounter:Number = 0;
		private var climbLadderPatrol:Boolean = false; 
		private var noisePoint:FlxPoint = new FlxPoint;
		private var noiseDetected:Boolean = false;
		private var noiseTile:FlxSprite;
		
		/* constructor */
		public function Guard(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(guardPNG, true, true, 128, 128, true);
			width = 128;
			height = 128;
			
			/* sprite speed initialization*/
			acceleration.y = GRAVITY;
			velocity.x = levelZeroVelocity;
			
			/* sprite animations */
			addAnimation("walk", [0], 0, false);
			addAnimation("shoot", [1], 0, false);
			addAnimation("alert", [2], 0, false);
			
			/*other sprite properties*/
			facing = RIGHT;	
			initializeBullets();
			
			/* set the initial mode */
			Mode = "Normal";
 		}
		
		/*play alert animation if noise is detected */
		override public function noiseAlert(enemy:Enemy, noise:NoiseRadius):void
		{
			play("alert");
			noisePoint.x = Registry.player.x;
			noisePoint.y = Registry.player.y;
			noiseDetected = true;
			Mode = "NoiseFollowing";
			noiseTile = new invisibleNoiseTile(noisePoint.x, noisePoint.y);
			noiseTile.exists = true;	
			
			if (climbing == false) //prevents guards from floating towards player
			{
				FlxVelocity.moveTowardsPoint(this, noisePoint, xVelocity);	
				velocity.y = 0;
			}
			if (noisePoint.x > x)
			{
				facing = RIGHT;
			}
			else
			{
				facing = LEFT;
			}
			if ((noisePoint.y < y || noisePoint.y > y) && (climbing ==false)) //player is above the guard
			{
				canClimb = true;
			}
		}
		
		/*check if the noise is detected*/
		public function checkNoiseDetected(guard:Guard, noiseTile:invisibleNoiseTile):void
		{
			if (noiseDetected == true && Mode=="NoiseFollowing")
			{	
				velocity.x = 0;
				noiseCounter += FlxG.elapsed;
				if (noiseCounter > 3)
				{
					noiseTile.exists = false;
					noiseCounter = 0;
					Mode = "Normal";
					play("walk");
				}
			}	
		}
		
		
		/* changes velocity according to alertLevel*/
		private function setVelocity():void
		{
			switch(alertLevel)
			{
				case 0:
					xVelocity = levelZeroVelocity;
					break;
				case 1:
					xVelocity = levelOneVelocity;
					break;
				case 2:
					xVelocity = levelTwoVelocity;
					break;
			}
		}	
		
		
		/* creation of bullets for use */
		private function initializeBullets():void
		{
			for (var i:int = 0; i < 10; i++)
			{
				bullet = new guardBullet;
				bullet.exists = false;	
				Registry.bulletGroup.add(bullet);
			}
		}		
		
		/* check if the player is in sight range */
		public function checkIsDetected():void
		{
			/*if ((climbing == false) && (Mode=="Normal") && (detected==true))
			{
				Mode = "Following";
			}		*/	
			if (detected==true && (alertLevel==2))
			{
				shootPlayer();
				Mode = "Shooting";
			}
			
		}		
		
		
		/* function for checking if the guard is currently climibing or not */
		public function onLadder():Boolean
		{
			return climbing;
		}
		
		/* Allows guard to climb the ladder when reached the bottom */
		public function handleLadderBottom(guard:Guard, marker:Marker):void
		{
			tempMarker = marker;
			if ((Mode == "Following"||Mode=="NoiseFollowing"))
			{	
				if (canClimb == true && (climbing == false))
				{
					if ((Registry.noiseTile.y < y)||(Registry.player.doneClimbingUpLadder ==true))
					{
						climbing = true;
						x = tempMarker.x-50;
						velocity.x = 0;
						velocity. y = - 10;		
						acceleration.y = 0;
					}
				}
			}
		}
		/* Allows guard to stop climbing the ladder when reached the top */
		public function handleLadderTop(guard:Guard, marker:Marker):void
		{
			tempMarker = marker;
			if((climbing==true && y < (tempMarker.y-(2*tempMarker.width))))
			{
				climbing = false;
				velocity.x = xVelocity;
				acceleration.y = GRAVITY;
			}
		
		}
		
		/*shooting function */
		private function shootPlayer():void
		{				
			if (Mode=="Shooting" && shootingNow==false)
			{
				velocity.x = 0;
				tempVelocity = velocity.x;
				currentBullet = Registry.bulletGroup.getFirstAvailable() as FlxSprite;	
				play("shoot");			
				shootingNow = true;
				currentBullet.x = x + 100;
				currentBullet.y = y + 50;
				currentBullet.exists = true;
				FlxVelocity.moveTowardsObject(currentBullet, Registry.player, 200);	
				
			}   
		}		
		
		/*check bullet counter */
		public function bulletCounterCheck():void
		{
			if (shootingNow == true)
			{
				bulletCounter += FlxG.elapsed;
			
				if (bulletCounter > 3)
				{
					shootingNow = false;
					Mode = "Normal";
					bulletCounter = 0;
					detected = false;
				}
			}
		}
		
		/* update function */
		override public function update():void
		{	
			setVelocity();	
			turnAround(xVelocity);
			checkIsDetected(); //check for detection
			changeAlertLevel(); //change alertlevel depending on the condition	
			bulletCounterCheck();
			super.update();
		}
		
	
	}

}