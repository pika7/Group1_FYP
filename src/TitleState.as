package  
{
	import org.flixel.*;
	import util.Registry;
	
	
	public class TitleState extends FlxState 
	{
		[Embed(source = '../assets/music/Title.mp3')] private var SoundEffect:Class;
		[Embed(source = "../assets/img/tilemaps/title_bg.png")] public var backgroundPNG:Class;

		override public function create():void
		{
			/* reset levels */
			Registry.gameStats.level = 0;
			
			add(new FlxSprite(0, 0, backgroundPNG));
			FlxG.playMusic(SoundEffect, 1);
		}
		
		override public function update():void
		{
			/* press space to start the game */
			if (FlxG.keys.pressed("SPACE"))
			{
				FlxG.music.fadeOut(1);
				FlxG.switchState(new CutsceneState(CutsceneState.CUTSCENE0));
			}
			super.update();
		}
	}
}