package util 
{
	import actors.*;
	import actors.enemy.*;
	import levels.*;
	import org.flixel.FlxGroup;
	
	public class Registry 
	{
		public static var level:Level;
		public static var player:Player;
		public static var guard:Guard;
		public static var enemyGroup:FlxGroup = new FlxGroup;
		
		public function Registry() 
		{
			
		}
	}

}