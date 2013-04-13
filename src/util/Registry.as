/**
 * Actually, we want as few as possible things actually instantiated in the Registry as possible.
 * This causes errors when these things call other objects that have been instantiated in the Registry in their constructor.
 * It will return a null object reference exception.
 * Try to remove as many things from the Registry as possible as only keep things that MUST persist from state to state,
 * such as the GameStats which holds all the persistent variables
 */

package util 
{
	import actors.*;
	import actors.enemy.*;
	import levels.*;
	import objs.Exit;
	import objs.GoalItem;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import ui.UIHandler;
	import weapons.Hookshot;
	import weapons.HookshotChain;
	import weapons.SmokeBomb;
	
	public class Registry 
	{
		public static const TILESIZE:int = 32;
		
		/* game stats, preferably the only thing to be initialised in the Registry */
		public static var gameStats:GameStats = new GameStats();
		
		/* these will be initialised in the PlayState */
		public static var player:Player;
		public static var level:Level;
		public static var goalItem:GoalItem;
		public static var exit:Exit;
		public static var hookshot:Hookshot;
		public static var hookshotChain:HookshotChain;
		public static var levelGuardPath:LevelGuardPath; //for loading guard patrol path
		
		//TODO: initialise these in playstate
		public static var tranqBulletHandler:TranqBulletHandler;
		public static var smokeBombHandler:SmokeBombHandler;
		public static var stunGrenadeHandler:StunGrenadeHandler;
		public static var noiseHandler:NoiseHandler;
		public static var hidingSpots:FlxGroup;
		public static var uiHandler:UIHandler;
		
		/* enemy stuff */
		public static var guard:Guard;
		public static var guards:Guards;
		public static var sightranges:sightRanges;	
		public static var gSightRadius:guardSightRadius;
		public static var bulletGroup:FlxGroup = new FlxGroup;
		public static var enemyGroup:FlxGroup = new FlxGroup; //enemies will be added here late
		public static var guardLadderDirection:String; //going up or down
		public static var guardStartPoint:patrolPathNode;
		public static var guardEndPoint:patrolPathNode;
		public static var dogStartPoint:patrolPathNode;
		public static var dogEndPoint:patrolPathNode;
		public static var noiseTile:invisibleNoiseTile;
		public static var noiseCoord:FlxPoint = new FlxPoint(0, 0);
		public static var stunNoiseCoord:FlxPoint = new FlxPoint(0, 0);
		
		/* marker groups */
		public static var markers_ladderBottom:FlxGroup;
		public static var markers_ladderTop:FlxGroup;
		public static var markers_hookshotable:FlxGroup;
		public static var markers_enemyStop:FlxGroup;
	
		public function Registry() 
		{
			
		}
	}

}