package actors.enemy 
{
	import org.flixel.FlxSprite;
	import util.Registry;
	
	public class invisibleNoiseTile extends FlxSprite
	{
		
		public function invisibleNoiseTile(X:int, Y:int) 
		{
			super(X, Y);
			width = Registry.TILESIZE;
			height = Registry.TILESIZE;
			
			Registry.noiseTile = this;
			
			exists = false;
		}
		
	}

}