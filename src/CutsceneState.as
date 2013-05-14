package  
{
	import cutscenes.*;
	import objs.Hole;
	import org.flixel.*;
	import util.Registry;
	
	public class CutsceneState extends FlxState
	{
		
		[Embed(source = '../assets/music/TALK.mp3')] private var SoundEffect:Class;
		private var cutscene:Cutscene;
		private var file:String; // the file to load the cutscene with
		
		/* enumerating the differnet cutscene numbers */
		public static const CUTSCENE0:String = "cutscenes/cutscene00.txt";
		public static const CUTSCENE1:String = "cutscenes/cutscene01.txt";
		public static const CUTSCENE2:String = "cutscenes/cutscene00.txt";
		public static const CUTSCENE3:String = "cutscenes/cutscene00.txt";
		public static const CUTSCENE4:String = "cutscenes/cutscene00.txt";
		public static const CUTSCENE5:String = "cutscenes/cutscene00.txt";
		
		/**
		 * Create a new cutscene.
		 * 
		 * @param	url		The url the cutscene is stored at.
		 */
		public function CutsceneState(url:String) 
		{
			// TODO: make a function in playstate (or whatever state cutscene is switching from that passes a file
			cutscene = new Cutscene(url);
			add(cutscene);
			FlxG.playMusic(SoundEffect, 1);
		}
		
		override public function update():void
		{
			/* check to see if the cutscene is finished */
			// TODO: make some kind of fadeout animation
			if (cutscene.finished)
			{
				FlxG.music.fadeOut(1);
				if (Registry.gameStats.level < 5)
				{
					FlxG.switchState(new PlayState());
				}
				else
				{
					FlxG.switchState(new EndState());
				}
				
			}
			
			super.update();
		}
	}
}