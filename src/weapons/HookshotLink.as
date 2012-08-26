/* this is one link of the hookshot chain */

package weapons 
{
	import org.flixel.*;
	import util.Registry;
	
	public class HookshotLink extends FlxSprite
	{
		[Embed(source = '../../assets/img/player/weapons/hookshot_link.png')] private var linkPNG:Class;
		
		public function HookshotLink() 
		{
			super(0, 0);
			loadGraphic(linkPNG, false, false, 6, 6, false);
			
			exists = false;
		}
		
		/**
		 * Show the <code>HookshotLink</code>.
		 */
		public function show():void
		{
			exists = true;
		}
		
		/**
		 * Hide the <code>HookshotLink</code>.
		 */
		public function hide():void
		{
			exists = false;
		}
		
		/**
		 * Move the <code>HookshotLink</code> to the specified location.
		 * 
		 * @param	x	x-coordinate to draw it at.
		 * @param	y	y-coordinate to draw it at.
		 */
		public function moveTo(X:int, Y:int):void
		{
			x = X;
			y = Y;
		}
	}
}