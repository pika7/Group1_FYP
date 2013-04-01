package actors.enemy 
{
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author 
	 */
	public class guardSightRadiusGroup extends FlxGroup
	{
		
		
		public function guardSightRadiusGroup() 
		{
			super();
		}
		
		public function addSightRadius(X:int, Y:int):void
		{
			var tempSightRadius:guardSightRadius = new guardSightRadius(X, Y); 
			add(tempSightRadius);
		}
		
		
		override public function update():void
		{
			super.update();
		}
		
	}

}