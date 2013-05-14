/* abstract class for cutscenes */

package cutscenes 
{
	import org.flixel.*;
	import util.CutsceneQueue;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;

	public class Cutscene extends FlxGroup
	{
		protected var background:Background;
		protected var leftFaceGraphic:FaceGraphic;
		protected var rightFaceGraphic:FaceGraphic;
		protected var textBox:TextBox;
		protected var queue:CutsceneQueue;
		protected var file:String; // the file from which to load the cutscene
		protected var instructions:Array; // an array with all the instructions
		protected var loadingText:FlxText; // says "loading..." on the screen while cutscene  being loaded
		
		private var currInstruction:Number = 0; // the instruction it is executing right now
		private var fileLoaded:Boolean = false; // whether or not the file has finished loading
		private var complete:Boolean = false; // whether or not the current instruction is complete
		private var running:Boolean = false; // whether or not an instruction is currently running
		private var temp:String;
		
		public var finished:Boolean = false; // whether this cutscene is complete
		
		/**
		 * Run a cutscene with the provided file.
		 * 
		 * @param	PATH	The entire string of the cutscene.
		 */
		public function Cutscene(PATH:String) 
		{
			add(background = new Background);
			
			/* create a queue to hold all of the cutscene instructions */
			queue = new CutsceneQueue();
			
			/* set positioning and facing of face graphics */
			leftFaceGraphic = new FaceGraphic();
			leftFaceGraphic.facing = FlxObject.RIGHT;
			
			rightFaceGraphic = new FaceGraphic();
			rightFaceGraphic.facing = FlxObject.LEFT;
			rightFaceGraphic.x = 300;
			
			add(leftFaceGraphic);
			add(rightFaceGraphic);
			
			add(textBox = new TextBox());
			
			/* add the loading test */
			loadingText = new FlxText(300, 450, 800, "LOADING...");
			loadingText.size = 30;
			add(loadingText);
			
			/* parse the provided text file */
			var urlRequest:URLRequest = new URLRequest(PATH);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT; // default
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			urlLoader.load(urlRequest);
		}
		
		override public function update():void
		{
		/**
		 * This is the cutscene engine.
		 * It runs one instruction at a time until it is "complete", until the end of all instructions.
		 * Different instructions have different completion requirements.
		 * SETBG: Completes immediately.
		 * ENTER_LEFT: Completes when entering is complete.
		 * ENTER_RIGHT: Completes when entering is complete.
		 * SAY: Completes when the user presses the spacebar.
		 */
		
		if (fileLoaded) // wait for file to load
		{ 
			/* get a new instruction if not currently running one, or done */
			if (!running && !finished)
			{
				running = true;
				
				switch(instructions[currInstruction][0]) // 0 is where the instructions are
				{
					case "SETBG":
						background.setBackground(Background.backgrounds[instructions[currInstruction][1]], setComplete);
						break;
					case "ENTER_LEFT":
						leftFaceGraphic.enter(FaceGraphic.faceGraphics[instructions[currInstruction][1]], setComplete);
						break;
					case "ENTER_RIGHT":
						rightFaceGraphic.enter(FaceGraphic.faceGraphics[instructions[currInstruction][1]], setComplete);
						break; 
					case "SAY":
						textBox.say(instructions[currInstruction][1], instructions[currInstruction][3], setComplete);
						/* highlight one of the facegraphics */
						if (instructions[currInstruction][2] == "LEFT")
						{
							leftFaceGraphic.unfade();
						}
						else if (instructions[currInstruction][2] == "RIGHT")
						{
							rightFaceGraphic.unfade();
						}
						else if (instructions[currInstruction][2] == "NONE")
						{
							// do nothing
						}
						else
						{
							trace("Could not determine which graphic to unfade.");
						}
						break;
					case "EXIT_LEFT":
						leftFaceGraphic.exit(setComplete);
						break;
					case "EXIT_RIGHT":
						rightFaceGraphic.exit(setComplete);
						break;
					default:
						trace("Instruction not recognised.");
						break;
				}
			}
		}
			 
			super.update();			
		}
		
		//////// PRIVATE FUNCTIONS /////////
		/* called when the text file is finished loading */
		private function urlLoader_complete(evt:Event):void
		{	
			/* remove the loading text */
			remove(loadingText);
			
			//trace(evt.target.data);
			var currInstruction:String;
			
			/* split the instructions int an array of strings */
			instructions = evt.target.data.split("\r\n");
			
			/* split the instructions themselves further */
			for (var i:int = 0; i < instructions.length; i++)
			{
				currInstruction = instructions[i];
				instructions[i] = currInstruction.split("|");
			}
			
			fileLoaded = true;
		}
		
		/* just a callback function to mark an instruction as completed */
		private function setComplete():void
		{
			/* set both face graphics back to faded */
			leftFaceGraphic.fade();
			rightFaceGraphic.fade();
			
			running = false;
			complete = true;
			
			if (currInstruction < instructions.length - 1)
			{
				currInstruction++;
			}
			else
			{
				finished = true;
			}
		}
	}
}