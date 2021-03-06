/* you're going to have to change the classpath to your own flixel directory later */
/* tools > Global Classpaths */

package  
{
	import actors.enemy.Cameras;
	import actors.enemy.CameraSightRange;
	import actors.enemy.CameraSightRanges;
	import actors.enemy.Guard;
	import actors.enemy.guardBullet;
	import actors.enemy.guardSightRadiusGroup;
	import actors.enemy.sightRanges;
	import actors.enemy.guardSightRadius;
	import actors.enemy.sightRangesGroup;
	import actors.enemy.Camera;
	import actors.Player;
	import levels.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import ui.UIHandler;
	import util.Registry;
	import objs.*;
	import util.SmokeBombHandler;
	import util.StunGrenadeHandler;
	import util.TranqBulletHandler;
	import weapons.*;
	import levels.TestGuardPath; //for loading test patrol path
	import util.NoiseHandler;
	import actors.enemy.Guards;
	
	public class PlayState extends FlxState
	{
		[Embed(source = '../assets/music/Stage.mp3')] private var SoundEffect:Class;
		[Embed(source = '../assets/soundeffect/enemies/goalitem.mp3')] private var goalitemEffect:Class;
		[Embed(source = '../assets/soundeffect/enemies/alert.mp3')] private var alertEffect:Class;
		
		// TODO: put this somewhere better, ask cathy
		private const ENEMY_BULLET_DAMAGE:int = 10;
		
		public var guards:Guards;
		public var guardSightRanges:sightRangesGroup;
		public var guardSightRadii:guardSightRadiusGroup;
		public var cameraGroup:Cameras;
		public var cameraSRGroup:CameraSightRanges;
		
		/**
		 * Create a new PlayState with the player at the specified location.
		 * 
		 * @param	X	X-coodinate of the player
		 * @param	Y	Y-coordinate of the player
		 */
		override public function create():void
		{
			/* initialise registry objects */
			/* markers */
			Registry.markers_ladderBottom = new FlxGroup();
			Registry.markers_ladderTop = new FlxGroup();
			Registry.markers_hookshotable = new FlxGroup();
			Registry.markers_enemyStop = new FlxGroup();
			
			/* other stuff */
			Registry.noiseHandler = new NoiseHandler();
			Registry.hidingSpots = new FlxGroup();
			Registry.tranqBulletHandler = new TranqBulletHandler();
			Registry.smokeBombHandler = new SmokeBombHandler();
			Registry.stunGrenadeHandler = new StunGrenadeHandler();
			
			/* load new level depending on current level */
			switch (Registry.gameStats.level)
			{
				case 0:
					Registry.level = new Level();
					Registry.player = new Player(50, 510);
					break;
					
				case 1:
					Registry.level = new Level();
					Registry.player = new Player(20, 510);
					break;
					
				case 2:
					Registry.level = new Level();
					Registry.player = new Player(67, 30);
					break;
					
				case 3:
					Registry.level = new Level();
					Registry.player = new Player(4631, 20);
					break;
					
				case 4:
					Registry.level = new Level();
					Registry.player = new Player(4631, 20);
					break;
			}
			
			add(Registry.level);
			
				/*add guard patrol path for the level */
			guards = new Guards;
			
			switch (Registry.gameStats.level)
			{
				case 0:
					Registry.levelGuardPath = new TestGuardPath();
					guards.addGuard(200, 493, 230, 657, 1512, 232);
					guards.addGuard(2419, 530, 2611, 657, 3303, 648);
					guards.addGuard(3372, 386, 3372, 386, 4000, 400);
					break;

				case 1:
					Registry.levelGuardPath = new TestGuardPath();
					guards.addGuard(647, 100, 665, 168, 1478, 750);
					break;
	
				case 2:
					Registry.levelGuardPath = new TestGuardPath();
					guards.addGuard(79, 315, 79, 361, 709, 371);
					guards.addGuard(1066, 315, 1068, 367, 1638, 359);
					guards.addGuard(4046, 443, 4050, 493, 4708, 480);
					break;
	
				case 3:
					Registry.levelGuardPath = new TestGuardPath();
					guards.addGuard(335, 630, 335, 751, 937, 746);
					guards.addGuard(2012, 109, 2012, 240, 2922, 233);
					guards.addGuard(1366, 630, 1366, 751, 2090, 745);
					guards.addGuard(2131, 500, 2131, 654, 3086, 657);
					guards.addGuard(3847, 600, 3847, 713, 4739, 713);
					break;
					
				case 4:
					Registry.levelGuardPath = new TestGuardPath();
					guards.addGuard(2688, 592, 2642, 746, 3951, 332);
					guards.addGuard(2888, 592, 2642, 746, 3951, 332);
					guards.addGuard(3000, 592, 2642, 746, 3951, 332);
					guards.addGuard(3524, 592, 2642, 746, 3951, 332);
					guards.addGuard(4000, 592, 2642, 746, 3951, 332);
					guards.addGuard(116, 592, 118, 746, 2312, 742);
					guards.addGuard(200, 592, 210, 746, 2312, 742);
					guards.addGuard(400, 592, 401, 746, 2312, 742);
					guards.addGuard(500, 592, 401, 746, 2312, 742);
					guards.addGuard(600, 592, 401, 746, 2312, 742);
					break;
				
			}	
				
			add(Registry.levelGuardPath);	
			add(guards);
			
			
		
			
			/* add registry objects */
			add(Registry.hidingSpots);
			add(Registry.goalItem);
			add(Registry.exit);
			add(Registry.hookshot = new Hookshot());
			add(Registry.hookshotChain = new HookshotChain());
			add(Registry.hookshot.rope); //yup, have to add the hookshot and the rope as well
			add(Registry.noiseHandler);
			
			/* add the arms separately so that they stack correctly */
			add(Registry.player.aimLeftArm);
			add(Registry.player);
			add(Registry.player.aimRightArm);
			
			/* add markers */
			add(Registry.markers_ladderBottom);
			add(Registry.markers_ladderTop);
			add(Registry.markers_hookshotable);
			
			/* add projectiles and explosions */
			add(Registry.tranqBulletHandler);
			add(Registry.smokeBombHandler);
			add(Registry.stunGrenadeHandler);
			add(Registry.smokeBombHandler.smokeCloudGroup);
			add(Registry.stunGrenadeHandler.stunExplosionGroup);
			
			/* add UI elements */
			/* TODO: make sure this is always on top */
			add(Registry.uiHandler = new UIHandler());
		
			
			
			
			/* put sight ranges in different places according to different levels */
			guardSightRanges = new sightRangesGroup;
			guardSightRanges.addSightRange(160, 20);
			guardSightRanges.addSightRange(628, 20);
			guardSightRanges.addSightRange(1128, 20);
			guardSightRanges.addSightRange(1128, 20);
			guardSightRanges.addSightRange(1128, 20);
			guardSightRanges.addSightRange(160, 20);
			guardSightRanges.addSightRange(628, 20);
			guardSightRanges.addSightRange(1128, 20);
			guardSightRanges.addSightRange(1128, 20);
			guardSightRanges.addSightRange(1128, 20);
			add(guardSightRanges);
			
			/* put cameras in different positions according to different levels */
		//	cameraGroup = new Cameras;
	//		cameraGroup.addCamera(876, 106);
		//	add(cameraGroup);
			
			/* put camera sight ranges in different places according to different levels */
			cameraSRGroup = new CameraSightRanges;
			cameraSRGroup.addCameraSightRange(880, 138);
			add(cameraSRGroup);
			
			/* put circle sight ranges here according to different levels */
			guardSightRadii = new guardSightRadiusGroup;
			guardSightRadii.addSightRadius(0, 0);
			guardSightRadii.addSightRadius(0, 0);
			guardSightRadii.addSightRadius(0, 0);
			add(guardSightRadii);
			
			add(Registry.bulletGroup);
			//add(Registry.gSightRadius);
		
			/* show the mouse */
			FlxG.mouse.show();
			
			/* Music stuff */
			FlxG.playMusic(SoundEffect, 1);
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
			
			///////////////////////////////////////////
			// ENEMY COLLISION CONTROLS 
			//////////////////////////////////////
			enemyCollisionControl();
			
			/* ENEMY CAMERA OVERLAP CONTROL */
			FlxG.overlap(cameraSRGroup, Registry.player,cameraOverlapControl);
			
			
			FlxG.collide(Registry.level, Registry.tranqBulletHandler, TranqBullet.ping_callback);
			FlxG.collide(Registry.level, Registry.smokeBombHandler, ThrowableWeapon.bounce);	
			FlxG.collide(Registry.level, Registry.stunGrenadeHandler, ThrowableWeapon.bounce);
			FlxG.collide(Registry.level, Registry.bulletGroup);

			FlxG.overlap(Registry.player, Registry.bulletGroup, damagePlayerBullet);
			FlxG.overlap(Registry.player, Registry.goalItem, getGoalItem);
			FlxG.overlap(Registry.player, Registry.exit, completeLevel);
				
			if (FlxG.overlap(Registry.player, Registry.hidingSpots))
			{
				Registry.player.canHide = true;
			}
			else
			{
				Registry.player.canHide = false;
			}
			
			
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
			
			/* check if dead */
			if (Registry.gameStats.health == 0 || Registry.gameStats.health < 0)
			{
				die();
			}
			
			super.update();
			
			/* for testing purposes only, remove later */
			if (FlxG.keys.justPressed("F"))
			{
				Registry.player.gotGoalItem = true;
				completeLevel(Registry.player, new Exit(0, 0));
			}
		}
		
		/////////////////////////////////////////
		// OVERLAP CALLBACKS
		/////////////////////////////////////////
		/* the player picks up the goal item */
		private function getGoalItem(player:Player, goalItem:GoalItem):void
		{
			FlxG.play(goalitemEffect, 0.5, false, true);
			player.gotGoalItem = true;
			goalItem.kill();
		}
		
		/* the player completes the level, if she has the goal item */
		private function completeLevel(player:Player, exit:Exit):void
		{
			if (player.gotGoalItem)
			{
				player.gotGoalItem = false;
				clearRegistry();
				FlxG.music.fadeOut(1);
				
				/* end the game if final level, otherwise go to next cutscene */
				switch (Registry.gameStats.level)
				{
					case 0:
						FlxG.switchState(new CutsceneState(CutsceneState.CUTSCENE1));
						break;
						
					case 1:
						FlxG.switchState(new CutsceneState(CutsceneState.CUTSCENE2));
						break;
						
					case 2:
						FlxG.switchState(new CutsceneState(CutsceneState.CUTSCENE3));
						break;
						
					case 3:
						FlxG.switchState(new CutsceneState(CutsceneState.CUTSCENE4));
						break;
						
					case 4:
						FlxG.switchState(new CutsceneState(CutsceneState.CUTSCENE5));
						break;
				}
				
				Registry.gameStats.level++;
			}
		}
		
		/* damage the player if she overlaps with a bullet */
		// TODO: set an invulnerability period
		private function damagePlayerBullet(player:Player, bullet:guardBullet):void
		{	
			/* damage the player if she is vulnerable, else do nothing */
			if (!Registry.player.isInvulnerable)
			{
				Registry.gameStats.damage(ENEMY_BULLET_DAMAGE);
				Registry.player.flinch(bullet);
				
				/* kill the bullet */
				bullet.exists = false;
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
			
			guards.clear();
			/* TEMPORARY */
			//remove(Registry.guard);
		}
		
		/* the player dies if she runs out of health */
		private function die():void
		{
			// TODO: do something else as well
			Registry.gameStats.health = Registry.gameStats.STARTING_LIFE;
			clearRegistry();
			FlxG.music.fadeOut(1);
			FlxG.switchState(new EndState());
		}
		
		//////////////////////////////////////////////////
		////// ENEMY COLLISION CONTROL ///////////////////
		//////////////////////////////////////////////////
		
		private function enemyCollisionControl():void
		{
		//have a variable that points to each guard (needed for collision control)
			for (var i:int = 0; i < guards.length; i++)
			{
				var tempGuard:Guard = guards.members[i];
				var tempSightRange:sightRanges = guardSightRanges.members[i];
				var tempSightRadius:guardSightRadius = guardSightRadii.members[i];
				
				if (tempGuard.facing == 0x0010)
				{
					tempSightRange.facing = 0x0010;
					
					tempSightRange.x = tempGuard.x + 100;
					tempSightRange.y = tempGuard.y;
				}
				else
				{
					tempSightRange.facing =  0x0001;
					tempSightRange.x = tempGuard.x - 320;
					tempSightRange.y = tempGuard.y;
				}
				
				if (tempGuard.getAlertLevel() == 0)
				{
					tempSightRange.alertLevel = 0;
				}
				else if (tempGuard.getAlertLevel() == 1)
				{
					tempSightRange.alertLevel = 1;
				}
				else
				{
					tempSightRange.alertLevel = 2;
				}
		
				//if the player ISN"T hiding, can SEE the player
				if (!Registry.player.isHiding())
				{
						FlxG.overlap(tempSightRange, Registry.player, tempGuard.seePlayer);
						FlxG.overlap(tempGuard, Registry.player, tempGuard.punchAnimation);	
						FlxG.overlap(tempGuard, Registry.player, tempGuard.startPunch);	
				}
			
				FlxG.overlap(tempGuard, Registry.tranqBulletHandler, tempGuard.tranqReaction);
				FlxG.overlap(tempGuard, Registry.smokeBombHandler.smokeCloudGroup, tempGuard.smokeBombReaction);
				FlxG.overlap(tempGuard, Registry.stunGrenadeHandler.stunExplosionGroup, tempGuard.stunGrenadeReaction);
				
				FlxG.overlap(tempGuard, Registry.noiseHandler, tempGuard.noiseAlert);
				
				if (!tempGuard.onLadder())
				{
					FlxG.collide(Registry.level, tempGuard);
				}
			}
		}
		
		private function cameraOverlapControl(sr:CameraSightRange, player:Player):void
		{
			//FlxG.play(alertEffect, 0.5, false, true);
			 	
			for (var i:int = 0; i < guards.length; i++)
			{
				var tempGuard:Guard = guards.members[i];
			//	tempGuard.alertAnimation();
				tempGuard.setAlertLevel(1);
			}	
		}
			
	}

}