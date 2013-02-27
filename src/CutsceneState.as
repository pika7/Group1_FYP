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
			cutscene = new Cutscene();
			
			add(cutscene);
			cutscene.run("cutscenes/cutscene01.txt");
		}
		
		override public function update():void
		{
			if (FlxG.keys.justPressed("C"))
			{
				FlxG.switchState(new PlayState());
			}
			
			super.update();
		}
	}
}