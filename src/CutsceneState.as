package  
{
	import cutscenes.*;
	import objs.Hole;
	import org.flixel.*;
	
	public class CutsceneState extends FlxState
	{
		
		[Embed(source = '../assets/music/TALK.mp3')] private var SoundEffect:Class;
		private var cutscene:Cutscene;
		private var file:String; // the file to load the cutscene with
		
		public function CutsceneState() 
		{
			// TODO: make a function in playstate (or whatever state cutscene is switching from that passes a file
			cutscene = new Cutscene("cutscenes/cutscene01.txt");
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
				FlxG.switchState(new PlayState());
			}
			
			super.update();
		}
	}
}