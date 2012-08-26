/* this is the "chain" of the hookshot -- consists of starting point, end point, and a number of links */

package weapons 
{
	import org.flixel.*;
	import util.Registry;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	
	public class HookshotChain extends FlxGroup
	{
		private const NUMBER_OF_LINKS:int = 30;
		
		private var startPoint:FlxPoint;
		private var endPoint:FlxPoint;
		private var isShowing:Boolean = false;
		private var interval:Number;
		private var currInterval:Number; // how far along the chain.
		private var lengthX:Number;
		private var lengthY:Number;
		
		public function HookshotChain() 
		{
			super();
			interval = 1 / NUMBER_OF_LINKS;
			currInterval = 0;
			startPoint = new FlxPoint(0, 0);
			endPoint = new FlxPoint(0, 0);
			lengthX = 0;
			lengthY = 0;
			
			/* add all the links to the group */
			for (var i:int = 0; i <= NUMBER_OF_LINKS; i++)
			{
				add(new HookshotLink());
			}
		}
		
		override public function update():void
		{
			if (isShowing)
			{
				currInterval = 0;
				lengthX = endPoint.x - startPoint.x;
				lengthY = endPoint.y - startPoint.y;
				
				/* place all the links along the line from the startPoint to the endPoint */
				for (var i:int = 0; i <= NUMBER_OF_LINKS; i++)
				{
					members[i].moveTo(Registry.player.firePoint.x + (currInterval * lengthX), Registry.player.firePoint.y + (currInterval * lengthY));
					currInterval += interval;
				}
			}

			super.update();
		}
		
		/**
		 * Show the <code>HookshotChain</code>.
		 */
		public function show():void
		{
			callAll("show");
			isShowing = true;
		}
		
		/**
		 * Hide the <code>HookshotChain</code>.
		 */
		public function hide():void
		{
			callAll("hide");
			isShowing = false;
		}
		
		/**
		 * Draw the <code>HookshotChain</code> between two points.
		 * 
		 * @param	startX		Starting x-position.
		 * @param	startY		Starting y-position.
		 * @param	endX		Ending x-position.
		 * @param	endY		Ending y-position.
		 */
		public function drawChain(startX:int, startY:int, endX:int, endY:int):void
		{
			startPoint.x = startX;
			startPoint.y = startY;
			endPoint.x = endX;
			endPoint.y = endY;
		}
	}
}