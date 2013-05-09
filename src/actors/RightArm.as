package actors
{
	import org.flixel.*;
	
	public class RightArm extends AimArm
	{
		[Embed(source = '../../assets/img/player/aim_rightarm.png')] private var aimRightArmPNG:Class;
		
		
		public function RightArm() 
		{
			super();
			loadGraphic(aimRightArmPNG, false, true); // maybe change this to change the graphic for hookshot later
		}
	}
}