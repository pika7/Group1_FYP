package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import util.Registry;
	import levels.Level;
	import objs.Marker;
	
	public class Hookshot extends FireableWeapon
	{
		[Embed(source = '../../assets/img/player/weapons/hookshot.png')] private var hookshotPNG:Class;
		
		/* this sprite is used to draw the rope between the hook and the player */
		public var rope:FlxSprite;
		
		/* this is only called in the beginning somewhere. */
		public function Hookshot() 
		{
			super();
			loadGraphic(hookshotPNG, true, true, 16, 16, true);
			shotVelocity = 900;
			
			/* the rope graphic is an invisible sprite that fills the play area */
			rope = new FlxSprite(0, 0);
			rope.makeGraphic(Registry.level.width, Registry.level.height, 0x00000000, false);
		}
		
		override public function update():void
		{	
			/* draw a line between the hook and the player */
			if (exists)
			{
				rope.fill(0x00000000);
				rope.drawLine(Registry.player.x, Registry.player.y, x + width/2, y + height/2, 0xffbb00, 3);
			}
		}
		
		override public function fire(X:int, Y:int, angle:Number):void
		{
			/* make the hookshot point in the right direction */
			this.angle = angle * (180/Math.PI) + 90;
			super.fire(X, Y, angle);
		}
		
		/////////////////////////////////////////////////////
		// PUBLIC CALLBACK FUNCTIONS
		/////////////////////////////////////////////////////
		
		public function stopHookshot(hookshot:Hookshot, hookshotable:Marker):void
		{
			velocity.x = 0;
			velocity.y = 0;
		}
	}

}