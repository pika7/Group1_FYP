package  
{
	import org.flixel.*;
	
	public class WinState extends FlxState 
	{
		override public function create():void
		{
			add(new FlxText(200, 200, 800, "You win! Press SPACE to go back to the title screen.", false));
		}
		
		override public function update():void
		{
			/* press space to restart the game */
			if (FlxG.keys.pressed("SPACE"))
			{
				FlxG.switchState(new TitleState());
			}
		}
	}
}