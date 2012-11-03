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
		protected var nameText:FlxText;
		protected var dialogText:FlxText;
		
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
			
			nameText = new FlxText(40, 410, 700);
			nameText.size = 18;
			nameText.color = 0xFFFFFF00;
			nameText.text = "Name test";
			
			
			dialogText = new FlxText(50, 435, 700);
			dialogText.size = 18;
			dialogText.text = "I'm not really sure what I should put here...";
			
			add(nameText);
			add(dialogText);
		}
	}
}