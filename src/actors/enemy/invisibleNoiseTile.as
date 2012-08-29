package actors.enemy 
{
	import org.flixel.FlxSprite;
	import util.Registry;
	
	public class invisibleNoiseTile extends FlxSprite
	{
		
		public function invisibleNoiseTile(X:int, Y:int) 
		{
			super(X, Y);
			width = 1;
			height = 1;
			
			Registry.noiseTile = this;
			
			exists = false;
		}
		
	}

}