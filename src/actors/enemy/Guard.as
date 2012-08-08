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
		private const xVelocity:Number = 200;
		private var alertLevel:Number;
		private var bullet:FlxSprite;
		private var currentBullet:FlxSprite;
		private var bulletDelay:FlxDelay;
		private var tempVelocity:Number = 0;
		private var detected:Boolean = false;

		
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
			initializeBullets();
		
 		}
		
		override public function update():void
		{
				boundaryCheck(xVelocity);		
				shootPlayer();
				detected = detectPlayer(0, 0);
				super.update();
				
				
		}
		
		private function initializeBullets():void
		{
			for (var i:int = 0; i < 3; i++)
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
			
			if (isTouching(RIGHT))
			{
				play("shoot");
				tempVelocity = velocity.x;
			//	velocity.x = 0;
				currentBullet.x = x;
				currentBullet.y = y;
				currentBullet.exists = true;
				currentBullet.velocity.x = -70;
			}
			else
			{
				
				
				
			}
		}
		
		public function followPlayer():void
		{
			
			
		}
		
		public function moveToLastLocation():void
		{
			
			
		}

	

	
		
	
		
	}

}