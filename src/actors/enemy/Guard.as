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

	public class Guard extends Enemy
	{
		[Embed(source = '../../../assets/img/enemies/guard.png')] private var guardPNG:Class;
		
		/* initialization of variables */
		private const GRAVITY:int = 600;
		private var xVelocity:Number = 100;
		private var bullet:FlxSprite;
		private var currentBullet:FlxSprite;
		private var bulletDelay:FlxDelay = new FlxDelay(1500);
		private var shootingNow:Boolean = false;
		private var lastLocation:FlxPoint = new FlxPoint(0, 0);
		private var stoppingNow:Boolean = false;
		private var sightRangeGraphic:FlxSprite;
		private var climbing:Boolean = false;
		private var finishedClimbing:Boolean = false;
		
		
		/* constructor */
		public function Guard(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(guardPNG, true, true, 128, 128, true);
			width = 128;
			height = 128;
			
			/* sprite speed initialization*/
			acceleration.y = GRAVITY;
			velocity.x = xVelocity;
			
			/* sprite animations */
			addAnimation("walk", [0], 0, false);
			addAnimation("shoot", [1], 0, false);
			addAnimation("alert", [2], 0, false);
			
			/*other sprite properties*/
			facing = RIGHT;	
			alertLevel = 0;
			initializeBullets();
			setAlertLevel(2);
 		}
		
		public function onLadder():Boolean
		{
			return climbing;
		}
		
		/*play alert animation if noise is detected */
		override public function noiseAlert(enemy:Enemy, noise:NoiseRadius):void
		{
			play("alert");
			
		}
		
		
		/* changes velocity according to alertLevel*/
		private function setVelocity():void
		{
			switch(getAlertLevel())
			{
		
				
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
			if ((detected == true) && (shootingNow==false))
			{
				if (climbing == false)
				{
					followPlayer();
				}				
				if (getAlertLevel() == 2)
				{
					shootPlayer();
				}
			}		
		}		
		
		/* Allows guard to climb the ladder when reached the bottom */
		public function handleLadderBottom(guard:Guard, marker:Marker):void
		{
			tempMarker = marker;
			if ((detected == true) && (Registry.player.y < y) && (finishedClimbing==false)) //player is above guard
			{
				climbing = true;
				x = tempMarker.x - 40;
				velocity.y = -50;
				velocity.x = 0;
				acceleration.y = 0;
			}
		}
		
		/* Allows guard to stop climbing the ladder when reached the top */
		public function handleLadderTop(guard:Guard, marker:Marker):void
		{
			tempMarker = marker;
			if ((detected == true) && (Registry.player.y > y) && (finishedClimbing == false)) //when the player is below guard, stop climbing action
			{
				climbing = false;
				velocity.y = 0;
				velocity.x = 0;
				acceleration.y = GRAVITY;
				finishedClimbing = true; //reached the top
			}
			if ((detected == true) && (Registry.player.y > y)) 
			{
				climbing = true;	
				velocity.y = 50;
				velocity.x = 0;
				acceleration.y = 0;
			}
		}
		
		/* override canSeeCheck since guard shouldn't follow when climbing */
		override protected function canSeeCheck():void
		{
			if ((canSee == true) && (climbing == false))
			{
				if (alertLevel == 2)
				{
					followPlayer();	
				}
			}
		}
		
		/*shooting function */
		private function shootPlayer():void
		{				
			if (shootingNow == false)
			{
				velocity.x = 0;
				tempVelocity = velocity.x;
				currentBullet = Registry.bulletGroup.getFirstAvailable() as FlxSprite;	
				play("shoot");			
				currentBullet.x = x + 100;
				currentBullet.y = y + 50;
				currentBullet.exists = true;
				FlxVelocity.moveTowardsObject(currentBullet, Registry.player, 200);	
				shootingNow = true;	
				bulletDelay.start();
			}   
		}		
		
		/* update function */
		override public function update():void
		{					
			checkIsDetected(); //check for detection
			changeAlertLevel(); //change alertlevel depending on the condition
			turnAround(xVelocity); //turn around when you hit the wall	
			
			if (bulletDelay.hasExpired == true)
			{
				shootingNow = false;
			}
			
			super.update();
		}
		
	
	}

}