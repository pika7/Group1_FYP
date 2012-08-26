package weapons 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import util.Registry;
	import levels.Level;
	import objs.Marker;
	import actors.Player;
	
	public class Hookshot extends FireableWeapon
	{
		[Embed(source = '../../assets/img/player/weapons/hookshot.png')] private var hookshotPNG:Class;
		
		public const MAX_ROPE_LENGTH:int = 350;
		public const MIN_ROPE_LENGTH:int = 100;
		public var isHooking:Boolean = false;
		
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
			/* TODO: find a better alternative, this is VERY processor intensive */
			if (exists)
			{
				Registry.hookshotChain.drawChain(Registry.player.firePoint.x, Registry.player.firePoint.y, x + width / 2, y + height / 2);
			}
			
			/* if the hookshot gets too far away from the player, it just disappears */
			if (FlxVelocity.distanceBetween(this, Registry.player) > MAX_ROPE_LENGTH && !isHooking)
			{
				remove();
			}
			
			/* remove the hookshot if it comes into contact with a wall or a floor */
			if (this.isTouching(FlxObject.FLOOR) || this.isTouching(FlxObject.LEFT) || this.isTouching(FlxObject.RIGHT))
			{
				remove();
			}
		}
		
		override public function fire(X:int, Y:int, angle:Number):void
		{
			/* make the hookshot point in the right direction */
			this.angle = angle * (180/Math.PI) + 90;
			super.fire(X, Y, angle);
			
			/* make the hookshot chain show */
			Registry.hookshotChain.show();
		}
		
		/////////////////////////////////////////////////////
		// PUBLIC CALLBACK FUNCTIONS
		/////////////////////////////////////////////////////
		
		public function stopHookshot(hookshot:Hookshot, hookshotable:Marker):void
		{
			isHooking = true;
			velocity.x = 0;
			velocity.y = 0;
			
			/* pull the player to the hookshot */
			Registry.player.pullToHookshot();
		}
		
		/////////////////////////////////////////////////////
		// OTHER PUBLIC FUNCTIONS
		/////////////////////////////////////////////////////
		
		/**
		 * Removes (puts away) the hookshot.
		 */
		public function remove():void
		{
			isHooking = false;
			rope.fill(0x00000000);
			exists = false;
			
			/* hide the chain */
			Registry.hookshotChain.hide();
		}
	}

}