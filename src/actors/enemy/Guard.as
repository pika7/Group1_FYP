	/* Guard Class
* Will be integrated into GuardGroup later
*/

package actors.enemy
{
	import actors.NoiseRadius;
	import actors.Player;
	import flash.display.Shape;
	import flash.sampler.NewObjectSample;
	import objs.Marker;
	import util.Registry;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import actors.enemy.guardBullet;
	import levels.*;
	import actors.enemy.invisibleNoiseTile;
	import weapons.SmokeBomb;
	import weapons.SmokeCloud;
	import weapons.StunExplosion;
	import weapons.StunGrenade;
	import weapons.TranqBullet;

public class Guard extends FlxSprite
{
	[Embed(source = '../../../assets/img/enemies/guard.png')] private var guardPNG:Class;
	[Embed(source = '../../../assets/soundeffect/enemies/punch.mp3')] private var shootSound:Class;
	[Embed(source = '../../../assets/soundeffect/enemies/alert.mp3')] private var alertSound:Class;
	[Embed(source = '../../../assets/soundeffect/enemies/search.mp3')] private var searchSound:Class;
	[Embed(source = '../../../assets/soundeffect/enemies/punch.mp3')] private var punchSound:Class;
	[Embed(source = '../../../assets/soundeffect/enemies/enemyhurt.mp3')] private var hurtSound:Class;
	[Embed(source = '../../../assets/soundeffect/enemies/confused.mp3')] private var confusedSound:Class;
	
	/* initialization of GUARD variables */
	private const GRAVITY:int = 600;
	private const levelZeroVelocity:Number = 100;
	private const levelOneVelocity:Number = 120;
	private const levelTwoVelocity:Number = 130;
	private const levelThreeVelocity:Number = 140;

	private var tempVelocity:int;
	private var xVelocity:Number;
	private var bullet:FlxSprite;
	private var currentBullet:FlxSprite;
	private var shootingNow:Boolean = false;
	private var lastLocation:FlxPoint = new FlxPoint(0, 0);
	private var climbing:Boolean = false;
	private var bulletCounter:Number = 0;
	private var noiseCounter:Number = 0;
	private var climbLadderPatrol:Boolean = false;
	private var noisePoint:FlxPoint = new FlxPoint;
	public var noiseDetected:Boolean = false;

	private var newNoiseDetected:Boolean = false;
	private var climbingDown:Boolean = false;
	private var ladderStopCounter:Number = 0;
	private var ladderStopCheck:Boolean = false;
	public var trackPath:Array;
	private var patrolPathClass:patrolPathList;
	private var alertLevel:int;
	private var stopCounter:Number = 0;
	private var punchStopCounter:Number = 0;
	private var bugStopCounter:Number = 0;

	private var bottomMarker:Marker;
	private var topMarker:Marker;
	private var tempBottomMarker:Marker;
	private var tempTopMarker:Marker;
	private var tempXSetMarker:Marker;

	private var goingUp:Boolean = false;
	private var goingDown:Boolean = false;

	private var needToClimbUp:Boolean = false;
	private var needToClimbDown:Boolean = false;
	private var needToLand:Boolean = false;

	private var bottomInPath:Boolean = false;
	private var topInPath:Boolean = false;

	private var bottomMarkerGroup:Array;
	private var topMarkerGroup:Array;
	private var stopMarkerGroup:Array;
	private var bottomMarkerInPathGroup:Array;
	private var topMarkerInPathGroup:Array;


	private var touchedBottomMarker:Boolean = false;
	private var touchedTopMarker:Boolean = false;


	private var XinTile:int = 0;
	private var YinTile:int = 0;
	private var tempPlayerPoint: FlxPoint = new FlxPoint(0, 0);
	private var bottomMarkerInPath:Boolean = false;
	private var topMarkerInPath:Boolean = false;
	private var minimumMarkerDistance:Number = 0;
	private var tempMarkerDistance:Number = 0;
	private var tempDestinationPoint: FlxPoint = new FlxPoint(0, 0);
	private var tempMarkerIndex:int = 0;
	private var bottomMarkerMovePoint:FlxPoint = new FlxPoint(0, 0);
	private var topMarkerMovePoint:FlxPoint = new FlxPoint(0, 0);
	private var tempEndPoint:FlxPoint = new FlxPoint(0, 0);
	private var tempEndDestinationPoint:FlxPoint = new FlxPoint(0, 0);
	private var tempStartDestinationPoint:FlxPoint = new FlxPoint(0, 0);
	private var startX:int;
	private var startY:int;
	private var endX:int;
	private var endY:int;
	private var inSightRange:Boolean = false;
	private var Mode:String = "";
	private var detected:Boolean = false;
	private var canSee:Boolean = false;
	private var touchedMarker:Boolean = false;
	private var pixelCounter:Number = 0;
	private var punchingNow:Boolean = false;

	private var patrolStartPointX:int;
	private var patrolStartPointY:int;
	private var patrolEndPointX:int;
	private var patrolEndPointY:int;

	private var pixelFarCounter:Number = 0;
	private var pixelCircleCounter:Number = 0;
	private var noiseSourceX:int;
	private var noiseSourceY:int;
	private var noiseReached:Boolean = false;
	private var noiseTile:invisibleNoiseTile;
	private var patrolStatus:String = "";
	private var patrolStatusBeforeNoise:String = "";
	private var sightDetectedClose:Boolean = false;
	private var sightDetectedFar:Boolean = false;
	private var backFromOtherStatus:Boolean = false;

	private var patrolPathCreated:Boolean = false;
	private var startedPatrol:Boolean = false;
	private var stopMarkerPoint:FlxPoint = new FlxPoint(0, 0);
	private var goBackToOriginalPlace:Boolean = false;
	private var goBackToPathPoint:FlxPoint = new FlxPoint(0, 0);
	private var patrolStartToEnd:Boolean = false;
	private var tempSeenFarPoint:FlxPoint = new FlxPoint(0, 0);

	private var noiseDetectedFirstTime:Boolean = false;
	private var seenFarFirstTime:Boolean = false;
	private var sightRadius:guardSightRadius ;
	private var bottomMarkerNeedUpPathGroup:Array;
	private var bottomMarkerNeedDownPathGroup:Array;
	private var topMarkerNeedUpPathGroup:Array;
	private var topMarkerNeedDownPathGroup:Array;
	private var pointsToFollow:Array;

	private var PrevPt:FlxPoint = new FlxPoint(0, 0);
	private var tempPt:FlxPoint = new FlxPoint(0,0);
	private var tempNextPt:FlxPoint = new FlxPoint(0,0);
	private var targetPoint:FlxPoint = new FlxPoint(0, 0);
	private var superTempPt:FlxPoint = new FlxPoint(0, 0);
	private var circleTempPoint:FlxPoint = new FlxPoint(0, 0);
	private var reachedTheEnd:Boolean = false;
	private var reachedTheStart:Boolean = false;
	private var movingLeft:Boolean = false;
	private var goBackPatrol:Boolean = false;
	private var noiseCanBeDetected:Boolean = true;
	private var stopped:Boolean = false;
	private var seenClose:Boolean = false;
	public var radiusChange:Boolean = false;
	private var circleDetected:Boolean = false;
	private var alertLevelTimer:Number = 0;
	private var alertLevelChangedTo2:Boolean = false;
	private var tranqCounter:Number = 0;
	private var StunGCounter:Number = 0;
	private var SmokeBombOverallCounter:Number = 0;
	private var SmokeBombLeftCounter:Number = 0;
	private var SmokeBombRightCounter:Number = 0;
	private var froze:Boolean = false;
	private var confused:Boolean = false;
			
	/* constructor */
	public function Guard(X:int, Y:int, patrolStartX:int, patrolStartY:int, patrolEndX:int, patrolEndY:int)
	{
		super(X, Y);
		loadGraphic(guardPNG, true, true, 32, 128, true);
		width = 32;
		height = 128;

		/* sprite speed initialization*/
		acceleration.y = GRAVITY;

		/* sprite animations */
		addAnimation("walk", [0,1], 5, true);
		addAnimation("shoot", [2], 0, false);
		addAnimation("alert", [3], 0, false);
		addAnimation("alertWalk", [4, 5], 2, true);
		addAnimation("search", [6], 0, false);
		addAnimation("Punch", [7], 5, false);
		addAnimation("climb", [8, 9], 2, true);

		/*other sprite properties*/
		facing = RIGHT;	
		initializeBullets();

		/* set the initial mode */
		Mode = "Normal";
		//will change to getter method later

		alertLevel = 0;

		/* pathfinding stuff */
		patrolPathClass = new patrolPathList();

		noiseTile = new invisibleNoiseTile(0, 0);
		sightRadius = new guardSightRadius(0,0);

		patrolStartPointX = patrolStartX;
		patrolStartPointY = patrolStartY;
		patrolEndPointX = patrolEndX;
		patrolEndPointY = patrolEndY;
  }	

	/* for following the created path*/
	/* will only go for top/bottom ladder marker positions if enemies are above/below */

	public function followThePath():void	
	{	
		//initialize arrays
		bottomMarkerInPathGroup = [];
		topMarkerInPathGroup = [];
		bottomMarkerNeedUpPathGroup = [];
		bottomMarkerNeedDownPathGroup = [];
		topMarkerNeedUpPathGroup = [];
		topMarkerNeedDownPathGroup = [];
		pointsToFollow = [];

		//reset marker booleans
		bottomMarkerInPath = false;
		topMarkerInPath = false;

		//store start point
		tempStartDestinationPoint.x = patrolPathClass.startNode.x;
		tempStartDestinationPoint.y = patrolPathClass.startNode.y;
		tempEndDestinationPoint.x = patrolPathClass.endNode.x;
		tempEndDestinationPoint.y = patrolPathClass.endNode.y;

		pointsToFollow.push(tempStartDestinationPoint);


		if (trackPath.length == 1)
		{
			tempPt = trackPath[0];
			pointsToFollow.push(tempPt);
		}
		else
		{
			//check the coordinates in trackpath array
			for (var i:int = 0; i < trackPath.length; i++)
			{
				//check for coordinates
				if((i==0) && (i+1 < trackPath.length))
				{
					PrevPt = tempStartDestinationPoint;
					tempPt = trackPath[i];
					tempNextPt = trackPath[i + 1];
				}	
				else if ((i > 0) && (i + 1 < trackPath.length))
				{
					PrevPt = trackPath[i - 1];
					tempPt = trackPath[i];
					tempNextPt = trackPath[i + 1];
				}
				if (((tempPt.x == (PrevPt.x+1)) && (tempNextPt.y ==(tempPt.y - 1)) && (tempNextPt.x == tempPt.x) && (tempPt.y ==PrevPt.y) ) || ((tempPt.x == (PrevPt.x - 1)) && (tempNextPt.y ==(tempPt.y - 1)) &&(tempNextPt.x ==tempPt.x) && (tempPt.y ==PrevPt.y)))
				{
					bottomMarkerNeedUpPathGroup.push(tempPt);
					pointsToFollow.push(tempPt);
				}
				else if (((tempPt.x == PrevPt.x) && (tempPt.y == PrevPt.y + 1) && (tempNextPt.x == tempPt.x + 1) && (tempNextPt.y == tempPt.y) ) || ((tempPt.x == PrevPt.x) && (tempPt.y == PrevPt.y + 1) && (tempNextPt.x == tempPt.x - 1) && (tempNextPt.y == tempPt.y)) )
				{	
					bottomMarkerNeedDownPathGroup.push(tempPt);
					pointsToFollow.push(tempPt);
				}
				else if (((tempPt.x == PrevPt.x) && (tempPt.y == PrevPt.y - 1) && (tempNextPt.x == tempPt.x + 1) && (tempNextPt.y == tempPt.y) ) || ((tempPt.x == PrevPt.x) && (tempPt.y == PrevPt.y - 1) && (tempNextPt.x == tempPt.x - 1) && (tempNextPt.y == tempPt.y)))
				{
					topMarkerNeedUpPathGroup.push(tempPt);
					pointsToFollow.push(tempPt);
				}
				else if (((tempPt.x == PrevPt.x+1) && (tempPt.y == PrevPt.y) && (tempNextPt.x == tempPt.x) && (tempNextPt.y == tempPt.y + 1)) || ((tempPt.x == PrevPt.x -1) && (tempPt.y == PrevPt.y) && (tempNextPt.x == tempPt.x) && (tempNextPt.y == tempPt.y + 1)))
				{
					topMarkerNeedDownPathGroup.push(tempPt);
					pointsToFollow.push(tempPt);
				}
			}

		}
		pointsToFollow.push(tempEndDestinationPoint);
	}

	public function startFollowing():void
	{
	
		var xInTiles:int = int(x / 32);
		var yInTiles:int = int((y + 100) / 32);

		tempPt = pointsToFollow[0];
		
		if (((yInTiles == tempPt.y) && (xInTiles==tempPt.x)))
		{
			acceleration.y = 0;
			velocity.y = 0;
			velocity.x = 0;
			pointsToFollow.splice(0, 1);
		}
		else if (((yInTiles == tempPt.y) && ((xInTiles < tempPt.x)))) //need to move right
		{
			movingLeft = false;
			if (climbing == true)
			{
				play("walk");
				y = y - 30;
				climbing = false;	
				acceleration.y = GRAVITY;
			}
			velocity.x = xVelocity;
			acceleration.y = GRAVITY;
		}	
		else if (((yInTiles == tempPt.y) && ((xInTiles > tempPt.x)))) //need to move left
		{		
			facing = LEFT;
			movingLeft = true;
			if (climbing == true)
			{
				play("walk");
				y = y - 30;
				climbing = false;
				acceleration.y = GRAVITY;
			}
			velocity.x = -xVelocity;
			acceleration.y = GRAVITY;
		}
		else if (yInTiles < tempPt.y && (xInTiles == tempPt.x))
		{
			if (movingLeft == true)
			{
				if (climbing == false)
				{
					play("walk");
					x = x - 32;
					facing = RIGHT;
					velocity.x = xVelocity;
					movingLeft = false;
				}	
			}
			else
			{
				play("climb");
				velocity.x = 0;
				velocity.y = xVelocity / 2;
				climbing = true;
				acceleration.y = 0;
			}
	}
	else if (yInTiles > tempPt.y && (xInTiles == tempPt.x))
	{
		if (movingLeft == true)
		{
			if (climbing == false)
			{
				x = x - 32;
				velocity.x = xVelocity;
				movingLeft = false;
			}	
		}
		else 
		{		
			play("climb");
			velocity.x = 0;
			velocity.y = - xVelocity / 2;
			climbing = true;
			acceleration.y = 0;	
		}
	}

	}


	public function getAlertLevel():int
	{
		return alertLevel;
	}


	/* play alert animation if noise is detected */
	/* start following the player */
	/* getNoiseType() = 0 : player
	 * getNoiseType() = 1 : tranquilizer bullet
	 * getNoiseType() = 2 : stun grenade
	 */ 
	
	public function noiseAlert(guard:Guard, noise:NoiseRadius):void
	{
		/* no need to check for noise if already seen */
		( (Mode != "seenFar" || Mode != "seenClose"|| Mode!="seenFarCheck" || Mode != "circleFollow" || Mode != "StunG" || Mode!= "SmokeBomb") )
		{
			if (froze == false)
			{
			newNoiseDetected = true;
			Mode = "noiseDetected";
			patrolStatusBeforeNoise = patrolStatus;
			if (noiseDetectedFirstTime == false)
			{
				goBackToPathPoint.x = x;
				goBackToPathPoint.y = y + 100;
				noiseDetectedFirstTime = true;
			}
			noiseFace();
			play("alertWalk");
		FlxG.play(alertSound, 0.2, false, true);
			
		//get the path coordinates in array
		startX = x;
		startY = y + 100;
		
		if(noise.getNoiseType() == 0)
		{
			endX = Registry.player.x;
			endY = Registry.player.y + 100;	
		}
		else if (noise.getNoiseType() == 1)
		{
			endX = Registry.noiseCoord.x;
			endY = Registry.noiseCoord.y + 100;
		}
		else if (noise.getNoiseType() == 2)
		{
			endX = Registry.stunNoiseCoord.x;
			endY = Registry.stunNoiseCoord.y + 100;
		}
		
		/* initialize noisetile */
		noiseTile.x = int(endX / Registry.TILESIZE);
		noiseTile.y = int(endY / Registry.TILESIZE);
		noiseTile.exists = true;

		}
		}
	}

	/* different facing depending on noise coordinates */
	private function noiseFace():void
	{
		if (Mode == "noiseDetected")	
		{	
			if (Registry.player.x > x)
			{
				facing = RIGHT;
			}	
			else
			{
				facing = LEFT;
			}
		}
	}	

	/* changes velocity according to alertLevel
	 * AND checks if the goalitem is taken
	 * */	
	
	private function setVelocity():void
	{
		if (Registry.player.gotGoalItem == true)
		{
			alertLevel =  3;
		}
		switch(alertLevel)
		{
			case 0:
				xVelocity = levelZeroVelocity;
				break;
			case 1:
				xVelocity = levelOneVelocity;
				break;
			case 2:
				xVelocity = levelTwoVelocity;
				break;
			case 3:
				xVelocity = levelThreeVelocity;
				break;
		}	
	}	

	/* creation of bullets for use */
	private function initializeBullets():void
	{
		shootingNow = false;
		for (var i:int = 0; i < 10; i++)
		{
			bullet = new guardBullet;
			bullet.exists = false;	
			Registry.bulletGroup.add(bullet);
		}
	}	
	

	/* function for checking if the guard is currently climibing or not */
	public function onLadder():Boolean
	{
		return climbing;
	}

	/* Allows guard to climb the ladder when reached the bottom */	
	/*Always use this function to trigger the marker bottom = true"*/
	public function handleLadderBottom(guard:Guard, marker:Marker):void
	{
		tempXSetMarker = marker;
		tempBottomMarker = marker;
		touchedBottomMarker = true;
	}

	/* Allows guard to stop climbing the ladder when reached the top */
	/* always use this marker when top marker ==true"*/
	public function handleLadderTop(guard:Guard, marker:Marker):void
	{
		tempXSetMarker = marker;
		tempTopMarker = marker;
		touchedTopMarker = true;
	}

	/*shooting function */
	private function shootPlayer():void	
	{	
		if (Mode == "Shooting" && shootingNow == false)
		{
			velocity.x = 0;
			velocity.y = 0;
			checkFacing();
			tempVelocity = velocity.x;
			currentBullet = Registry.bulletGroup.getFirstAvailable() as FlxSprite;	
			play("shoot");	
			FlxG.play(shootSound, 0.5, false, true);
			shootingNow = true;
			currentBullet.x = x;
			currentBullet.y = y;
			currentBullet.exists = true;
			tempPlayerPoint.x = Registry.player.x;
			tempPlayerPoint.y = Registry.player.y + 50;
			//FlxVelocity.moveTowardsObject(currentBullet, Registry.player, 200);	
			FlxVelocity.moveTowardsPoint(currentBullet, tempPlayerPoint, 200, 0);
		}
	}	

	/*check bullet counter */
	public function bulletCounterCheck():void
	{
		if (shootingNow == true)
		{
			bulletCounter += FlxG.elapsed;
			if (bulletCounter > 2)
			{
				shootingNow = false;
				goBackPatrol = true;
				checkFacing();
				
				trackPath = patrolPathClass.getPath(x, y+100, tempSeenFarPoint.x, tempSeenFarPoint.y);
				followThePath();
				Mode = "seenCloseFollowing";
				
				bulletCounter = 0;
			}
		}
	}
	
	/* punching function */
	private function punchingPlayer():void	
	{	
		if (Mode == "Punching" && punchingNow == false)
		{
			
			velocity.x = 0;
			velocity.y = 0;
			checkFacing();
			tempVelocity = velocity.x;
			
			punchingNow = true;
		}
	}	
	public function punchAnimation(g:Guard, p:Player):void
	{
		
		play("Punch");
		FlxG.play(punchSound, 0.5, false, true);
	}
	
	/*check bullet counter */
	public function punchCounterCheck():void
	{
		if (punchingNow == true && (!Registry.player.isHiding()))
		{
			
			punchStopCounter += FlxG.elapsed; 
			if (punchStopCounter > 2)
			{
				Registry.gameStats.damage(10);
				punchingNow = false;
				goBackPatrol = true;
				checkFacing();
				
				trackPath = patrolPathClass.getPath(x, y+100, tempSeenFarPoint.x, tempSeenFarPoint.y);
				followThePath();
				Mode = "seenCloseFollowing";
				
				punchStopCounter = 0;
			}
		}
	}
	
	/* initiate punching */
	public function startPunch(g:Guard, p:Player):void
	{
		punchStopCounter += FlxG.elapsed;
		if (punchStopCounter > 2)
		{
			play("Punch");
			Registry.gameStats.damage(5);
			checkFacing();
			punchStopCounter = 0;
		}
		
	}

	/* guard sees player if in close sight range */
	/* If guard detects player on the floor  */
	public function seePlayer(sightrange:sightRanges, player:Player):void
	{
		{
			if(Mode != "circleFollow" && Mode!= "SmokeBomb") 
			{
				if (FlxCollision.pixelPerfectCheck(sightrange, player))	
				{
					if (Registry.player.isHangingOnHookshot == true || alertLevel == 3)
					{
						Mode = "Shooting";
						tempSeenFarPoint.x = Registry.player.x;
						tempSeenFarPoint.y = Registry.player.y +100;
						patrolStatusBeforeNoise = patrolStatus;
					}
					else
					{
						Mode = "seenClose";
						tempSeenFarPoint.x = Registry.player.x;
						tempSeenFarPoint.y = Registry.player.y +100;
						pixelCounter = 0;
						patrolStatusBeforeNoise = patrolStatus;
						seenClose = true;				
					}
				}
			}
		}	
	}
	
	/* guard detects player if in circle sight range */
	public function circleDetect(circle:guardSightRadius, player:Player):void
	{
		//pixelCircleCounter += FlxG.elapsed;
		//if (pixelCircleCounter > 1) //check it every 1 frame
		{
			if (FlxCollision.pixelPerfectCheck(circle, player))	
			{
				if (Registry.player.isHangingOnHookshot == true || alertLevel == 3)
				{
					Mode = "Shooting";
				}
				else
				{
					circleTempPoint.x = Registry.player.x;
					circleTempPoint.y = Registry.player.y +100;
					Mode = "circleFollow";
					pixelCircleCounter = 0;
				}
			}
		}	
		
	}
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////// WEAPON REACTION   ///////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	
	/* tranquilizer reaction */
	public function tranqReaction(guard:Guard, tranqb:TranqBullet):void
	{
		Mode = "Tranq";
		flicker(2);
		patrolStatusBeforeNoise = patrolStatus;
		FlxG.play( hurtSound, 0.5, false, true);
		tranqb.kill();
	}
	
	/* smokeBomb reaction */
	public function smokeBombReaction(guard:Guard, smokeC:SmokeCloud):void
	{
		confused = true;
		FlxG.play(confusedSound, 0.5, false, true);
		Mode = "SmokeBomb";
		patrolStatusBeforeNoise = patrolStatus;
	}
	
	public function alertAnimation():void
	{
		play("Alert");
	
	}
	
	
	/* stun grenade Reaction */
	public function stunGrenadeReaction(guard:Guard, stunE:StunExplosion):void
	{
		froze = true;
		FlxG.play( hurtSound, 0.5, false, true);
		Mode = "StunG";
		flicker(4);
		patrolStatusBeforeNoise = patrolStatus;
		
	}
	
	public function checkFacing():void
	{
		if (Registry.player.x< x)
		{
			facing = LEFT;
		}
		else
		{
			facing = RIGHT;
		}
		
	}

	/* check the mode and make the guard act accoridngly */
	public function checkMode():void
	{
		var xInTiles:int = (x / 32);
		var yInTiles:int = ((y + 100) / 32);

		if (Mode == "Normal")
		{	
			froze = false;
			play("walk");
			var patrolEndPointXInTiles:int = patrolEndPointX / 32;
			var patrolEndPointYInTiles:int = patrolEndPointY / 32;
			var patrolStartPointXInTiles:int = patrolStartPointX / 32;
			var patrolStartPointYInTiles:int = patrolStartPointY / 32;
			radiusChange = false;
			
			//create patrol Path for the first time
			if (justTouched(FLOOR) && patrolPathCreated == false && startedPatrol == false)
			{	
				trackPath = patrolPathClass.getPath(patrolStartPointX, patrolStartPointY , patrolEndPointX, patrolEndPointY);
				followThePath();
				Mode = "Patrolling";
				startedPatrol = true;
				patrolStatus = "toEndPoint";
				facing = RIGHT;
			}		
			else if (startedPatrol == true && (patrolEndPointXInTiles == xInTiles) && (patrolEndPointYInTiles==yInTiles) && patrolStatus=="toEndPoint")
			{
				stopCounter += FlxG.elapsed;
				velocity.x = 0;
				if (stopCounter > 2)
				{	
					trackPath = patrolPathClass.getPath(patrolEndPointX, patrolEndPointY , patrolStartPointX, patrolStartPointY);
					followThePath();
					Mode = "Patrolling";
					patrolStatus = "toStartPoint";
					stopCounter = 0;
					facing = LEFT;
				}
			}
			else if (startedPatrol == true && (patrolStartPointXInTiles == xInTiles) && (patrolStartPointYInTiles==yInTiles) && patrolStatus=="toStartPoint")
			{
				stopCounter += FlxG.elapsed;
				velocity.x = 0;
				if (stopCounter > 2)
				{	
					trackPath = patrolPathClass.getPath(patrolStartPointX, patrolStartPointY , patrolEndPointX, patrolEndPointY);
					followThePath();
					Mode = "Patrolling";
					patrolStatus = "toEndPoint";
					stopCounter = 0;
					facing = RIGHT;
				}
			}
			else if (goBackPatrol == true) 
			{
				radiusChange = false;
			
				if (patrolStatusBeforeNoise == "toEndPoint")
				{
					
					goBackPatrol = false;
					trackPath = patrolPathClass.getPath(x, y + 100, patrolEndPointX, patrolEndPointY);
					followThePath();
					facing = RIGHT;
					Mode = "Patrolling";
				}
				if (patrolStatusBeforeNoise == "toStartPoint")
				{
					
					goBackPatrol = false;
					trackPath = patrolPathClass.getPath(x, y+100, patrolStartPointX, patrolStartPointY);
					followThePath();
					facing = LEFT;
					Mode = "Patrolling";
				}	
			}
		}
		else if (Mode == "Patrolling")
		{
			if (pointsToFollow.length > 0)
			{
				startFollowing();
			
			}
			if (pointsToFollow.length == 0)
			{
				Mode = "Normal";
			}	
		}
		else if (Mode == "noiseDetected")
		{
			trackPath = patrolPathClass.getPath(startX, startY, noiseTile.x * Registry.TILESIZE, noiseTile.y * Registry.TILESIZE);
			followThePath();
			Mode = "noiseFollowing";
		}
		else if (Mode == "noiseFollowing")
		{
			if (pointsToFollow.length > 0)
			{
				
				startFollowing();
			}
			if (pointsToFollow.length == 0)
			{
				play("search");
				FlxG.play(searchSound, 0.5, false, true);
				checkFacing();
				stopCounter += FlxG.elapsed;
		
				if (stopCounter > 2)
				{	
					goBackPatrol = true;
					stopCounter = 0;
					if (alertLevel != 3)
					{
						alertLevel = 1;
					}
					Mode = "Normal";
				}	
			}
		}
		else if (Mode == "seenClose")
		{
			
			/* guard alert changes to circle */
			radiusChange = true;
			trackPath = patrolPathClass.getPath(x, y+100, tempSeenFarPoint.x, tempSeenFarPoint.y);
			followThePath();
			Mode = "seenCloseFollowing";
		}
		
		else if (Mode == "seenCloseFollowing")
		{
				if (pointsToFollow.length > 0)
				{
					startFollowing();
				}
				if (pointsToFollow.length == 0)
				{
					play("search");
					FlxG.play(searchSound, 0.5, false, true);
					checkFacing();
					stopCounter += FlxG.elapsed;
					
					if (stopCounter > 2)
					{	
						goBackPatrol = true;
						stopCounter = 0;	
						if (alertLevel != 3)
						{
							alertLevel = 2;
						}
						Mode = "Normal";
					}	
				}	
		}
		else if (Mode == "circleFollow")
		{
			
			trackPath = patrolPathClass.getPath(x, y+100, circleTempPoint.x, circleTempPoint.y);
			followThePath();
			Mode = "circleFollowing";
			
		}
		else if (Mode == "circleFollowing")
		{
				if (pointsToFollow.length > 0)
				{
					startFollowing();
				}
				if (pointsToFollow.length == 0)
				{
				//	play("search");
					checkFacing();
					stopCounter += FlxG.elapsed;
		
					if (stopCounter > 2)
					{	
						goBackPatrol = true;
						stopCounter = 0;	
					if (alertLevel != 3)
					{
						alertLevel = 2;
					}
						Mode = "Normal";
					}	
				}	
		}
		else if (Mode == "Shooting")
		{
			if (froze == false)
			{
				shootPlayer();
			}
		}
		else if (Mode == "Punching")
		{
			
			punchingPlayer();
		}
		else if (Mode == "Tranq")
		{
			velocity.x = 0;
			velocity.y = 0;
			tranqCounter += FlxG.elapsed; 
			
			if (tranqCounter  > 2)
			{	
				goBackPatrol = true;
				tranqCounter  = 0;	
				if (alertLevel != 3)
				{
					alertLevel = 2;
				}
				froze = false;
				Mode = "Normal";
			}	
		}
		else if (Mode == "StunG")
		{
			velocity.x = 0;
			velocity.y = 0;
			StunGCounter += FlxG.elapsed; 
			froze = true;
			if (StunGCounter  > 4)
			{	
				goBackPatrol = true;
				StunGCounter = 0;	
				if (alertLevel != 3)
				{
					alertLevel = 2;
				}
				froze = false;
				Mode = "Normal";
			}	
		}
		else if (Mode == "SmokeBomb")
		{
	
			velocity.y = 0;
			SmokeBombOverallCounter += FlxG.elapsed; 
			SmokeBombLeftCounter += FlxG.elapsed;
			if (SmokeBombLeftCounter > 1)
			{
				velocity.x = -velocity.x;
				checkSmokeFacing();
				SmokeBombRightCounter += FlxG.elapsed;
				SmokeBombLeftCounter = 0;
			}
			if (SmokeBombRightCounter > 1)
			{
				velocity.x = -velocity.x;
				checkSmokeFacing();
				SmokeBombLeftCounter = FlxG.elapsed;
				SmokeBombRightCounter = 0;
			}
			if (SmokeBombOverallCounter  > 4)
			{	
				goBackPatrol = true;
				SmokeBombOverallCounter = 0;	
				if (alertLevel != 3)
				{
					alertLevel = 2;
				}
				confused = false; 
				Mode = "Normal";
			}		
		}
	}
	
	public function checkSmokeFacing():void
	{
		
		if (Registry.player.x < x)
		{
			facing = LEFT;
		}
		else
		{
			facing = RIGHT;
		}
	}
	

	/* reset Alertlevel to 0 */
	public function alertLevelReset():void
	{
		if (alertLevelChangedTo2 == true)
		{
			alertLevelTimer = 0;
		}		
	}
	
	

	/* update function */
	override public function update():void
	{	
		setVelocity();	
		bulletCounterCheck();
		alertLevelReset();
		checkMode();
	//	checkFacing();
		super.update();	
	}
	
	public function setAlertLevel(level:int):void
	{
		alertLevel = level;
	}



}

}