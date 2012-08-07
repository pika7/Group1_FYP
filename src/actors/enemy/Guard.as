package actors.enemy 
{
	import flash.display.Sprite;
	import flash.sampler.NewObjectSample;
	import util.Registry;
	import org.flixel.*;

	public class Guard extends Enemy
	{
		[Embed(source = '../../../assets/img/player/test_player.png')] private var guardPNG:Class;
		[Embed(source = '../../../assets/img/bullets/scentBomb.png')] private var bulletPNG:Class;
		
		private const GRAVITY:int = 600;
		private const xVelocity:Number = 200;
		private var alertLevel:Number;
		private var bullet:FlxSprite;
		
		
		public function Guard(X:int, Y:int) 
		{
			
			super(X, Y);
			loadGraphic(guardPNG, true, true, 64, 64, true);
			width = 64;
			height = 64;
			acceleration.y = GRAVITY;
			velocity.x = xVelocity;
			facing = RIGHT;			
			bullet = new FlxSprite;
			bullet.loadGraphic(bulletPNG, false, false, 10, 10);
			bullet.exists = false;			
			if (FlxG.state.toString == PlayState)
			{
				FlxG.state.add(bullet);
			}
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
				bullet.reset(x, y);
				bullet.exists = true;
				bullet.velocity.x = -100;
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