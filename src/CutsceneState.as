package  
{
	import cutscenes.*;
	import objs.Hole;
	import org.flixel.*;
	
	public class CutsceneState extends FlxState
	{
		private var cutscene:Cutscene;
		
		public function CutsceneState() 
		{
			// TODO: make something that allows you to select cutscenes
			// TODO: make an array of cutscenes instead?
			cutscene = new Cutscene01();
			
			add(cutscene);
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