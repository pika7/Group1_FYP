package actors.enemy 
{

	import flash.sampler.NewObjectSample;
	import util.Registry;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import actors.enemy.guardBullet;

	public class Guard extends Enemy
	{
		[Embed(source = '../../../assets/img/enemies/guard.png')] private var guardPNG:Class;
		
		private const GRAVITY:int = 600;
		private const xVelocity:Number = 100;
		private var alertLevel:Number;
		private var bullet:FlxSprite;
		private var currentBullet:FlxSprite;
		private var bulletDelay:FlxDelay;
		private var stopDelay:FlxDelay;
		private var tempVelocity:Number = 0;
		private var detected:Boolean = false;
		private var shootingNow:Boolean = false;
		private var lastLocation:FlxPoint = new FlxPoint(0, 0);
		private var sightRange:Number = 0;
		private var stoppingNow:Boolean = false;
		
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
			stopDelay = new FlxDelay(3000);
			alertLevel = 0;
			initializeBullets();
			
 		}
		
		override public function update():void
		{
				setSightRange(); //sets sight range depending on alertLevel
				boundaryCheck(xVelocity);		
				checkPlayer();
				checkIsTouching();
				detected = detectPlayer(0, 0);
				super.update();
	
		}
		
		private function setSightRange():void
		{
			switch(alertLevel)
			{
				case 0:
					sightRange = 200;
				case 1:
					sightRange = 90;

				case 2:
					sightRange = 80;
				case 3:
					sightRange = 90;
			}
		}
		
		
		private function checkIsTouching():void
		{
			if (justTouched(RIGHT) || justTouched(LEFT))
			{
				stopDelay.start();
				tempVelocity = velocity.x;
				velocity.x = 0;
				stopDelay.callback = backToPatrol;
			}
			
		}
		
		private function backToPatrol():void
		{
			velocity.x = tempVelocity;
			play("walk");
			stoppingNow = false;
			shootingNow = false;
		}
		
		
		private function initializeBullets():void
		{
			for (var i:int = 0; i < 30; i++)
			{
				bullet = new guardBullet;
				bullet.exists = false;	
				Registry.bulletGroup.add(bullet);
			}
		}
		
		
		//shoot the player if detected
		public function shootPlayer():void
		{
			currentBullet = Registry.bulletGroup.recycle() as FlxSprite;	
			play("shoot");
			tempVelocity = velocity.x;
			currentBullet.x = x+100;
			currentBullet.y = y+50;
			currentBullet.exists = true;
			lastLocation.x = Registry.player.x;
			lastLocation.y = Registry.player.y;
			FlxVelocity.moveTowardsObject(currentBullet, Registry.player, 200);
			shootingNow = true;
			
		}
		
		private function checkPlayer():void                  //  player  x-sightrange    x   x+sightrange   player
		{
			if (((((Registry.player.x > x - sightRange)&&(Registry.player.x<x)) && facing == LEFT))||(((Registry.player.x < x + sightRange)&&(Registry.player.x>x)) && facing == RIGHT))  
			{	
				lastLocation.x = Registry.player.x;
				lastLocation.y = Registry.player.y;
				
				if ((shootingNow == false) && (alertLevel == 0)) 
				{
					followPlayer();
				}
				else if((shootingNow == false) && (alertLevel==1))
				{
					shootPlayer();
					
					if (stoppingNow == false) //if the guard hasn't stopped 
					{
						shootingNow = true; //stop for shooting
						tempVelocity = velocity.x;
						velocity.x = 0;
						stopDelay.start(); //stop for 3 seconds
						stopDelay.callback = backToPatrol;
					}
				}	
				else //shooting now == true and the player is in sight
				{
					backToPatrol;
				}
				
			}
			else
			{
				backToPatrol;
			}
		}
		
		
		public function followPlayer():void
		{
			if (((((Registry.player.x > x - sightRange) && (Registry.player.x < x)) && facing == LEFT)) || (((Registry.player.x < x + sightRange)&&(Registry.player.x>x)) && facing == RIGHT))  
			{
				FlxVelocity.moveTowardsObject(this, Registry.player, 200);
			}
			
			
		}
		
		public function moveToLastLocation():void
		{
			
			
		}

	

	
		
	
		
	}

}