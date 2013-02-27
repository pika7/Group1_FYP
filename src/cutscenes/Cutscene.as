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
		
		public function Cutscene() 
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
		}
		
		override public function update():void
		{	
			super.update();			
		}
		
		/**
		 * Run a cutscene with path to the text file to parse.
		 * 
		 * @param	The path to the text file to parse.
		 */
		public function run(PATH:String):void
		{
			var urlRequest:URLRequest = new URLRequest(PATH);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT; // default
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			urlLoader.load(urlRequest);
		}
		
		//////// PRIVATE FUNCTIONS /////////
		private function urlLoader_complete(evt:Event):void
		{
			//textArea.text = urlLoader.data;
			trace(evt.target.data);
		}
	}
}