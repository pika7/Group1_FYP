package actors.enemy 
{

	import util.Registry;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Guard extends Enemy
	{
		[Embed(source = '../../../assets/img/enemies/guard.png')] private var guardPNG:Class;
		[Embed(source = '../../../assets/img/bullets/scentBomb.png')] private var bulletPNG:Class;
		
		private const GRAVITY:int = 600;
		private const xVelocity:Number = 200;
		private var alertLevel:Number;
		private var bullet:FlxSprite;
		private var currentBullet:FlxSprite;
		private var bulletDelay:FlxDelay;
		
		public function Guard(X:int, Y:int) 
		{
			
			super(X, Y);
			loadGraphic(guardPNG, true, true, 128, 128, true);
			width = 128;
			height = 128;
			acceleration.y = GRAVITY;
			velocity.x = xVelocity;
			facing = RIGHT;			
			
			for (var i:int = 0; i < 3; i++)
			{
				bullet = new FlxSprite;
				bullet.loadGraphic(bulletPNG, false, false, 10, 10);
				bullet.exists = false;	
				Registry.bulletGroup.add(bullet);
			}
			currentBullet = Registry.bulletGroup.recycle() as FlxSprite;
 		}
		
		override public function update():void
		{
				boundaryCheck(xVelocity);
				shootPlayer();
				super.update();
				
		}
		
		public function shootPlayer():void
		{
			if (justTouched(RIGHT))
			{
				
				currentBullet.reset(x, y);
				currentBullet.exists = true;
				currentBullet.velocity.x = -200;
				
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