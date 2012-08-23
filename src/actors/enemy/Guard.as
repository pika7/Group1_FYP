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
		private const xVelocity:Number = 100;
		private var bullet:FlxSprite;
		private var currentBullet:FlxSprite;
		private var bulletDelay:FlxDelay = new FlxDelay(2000);
		private var shootingNow:Boolean = false;
		private var lastLocation:FlxPoint = new FlxPoint(0, 0);
		private var stoppingNow:Boolean = false;
		private var sightRangeGraphic:FlxSprite;
		
		
		
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
			
			/*other sprite properties*/
			facing = RIGHT;	
			alertLevel = 0;
			initializeBullets();
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
		
		/* update function */
		override public function update():void
		{					
			checkIsDetected();
			turnAround(xVelocity); //turn around when you hit the wall
			
			if (bulletDelay.hasExpired == true)
			{
				velocity.x = -200;
				facing = LEFT;
				shootingNow = false;
				detected = false;
			}			
			super.update();
		}
		
		
		/* check if the player is in sight range */
		public function checkIsDetected():void
		{
			if ((detected == true) && (shootingNow==false))
			{
				shootPlayer();
			}		
		}
		
		/*shooting function */
		private function shootPlayer():void
		{				
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
				velocity.x = 0;
				bulletDelay.start();
			}   
		}		
		
	
	}

}