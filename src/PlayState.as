/* you're going to have to change the classpath to your own flixel directory later */
/* tools > Global Classpaths */

package  
{
	import actors.enemy.Guard;
	import actors.enemy.sightRanges;
	import actors.Player;
	import levels.TestLevel;
	import org.flixel.*;
	import util.Registry;
	import objs.*;
	import util.TranqBulletHandler;
	import weapons.Hookshot;
	
	public class PlayState extends FlxState
	{
		override public function create():void
		{
			/* initialise registry objects */
			/* TODO: allow selection of different levels */
			Registry.level = new TestLevel();
			add(Registry.level);
			
			add(Registry.tranqBulletHandler);
			add(Registry.goalItem);
			add(Registry.exit);
			
			Registry.hookshot = new Hookshot();
			add(Registry.hookshot);
			add(Registry.hookshot.rope); //yup, have to add the hookshot and the rope as well
			
			Registry.player = new Player(20, 20);
			add(Registry.player);
			add(Registry.noiseRadii);
			
			/* add markers */
			add(Registry.markers_ladderBottom);
			add(Registry.markers_ladderTop);
			add(Registry.markers_hookshotable);
	
			
			/* FOR TESTING */
			Registry.guard = new Guard(150, 20);
			
			Registry.sightranges = new sightRanges(160, 20);
			
			add(Registry.sightranges);
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
			//FlxG.collide(Registry.level, Registry.sightranges); <-- dont need this
			
			FlxG.overlap(Registry.player, Registry.goalItem, getGoalItem);
			FlxG.overlap(Registry.player, Registry.exit, completeLevel);
			FlxG.overlap(Registry.player, Registry.markers_ladderBottom, Registry.player.handleLadderBottom);
			FlxG.overlap(Registry.player, Registry.markers_ladderTop, Registry.player.handleLadderTop);
			FlxG.overlap(Registry.hookshot, Registry.markers_hookshotable, Registry.hookshot.stopHookshot);
			FlxG.overlap(Registry.guard, Registry.markers_enemyStop, Registry.guard.handleEnemyStop);

			FlxG.overlap(Registry.guard, Registry.noiseRadii, Registry.guard.noiseAlert);
			FlxG.overlap(Registry.sightranges, Registry.player, Registry.guard.followPlayer);
	
			
			super.update();
		}
		
		/////////////////////////////////////////
		// OVERLAP CALLBACKS
		/////////////////////////////////////////
		/* the player picks up the goal item */
		private function getGoalItem(player:Player, goalItem:GoalItem):void
		{
			player.gotGoalItem = true;
			goalItem.kill();
		}
		
		/* the player completes the level, if she has the goal item */
		private function completeLevel(player:Player, exit:Exit):void
		{
			if (player.gotGoalItem)
			{
				clearRegistry();
				FlxG.switchState(new WinState());
			}
		}
		
		/////////////////////////////////////////
		// PRIVATE HELPER FUNCTIONS
		/////////////////////////////////////////
		/* clear the registry in preparation of state change */
		private function clearRegistry():void
		{
			Registry.tranqBulletHandler.clear();
			remove(Registry.tranqBulletHandler);
			
			Registry.enemyGroup.clear();
			remove(Registry.enemyGroup);
			
			Registry.bulletGroup.clear();
			remove(Registry.bulletGroup);
			
			Registry.markers_ladderBottom.clear();
			remove(Registry.markers_ladderBottom);
			
			Registry.markers_ladderTop.clear();
			remove(Registry.markers_ladderTop);
			
			Registry.markers_enemyStop.clear();
			remove(Registry.markers_enemyStop);
			
			Registry.noiseRadii.clear();
			remove(Registry.noiseRadii);
			
			Registry.markers_hookshotable.clear();
			remove(Registry.markers_hookshotable);
			
			/* TEMPORARY */
			remove(Registry.guard);
		}
	}

}