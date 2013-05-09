package  
{
	import org.flixel.*;
	
	
	
	public class TitleState extends FlxState 
	{
		[Embed(source = '../assets/music/Title.mp3')] private var SoundEffect:Class;

		override public function create():void
		{
			add(new FlxText(275, 200, 800, "Title screen, press SPACE to start", false));
		
			FlxG.playMusic(SoundEffect, 1);
		}
		
		override public function update():void
		{
			
			

			/* press space to start the game */
			if (FlxG.keys.pressed("SPACE"))
			{
				FlxG.music.fadeOut(1);
				FlxG.switchState(new PlayState());
			}
			super.update();
		}
	}
}