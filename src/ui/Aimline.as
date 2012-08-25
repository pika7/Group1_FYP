/* just a red line to show the player where she is aiming */

package ui 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import util.Registry;
	
	public class Aimline extends FlxSprite
	{
		[Embed(source = '../../assets/img/ui/aimline.png')] private var linePNG:Class;
		
		public function Aimline() 
		{
			super(0, 0);
			loadGraphic(linePNG, false, false, 1600, 1, false);
			alpha = 0.4;
			
			exists = false;
		}
		
		override public function update():void
		{
			/* it always traces a line from the player to the mouse */
			angle = FlxVelocity.angleBetweenMouse(Registry.player.firePoint, true);
		}
		
	}

}