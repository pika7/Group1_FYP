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
		
		private var group:FlxGroup;
		protected var alertLevel:Number = 0; //alertLevel of each enemy (dog/guard etc)
		private var stopDelay:FlxDelay = new FlxDelay(4000);
		protected var tempVelocity:Number = 0;
		protected var detected:Boolean = false;
		protected var touched:Boolean = false;
		protected var canSee:Boolean = false;
		protected var tempMarker:Marker;
		private var touchedMarker:Boolean = false;
		
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
			if (facing == FlxObject.RIGHT && justTouched(RIGHT))
			{	
				velocity.x = 0;
				facing = FlxObject.LEFT;
				stopDelay.start();
				touchedMarker = false;
				
			}
			if (facing == FlxObject.LEFT && justTouched(LEFT))
			{				
				velocity.x = 0;
				facing = FlxObject.RIGHT;	
				stopDelay.start();
				touchedMarker = false;
			}
		}
		
		/*go back to patrol after stopping for a while*/
		public function backToPatrol():void
		{
			if (stopDelay.hasExpired==true)
			{
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
			if (touchedMarker==false)
			{
				velocity.x = 0;
				touchedMarker = true;
				stopDelay.start();
			}
		}
		
		/* guard sees player if in sight range */
		public function seePlayer(sightrange:sightRanges, player:Player):void
		{
			if (FlxCollision.pixelPerfectCheck(sightrange, player))	
			{
				detected = true;
				canSee = true;
			}
		}
		
		/*check if guard can see player */
		protected function canSeeCheck():void
		{
			if (canSee == true)
			{
				followPlayer();
			}
		}
		
		/* follows the player as long as she is in sight range */
		protected function followPlayer():void
		{
			if (Registry.player.x < x)
			{
				facing = LEFT;
				velocity.x = -10;
			}
			else if (Registry.player.x > x)
			{
				facing = RIGHT;
				velocity.x = 10;
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
				setAlertLevel(1);
				
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