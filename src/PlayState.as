/* you're going to have to change the classpath to your own flixel directory later */
/* tools > Global Classpaths */

package  
{
	import actors.enemy.Guard;
	import actors.enemy.sightRanges;
	import actors.Player;
	import levels.TestLevel;
	import org.flixel.*;
	import ui.UIHandler;
	import util.Registry;
	import objs.*;
	import util.TranqBulletHandler;
	import weapons.*;
	import levels.TestGuardPath; //for loading test patrol path
	import util.NoiseHandler;
	
	public class PlayState extends FlxState
	{
		override public function create():void
		{
			/* initialise registry objects */
			/* TODO: allow selection of different levels */
			Registry.level = new TestLevel();
			add(Registry.level);
			
			/*add guard patrol path for the level */
			Registry.levelGuardPath = new TestGuardPath();
			add(Registry.levelGuardPath);	
			
			add(Registry.hidingSpots);
			add(Registry.goalItem);
			add(Registry.exit);
			
			add(Registry.hookshot = new Hookshot());
			add(Registry.hookshotChain = new HookshotChain());
			
			add(Registry.hookshot.rope); //yup, have to add the hookshot and the rope as well
			
			
			Registry.player = new Player(20, 20);
			add(Registry.player);
			add(Registry.noiseHandler);
			
			/* add markers */
			add(Registry.markers_ladderBottom);
			add(Registry.markers_ladderTop);
			add(Registry.markers_hookshotable);
			
			/* add projectiles and explosions */
			add(Registry.tranqBulletHandler);
			add(Registry.smokeBombHandler);
			add(Registry.smokeBombHandler.smokeCloudGroup);
			add(Registry.stunGrenadeHandler);
			add(Registry.stunGrenadeHandler.stunExplosionGroup);
			
			/* add UI elements */
			add(Registry.uiHandler = new UIHandler());
	
			
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
			
			if (!Registry.guard.onLadder())
			{
				FlxG.collide(Registry.level, Registry.guard);
			}
		
			FlxG.collide(Registry.level, Registry.tranqBulletHandler, TranqBullet.ping_callback);
			FlxG.collide(Registry.level, Registry.smokeBombHandler, ThrowableWeapon.bounce);	
			FlxG.collide(Registry.level, Registry.stunGrenadeHandler, ThrowableWeapon.bounce);
			FlxG.collide(Registry.level, Registry.bulletGroup);

			
			FlxG.overlap(Registry.player, Registry.goalItem, getGoalItem);
			FlxG.overlap(Registry.player, Registry.exit, completeLevel);
			
			
			FlxG.overlap(Registry.sightranges, Registry.player, Registry.guard.seePlayer);
			FlxG.overlap(Registry.guard, Registry.markers_enemyStop, Registry.guard.handleEnemyStop);
			FlxG.overlap(Registry.guard, Registry.noiseHandler, Registry.guard.noiseAlert);
			FlxG.overlap(Registry.guard, Registry.markers_ladderTop, Registry.guard.handleLadderTop);
			FlxG.overlap(Registry.guard, Registry.markers_ladderBottom, Registry.guard.handleLadderBottom);
			
			if (!(FlxG.overlap(Registry.player, Registry.markers_ladderBottom, Registry.player.handleLadderBottom) || FlxG.overlap(Registry.player, Registry.markers_ladderTop, Registry.player.handleLadderTop)))
			{
				Registry.player.doneClimbingUpLadder = false;
				Registry.player.doneClimbingDownLadder = false;
			}
			
			/* these two must be in this order */
			FlxG.overlap(Registry.hookshot, Registry.markers_hookshotable, Registry.hookshot.stopHookshot);
			
			if (!Registry.hookshot.isHooking)
			{
				FlxG.collide(Registry.level, Registry.hookshot);
			}
			
			super.update();
			
			/* for testing purposes only, remove later */
			if (FlxG.keys.justPressed("F"))
			{
				trace("lose life!");
				Registry.gameStats.damage(10);
			}
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
				FlxG.switchState(new EndState());
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
			
			Registry.smokeBombHandler.clear();
			remove(Registry.smokeBombHandler);
			remove(Registry.smokeBombHandler.smokeCloudGroup);
			
			Registry.stunGrenadeHandler.clear();
			remove(Registry.stunGrenadeHandler);
			remove(Registry.stunGrenadeHandler.stunExplosionGroup);
			
			/* don't need to clear groups that you don't dynamically add things to */
			remove(Registry.uiHandler);
			remove(Registry.hidingSpots);
			
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
			
			Registry.noiseHandler.clear();
			remove(Registry.noiseHandler);
			
			Registry.markers_hookshotable.clear();
			remove(Registry.markers_hookshotable);
			
			/* TEMPORARY */
			remove(Registry.guard);
		}
	}

}