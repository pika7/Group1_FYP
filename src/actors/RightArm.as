package actors
{
	import org.flixel.*;
	
	public class RightArm extends AimArm
	{
		[Embed(source = '../../assets/img/player/aim_rightarm.png')] private var aimRightArmPNG:Class;
		
		
		public function RightArm() 
		{
			super();
			loadGraphic(aimRightArmPNG, true, true, 120, 25); // maybe change this to change the graphic for hookshot later
			
			addAnimation("fire", [1, 0], 10, false);
		}
	}
}