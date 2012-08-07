package actors.enemy 
{
	import org.flixel.*;

	public class Guard extends Enemy
	{
		[Embed(source = '../../../assets/img/player/test_player.png')] private var guardPNG:Class;
		
		private const GRAVITY:int = 600;
		private const xVelocity:Number = 200;
		private const alertLevel:Number;
		
		public function Guard(X:int, Y:int) 
		{
			
			super(X, Y);
			loadGraphic(guardPNG, true, true, 64, 64, true);
			width = 64;
			height = 64;
			acceleration.y = GRAVITY;
			velocity.x = xVelocity;
			facing = RIGHT;			
		}
		
		override public function update():void
		{
				boundaryCheck(xVelocity);
				super.update();
		}
		
		public function shootPlayer():void
		{
			
			
			
		}
		
		public function followPlayer():void
		{
			
			
		}
		
		public function moveToLastLocation():void
		{
			
			
		}

	

	
		
	
		
	}

}