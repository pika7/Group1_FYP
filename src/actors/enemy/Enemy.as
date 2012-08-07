package actors.enemy 
{
	import org.flixel.*;
	import util.Registry;
	/**
	 * ...
	 * @author 
	 */
	public class Enemy extends FlxSprite
	{
		private var group:FlxGroup;
		private var alertLevel:Number;
		
		
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
				if (x < 0 || x > FlxG.worldBounds.width - width|| justTouched(RIGHT) || justTouched(LEFT))
				{
					turnAround(xVelocity);
				}
			
		}		
		
		
		public function turnAround(xVelocity:Number):void
		{
			if (facing == RIGHT)
			{	
				facing = LEFT;
				velocity.x = - xVelocity;
				
			}
			else
			{
				facing = RIGHT;
				velocity.x =  xVelocity;
			}
			
		}
		
		//detect player based on the sight /noise range (based on pixel numbers)) and returns boolean value
		
		public function detectPlayer(sightRange:Number, noiseRange:Number):Boolean
		{
			return false;
		
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