package objs 
{
	public class Hole extends HidingSpot
	{
		import org.flixel.*;
		
		[Embed(source = '../../assets/img/objs/hole.png')] private var itemPNG:Class;
		
		public function Hole(X:int, Y:int) 
		{
			super(X, Y, 100, 100);
			loadGraphic(itemPNG, true, true, 100, 100, true);
			
			width = 80;
			centerOffsets(true);
		}
		
	}

}