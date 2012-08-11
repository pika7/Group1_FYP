/* you're going to have to change the classpath to your own flixel directory later */
/* tools > Global Classpaths */

package  
{
	import actors.enemy.Guard;
	import actors.enemy.sightRange;
	import actors.Player;
	import levels.TestLevel;
	import org.flixel.*;
	import util.Registry;
	import objs.*;
	import util.TranqBulletHandler;
	
	public class PlayState extends FlxState
	{
		public function PlayState() 
		{	
			
		}
		
		override public function create():void
		{
			/* initialise registry objects */
			/* TODO: allow selection of different levels */
			Registry.level = new TestLevel();
			add(Registry.level);
			
			Registry.player = new Player(20, 20);
			add(Registry.player);
			
			add(Registry.tranqBulletHandler);
			add(Registry.goalItem);
			add(Registry.markers_ladderBottom);
			add(Registry.markers_ladderTop);
	
			
			/* FOR TESTING */
			Registry.guard = new Guard(150, 20);
			
			Registry.sightrange = new sightRange(160, 20);
			add(Registry.sightrange);
			
			add(Registry.guard);
			add(Registry.bulletGroup);
			
			/* show the mouse */
			FlxG.mouse.show();

		}
		
		override public function update():void
		{
			/////////////////////////////////////////
			// CAMERA CONTROLS
			/////////////////////////////////////////
			FlxG.worldBounds = new FlxRect(0, 0, Registry.level.width, Registry.level.height);
			FlxG.camera.setBounds(0, 0, Registry.level.width, Registry.level.height);
			FlxG.camera.follow(Registry.player, FlxCamera.STYLE_PLATFORMER);
			
			/////////////////////////////////////////
			// COLLISION CONTROLS
			/////////////////////////////////////////
			if (!Registry.player.onLadder())
			{
				FlxG.collide(Registry.level, Registry.player);
			}
			
			FlxG.collide(Registry.level, Registry.guard);
			FlxG.collide(Registry.level, Registry.sightrange);
			
			FlxG.overlap(Registry.player, Registry.goalItem, getGoalItem);
			FlxG.overlap(Registry.player, Registry.markers_ladderBottom, Registry.player.handleLadderBottom);
			FlxG.overlap(Registry.player, Registry.markers_ladderTop, Registry.player.handleLadderTop);

			FlxG.overlap(Registry.sightrange, Registry.player, Registry.guard.followPlayer);
			
			super.update();
		}
		
		/////////////////////////////////////////
		// OVERLAP CALLBACKS
		/////////////////////////////////////////
		private function getGoalItem(player:Player, goalItem:GoalItem):void
		{
			player.gotGoalItem = true;
			goalItem.kill();
		}
		
		// TODO: make a clear registry function
	}

}