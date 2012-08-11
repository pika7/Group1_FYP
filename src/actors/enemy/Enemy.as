package actors.enemy 
{
	import actors.Player;
	import org.flixel.*;
	import util.Registry;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author 
	 */
	public class Enemy extends FlxSprite
	{
		[Embed(source = '../../../assets/img/bullets/scentBomb.png')] private var bulletPNG:Class;
		
		private var group:FlxGroup;
		protected var alertLevel:Number=0; //alertLevel of each enemy (dog/guard etc)
		private var stopDelay:FlxDelay = new FlxDelay(3000); //stop for 3 seconds		
		protected var tempVelocity:Number = 0;
		
		public function Enemy(X:int, Y:int) 
		{
			super(X, Y);
			group = Registry.enemyGroup;
			group.add(this);
		}
		
		/////////////////////////////////////////////////////////
		// GLOBAL ENEMY BEHAVIOUR
		/////////////////////////////////////////////////////////
		public function boundaryCheck(xVelocity:Number):void
		{
			if (x < 0 || x > FlxG.worldBounds.width - width|| justTouched(RIGHT)||justTouched(LEFT))
			{
				turnAround(xVelocity);
			}
		}		
		
		public function turnAround(xVelocity:Number):void
		{
			if (facing == RIGHT)
			{	
				facing = LEFT;
				velocity.x = -xVelocity;
			}
			else
			{
				facing = RIGHT;
				velocity.x = xVelocity;
			}	
		}
	
		
		
	
		public function followPlayer(sightrange:sightRange, player:Player):void
		{
			if (FlxCollision.pixelPerfectCheck(sightrange, player))	
			{
				if (facing == RIGHT)
				{
					velocity.x = 200;
				}
				else if (facing == LEFT)
				{
				
					velocity.x = -200;
				}						
			}
		}

		/////////////////////////////////////////////////////////
		// GETTERS/SETTERS
		/////////////////////////////////////////////////////////
		public function getAlertLevel():Number
		{
			return alertLevel;
		}
		
		public function setAlertLevel(alert:Number)
		{
			alertLevel = alert;
		}
	}

}