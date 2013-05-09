package actors 
{
	import org.flixel.*;
	
	public class LeftArm extends AimArm
	{
		[Embed(source = '../../assets/img/player/aim_leftarm.png')] private var aimLeftArmPNG:Class;
		
		
		public function LeftArm() 
		{
			super();
			loadGraphic(aimLeftArmPNG, false, true); // maybe change this to change the graphic for hookshot later
		}
		
	}

}