package actors.enemy 
{
	import actors.NoiseRadius;
	import actors.Player;
	import objs.Marker;
	import org.flixel.*;
	import util.Registry;
	import org.flixel.plugin.photonstorm.*;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source = '../../../assets/img/bullets/scentBomb.png')] private var bulletPNG:Class;
		
		protected var alertLevel:Number = 0; //alertLevel of each enemy (dog/guard etc)
		protected var stopDelay:FlxDelay = new FlxDelay(2000);
		protected var tempVelocity:Number = 0;
		protected var detected:Boolean = false;
		protected var touched:Boolean = false;
		protected var canSee:Boolean = false;
		protected var tempMarker:Marker;
		protected var Mode:String = "Normal";
		private var touchedMarker:Boolean = false;
		private var group:FlxGroup;
		private var counter:Number = 0;
		private var pixelCounter:Number = 0;

		public function Enemy(X:int, Y:int) 
		{
			super(X, Y);
			group = Registry.enemyGroup;
			group.add(this);
		}
		
		/////////////////////////////////////////////////////////
		// GLOBAL ENEMY BEHAVIOUR
		/////////////////////////////////////////////////////////	
		
		/* uses the passed velocity parameter to turn around*/
		public function turnAround(xVelocity:Number):void
		{	
			tempVelocity = xVelocity;
			if (Mode == "Normal")
			{
				if (facing == FlxObject.RIGHT && justTouched(RIGHT))
				{	
					velocity.x = 0;
					facing = FlxObject.LEFT;
					stopDelay.start();				
				}
				if (facing == FlxObject.LEFT && justTouched(LEFT))
				{				
					velocity.x = 0;
					facing = FlxObject.RIGHT;	
					stopDelay.start();				
				}
			}
			else if (Mode == "Following" || Mode=="NoiseFollowing")
			{
				if (facing == FlxObject.RIGHT && justTouched(RIGHT))
				{	
					facing = FlxObject.LEFT;
					velocity.x = -tempVelocity;		
				}
				if (facing == FlxObject.LEFT && justTouched(LEFT))
				{				
					facing = FlxObject.RIGHT;	
					velocity.x = tempVelocity;		
				}
				
			}
		}
		
		/*go back to patrol after stopping for a while*/
		public function backToPatrol():void
		{
			if (stopDelay.hasExpired == true && Mode=="Normal")
			{
				counter += FlxG.elapsed;
				if (counter > 3)
				{
					touchedMarker = false;
					counter = 0;
				}
				if (facing == LEFT)
				{
					velocity.x = -tempVelocity;
				}
				if (facing == RIGHT)
				{
					velocity.x = tempVelocity;
				}
			}
		}
		
		/* stops enemy if makes contact with a marker */
		public function handleEnemyStop(enemy:Enemy, marker:Marker):void
		{	
			if (touchedMarker==false && Mode == "Normal") //only stop at the marker in Normal mode
			{
				velocity.x = 0;
				touchedMarker = true;
				stopDelay.start();
			}
			
		}
						
		/* guard sees player if in sight range */
		public function seePlayer(sightrange:sightRanges, player:Player):void
		{
			pixelCounter += FlxG.elapsed;
			if (pixelCounter > 0.5) //check it every 0.5 frame
			{
				if (FlxCollision.pixelPerfectCheck(sightrange, player))	
				{
					detected = true;
					canSee = true;
					pixelCounter = 0;
				}
				else
				{
					
				}
			}	
		}
		
		
		/*check if guard can see player */
		protected function canSeeCheck():void
		{
		/*	if (detected == true) //player is in the sight range
			{
				Mode = "Following";
				followPlayer();
			}*/
		}
					
		/* follows the player as long as she is in sight range */
		protected function followPlayer():void
		{
			if (Registry.player.x < x)
			{
				facing = LEFT;
				velocity.x = -tempVelocity;
			}
			else if (Registry.player.x > x)
			{
				facing = RIGHT;
				velocity.x = tempVelocity;
			}
	
		}
		
		/*guard responds to the noise*/
		public function noiseAlert(enemy:Enemy, noise:NoiseRadius):void
		{
			//velocity.x = 0;
			//go to the source of noise
		}
		
		/*chagnes alert level of the enemy according to situation */
		public function changeAlertLevel():void
		{
			if (detected == true && (Registry.player.gotGoalItem==false))
			{
				setAlertLevel(0);
				
			}
			/*if (Registry.player.gotGoalItem == true)
			{
				setAlertLevel(2);
			}*/
		}
		
		/* update function for generic enemy class */
		override public function update(): void
		{	
			backToPatrol();					
			canSeeCheck();
		}
		
		/////////////////////////////////////////////////////////
		// GETTERS/SETTERS
		/////////////////////////////////////////////////////////
		
		public function getAlertLevel():Number
		{
			return alertLevel;
		}
		
		public function setAlertLevel(alert:Number):void
		{
			alertLevel = alert;
		}
	}

}