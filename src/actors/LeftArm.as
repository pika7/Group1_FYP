package actors 
{
	import org.flixel.*;
	
	public class LeftArm extends AimArm
	{
		[Embed(source = '../../assets/img/player/aim_leftarm.png')] private var aimLeftArmPNG:Class;
		
		
		public function LeftArm() 
		{
			super();
			loadGraphic(aimLeftArmPNG, true, true, 68, 25); // maybe change this to change the graphic for hookshot later
			
			addAnimation("fire", [1, 0], 10, false);
		}
		
	}

}