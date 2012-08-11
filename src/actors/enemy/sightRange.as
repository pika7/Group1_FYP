package actors.enemy 
{
	import org.flixel.FlxSprite;
	import util.Registry;
	/**
	 * ...
	 * @author 
	 */
	public class sightRange extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/sightRange.png')] private var sightRangePNG:Class;
		[Embed(source = '../../../assets/img/enemies/sightRange1.png')] private var sightRange1PNG:Class;
		[Embed(source = '../../../assets/img/enemies/sightRange2.png')] private var sightRange2PNG:Class;

		
		public function sightRange(X:int, Y:int) 
		{
			super(X, Y);
			acceleration.y = 600;
			x = Registry.guard.x;
			y = Registry.guard.y;
			facing = RIGHT;
			visible = true;
		}
		
		override public function update():void
		{
			velocity.x = Registry.guard.velocity.x;
			changeSprite();
			//checkFacing();
		}
		
		public function checkFacing():void
		{
			facing = Registry.guard.facing;
		}
		
		public function changeSprite():void
		{
			switch(Registry.guard.getAlertLevel())
			{
				case 0:
						loadGraphic(sightRangePNG, false, true, 128, 128);
						width = 128;
						height = 128;
						facing = LEFT;
						break;
				case 1:
						loadGraphic(sightRange1PNG, false, true, 256, 128);
						width = 256;
						height = 128;
						checkFacing();
						break;
				case 2:
						loadGraphic(sightRange2PNG, false, true, 384, 128);
						width = 384;
						height = 128;
						checkFacing();
						break;
			}	
		}
	}

}