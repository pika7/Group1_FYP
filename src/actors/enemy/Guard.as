package actors.enemy 
{

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
	
		
		private const GRAVITY:int = 600;
		private const xVelocity:Number = 100;
	
		private var bullet:FlxSprite;
		private var currentBullet:FlxSprite;
		private var bulletDelay:FlxDelay;
		private var stopDelay:FlxDelay;
		private var shootingNow:Boolean = false;
		private var lastLocation:FlxPoint = new FlxPoint(0, 0);
		private var stoppingNow:Boolean = false;
		private var sightRangeGraphic:FlxSprite;
		


		private var touchedMarker:Boolean = false;
		private var alreadyTouchedmarker:Boolean = false;
		
		public function Guard(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(guardPNG, true, true, 128, 128, true);
	
			width = 128;
			height = 128;
			
			addAnimation("walk", [0], 0, false);
			addAnimation("shoot", [1], 0, false);
			acceleration.y = GRAVITY;
			velocity.x = xVelocity;
			facing = RIGHT;			
			bulletDelay = new FlxDelay(2000);
			stopDelay = new FlxDelay(2000);
			alertLevel = 0;
			initializeBullets();
 		}

		override public function update():void
		{
				boundaryCheck(xVelocity);		
				checkIsDetected();
				super.update();
		}
		
		private function initializeBullets():void
		{
			for (var i:int = 0; i < 1000; i++)
			{
				bullet = new guardBullet;
				bullet.exists = false;	
				Registry.bulletGroup.add(bullet);
			}
		}
		
		
		public function handleEnemyStop(guard:Guard, marker:Marker):void
		{	
			stopDelay.start();
			tempVelocity = velocity.x;
			stopDelay.callback = backToPatrol;
		}
				
		private function backToPatrol():void
		{
			
			play("walk");
			shootingNow = false;
			
		}
		
		public function checkIsDetected():void
		{
			if ((detected == true) && (getAlertLevel()==0) && (shootingNow == false))
			{
				shootPlayer();
		
			}
			else if (shootingNow == true)
			{
			
			}			
		}
		
		//shoot the player if detected
		public function shootPlayer():void
		{				
			//start shooting
			if (shootingNow == false)
			{
				tempVelocity = velocity.x;
				currentBullet = Registry.bulletGroup.getFirstAvailable() as FlxSprite;	
				play("shoot");			
				currentBullet.x = x + 100;
				currentBullet.y = y + 50;
				currentBullet.exists = true;
				FlxVelocity.moveTowardsObject(currentBullet, Registry.player, 200);	
				shootingNow = true;
				bulletDelay.start();
				bulletDelay.callback = backToPatrol;
			}   
			else //shootingNow == true
			{
				
			}
		}

		public function moveToLastLocation():void
		{


		}








	}

}