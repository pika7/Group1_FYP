package  
{
	import cutscenes.*;
	import objs.Hole;
	import org.flixel.*;
	
	public class CutsceneState extends FlxState
	{
		private var cutscene:Cutscene;
		private var file:String; // the file to load the cutscene with
		
		public function CutsceneState() 
		{
			// TODO: make a function in playstate (or whatever state cutscene is switching from that passes a file
			cutscene = new Cutscene("cutscenes/cutscene01.txt");
			add(cutscene);
		}
		
		override public function update():void
		{
			/*
			if (FlxG.keys.justPressed("C"))
			{
				FlxG.switchState(new PlayState());
			}
			*/
			
			/* check to see if the cutscene is finished */
			// TODO: make some kind of fadeout animation
			if (cutscene.finished)
			{
				FlxG.switchState(new PlayState());
			}
			
			super.update();
		}
	}
}