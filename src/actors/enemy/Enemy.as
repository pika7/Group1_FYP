package actors.enemy 
{
	import actors.NoiseRadius;
	import actors.Player;
	import objs.Marker;
	import org.flixel.*;
	import util.Registry;
	import org.flixel.plugin.photonstorm.*;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source = '../../../assets/img/bullets/scentBomb.png')] private var bulletPNG:Class;
		
		private var group:FlxGroup;
		protected var alertLevel:Number = 0; //alertLevel of each enemy (dog/guard etc)
		private var wallStopDelay:FlxDelay = new FlxDelay(3000); //stop for 3 seconds	
		private var stopDelay:FlxDelay = new FlxDelay(2000);
		protected var tempVelocity:Number = 0;
		protected var detected:Boolean = false;
		protected var touched:Boolean = false;
		private var markerDelay:FlxDelay = new FlxDelay(2000);
		private var touchedMarker:Boolean = false;

		public function Enemy(X:int, Y:int) 
		{
			super(X, Y);
			group = Registry.enemyGroup;
			group.add(this);
		}
		
		/////////////////////////////////////////////////////////
		// GLOBAL ENEMY BEHAVIOUR
		/////////////////////////////////////////////////////////	
		
		public function turnAround(xVelocity:Number):void
		{	
			if (facing == FlxObject.RIGHT && justTouched(RIGHT))
			{
				facing = FlxObject.LEFT;
				wallStopDelay.start();
				velocity.x = 0;
			}
			if (facing == FlxObject.LEFT && justTouched(LEFT))
			{
				facing = FlxObject.RIGHT;
				wallStopDelay.start();
				velocity.x = 0;
			}
		}
		
		override public function update(): void
		{
			if ((wallStopDelay.hasExpired == true))
			{
				if (facing == FlxObject.LEFT)
				{
					velocity.x = -200;
				}
				if (facing == FlxObject.RIGHT)
				{
					velocity.x = 200;			
				}
			}
			
			if ((stopDelay.hasExpired == true) && (touchedMarker==true))
			{
				if (facing == RIGHT)
				{
					velocity.x = 200;
					untouchedMarker();
				}
				else
				{
					velocity.x = -200;		
					untouchedMarker();
				}
			}
			
		}
		
		public function untouchedMarker():void
		{
			markerDelay.start();			
		}
		
		/* stops enemy if makes contact with a marker */
		public function handleEnemyStop(enemy:Enemy, marker:Marker):void
		{	
			if (touchedMarker==false)
			{
				velocity.x = 0;
				touchedMarker = true;
				stopDelay.start();
			}
		}
		
		public function followPlayer(sightrange:sightRanges, player:Player):void
		{
			if (FlxCollision.pixelPerfectCheck(sightrange, player))	
			{
				trace("detected");
				detected = true;
			}
		}
		
		
		/*guard responds to the noise*/
		public function noiseAlert(enemy:Enemy, noise:NoiseRadius):void
		{
			//velocity.x = 0;
			//go to the source of noise
		}
		
		/////////////////////////////////////////////////////////
		// GETTERS/SETTERS
		/////////////////////////////////////////////////////////
		
		public function getAlertLevel():Number
		{
			return alertLevel;
		}
		
		public function setAlertLevel(alert:Number):void
		{
			alertLevel = alert;
		}
	}

}