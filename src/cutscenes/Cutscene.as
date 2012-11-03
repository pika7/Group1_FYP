/* abstract class for cutscenes */

package cutscenes 
{
	import org.flixel.*;
	
	public class Cutscene extends FlxGroup
	{
		protected var background:Background;
		protected var leftFaceGraphic:FaceGraphic;
		protected var rightFaceGraphic:FaceGraphic;
		protected var textBox:TextBox;
		
		public function Cutscene() 
		{
			add(background = new Background);
			
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
	}
}