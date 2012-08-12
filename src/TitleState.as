package  
{
	import org.flixel.*;
	
	public class TitleState extends FlxState 
	{
		override public function create():void
		{
			add(new FlxText(275, 200, 800, "Title screen, press SPACE to start", false));
		}
		
		override public function update():void
		{
			/* press space to start the game */
			if (FlxG.keys.pressed("SPACE"))
			{
				FlxG.switchState(new PlayState());
			}
		}
	}
}