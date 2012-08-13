package util 
{
	import actors.*;
	import actors.enemy.*;
	import levels.*;
	import objs.Exit;
	import objs.GoalItem;
	import org.flixel.FlxGroup;
	import weapons.Hookshot;
	
	public class Registry 
	{
		public static const TILESIZE:int = 32;
		
		/* these will be initialised in the PlayState */
		public static var level:Level;
		public static var player:Player;
		public static var goalItem:GoalItem;
		public static var exit:Exit;
		public static var hookshot:Hookshot;
		
		public static var tranqBulletHandler:TranqBulletHandler = new TranqBulletHandler();		
		public static var enemyGroup:FlxGroup = new FlxGroup; //enemies will be added here later
		public static var bulletGroup:FlxGroup = new FlxGroup;
		public static var noiseRadii:FlxGroup = new FlxGroup();
		
		/* enemy stuff */
		public static var guard:Guard;
		public static var sightrange:sightRange;
		public static var sightrange1:sightRange1;
		public static var sightrange2:sightRange2;
		
		
		
		/* marker groups */
		public static var markers_ladderBottom:FlxGroup = new FlxGroup();
		public static var markers_ladderTop:FlxGroup = new FlxGroup();
		public static var markers_hookshotable:FlxGroup = new FlxGroup();
		
		public static var markers_enemyStop:FlxGroup = new FlxGroup();
		
		public function Registry() 
		{
			
		}
	}

}