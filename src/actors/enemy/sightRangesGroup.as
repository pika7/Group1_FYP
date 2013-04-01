package actors.enemy 
{
	import org.flixel.FlxGroup;
	import actors.enemy.sightRanges;
	
	public class sightRangesGroup extends FlxGroup
	{
		public function sightRangesGroup() 
		{
			super();
		}
		
		public function addSightRange(X:int, Y:int):void
		{
			var tempSightRange:sightRanges = new sightRanges(X, Y); 
			add(tempSightRange);
		}
		
		
		override public function update():void
		{
			super.update();
		}
		
	}

}