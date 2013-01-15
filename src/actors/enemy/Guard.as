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

public class Guard extends FlxSprite
{
	[Embed(source = '../../../assets/img/enemies/guardtemp.png')] private var guardPNG:Class;

	/* initialization of variables */
	private const GRAVITY:int = 600;
	private const levelZeroVelocity:Number = 100;
	private const levelOneVelocity:Number = 200;
	private const levelTwoVelocity:Number = 300;

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

	private var patrolStartPointX:int;
	private var patrolStartPointY:int;
	private var patrolEndPointX:int;
	private var patrolEndPointY:int;

	private var pixelFarCounter:Number = 0;
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
	private var reachedTheEnd:Boolean = false;
	private var reachedTheStart:Boolean = false;
	private var movingLeft:Boolean = false;

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
		addAnimation("walk", [0], 0, false);
		addAnimation("shoot", [0], 0, false);
		addAnimation("alert", [0], 0, false);
		addAnimation("search", [0], 0, false);

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
		tempStartDestinationPoint.x = Registry.guardStartPoint.x;
		tempStartDestinationPoint.y = Registry.guardStartPoint.y;
		tempEndDestinationPoint.x = Registry.guardEndPoint.x;
		tempEndDestinationPoint.y = Registry.guardEndPoint.y;

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
					x = x - 32;
					facing = RIGHT;
					velocity.x = xVelocity;
					movingLeft = false;
				}	
			}
			else
			{
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
	public function noiseAlert(guard:Guard, noise:NoiseRadius):void
	{
		/* no need to check for noise if already seen */
		if (Mode != "seenFar" || Mode != "seenClose"|| Mode!="seenFarCheck")
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
			play("alert");

		//get the path coordinates in array
		startX = Registry.guard.x;
		startY = Registry.guard.y + 100;
		endX = Registry.player.x;
		endY = Registry.player.y + 100;	

		/* initialize noisetile */
		noiseTile.x = int(endX / Registry.TILESIZE);
		noiseTile.y = int(endY / Registry.TILESIZE);
		noiseTile.exists = true;

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

	/* changes velocity according to alertLevel*/
	private function setVelocity():void
	{
		switch(alertLevel)
		{
			case 0:
				xVelocity = levelZeroVelocity;
				break;
			case 1:
				xVelocity = levelOneVelocity/2;
				break;
			case 2:
				xVelocity = levelTwoVelocity/4;
				break;
		}	
	}	

	/* creation of bullets for use */
	private function initializeBullets():void
	{
		for (var i:int = 0; i < 10; i++)
		{
			bullet = new guardBullet;
			bullet.exists = false;	
			Registry.bulletGroup.add(bullet);
		}
	}	
	
	/* check if the player is in sight range */
	public function checkIsDetected():void
	{
		if (detected==true)
		{
			if (inSightRange == true)
			{
				FlxVelocity.moveTowardsObject(this, Registry.player, xVelocity);
				velocity.y = 0;
				inSightRange = false;
			}
			shootPlayer();
			Mode = "Shooting";
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
		if (Mode=="Shooting" && shootingNow==false)
		{
			velocity.x = 0;
			tempVelocity = velocity.x;
			currentBullet = Registry.bulletGroup.getFirstAvailable() as FlxSprite;	
			play("shoot");	
			shootingNow = true;
			currentBullet.x = x + 100;
			currentBullet.y = y + 50;
			currentBullet.exists = true;
			FlxVelocity.moveTowardsObject(currentBullet, Registry.player, xVelocity);	
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
				Mode = "Normal";
				bulletCounter = 0;
				detected = false;
				inSightRange = true;
			}
		}
	}


	/* guard sees player if in close sight range */
	public function seePlayer(sightrange:sightRanges, player:Player):void
	{
		pixelCounter += FlxG.elapsed;
		if (pixelCounter > 1) //check it every 1 frame
		{
			if (FlxCollision.pixelPerfectCheck(sightrange, player))	
			{
				Mode = "seenClose";
				pixelCounter = 0;
			}
		}	
	}

	/* guard sees the player if in far sight range */
	public function seePlayerFar(sightrangeFar:sightRangesFar, player:Player):void
	{	
		pixelFarCounter += FlxG.elapsed;
		{
			if (pixelFarCounter > 1)
			{
				if (FlxCollision.pixelPerfectCheck(sightrangeFar, player))	
				{
					if (seenFarFirstTime == false)
					{	
						goBackToPathPoint.x = x;
						goBackToPathPoint.y = y + 100;
						seenFarFirstTime = true;
					}
			tempSeenFarPoint.x = Registry.player.x;
			tempSeenFarPoint.y = Registry.player.y +100;
			Mode = "seenFar";
			sightDetectedFar = true;
			pixelFarCounter = 0;
				}
			}
		}
	}

	public function checkFacing():void
	{
		if (velocity.x < 0)
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
			play("walk");
			var patrolEndPointXInTiles:int = patrolEndPointX / 32;
			var patrolEndPointYInTiles:int = patrolEndPointY / 32;
			var patrolStartPointXInTiles:int = patrolStartPointX / 32;
			var patrolStartPointYInTiles:int = patrolStartPointY / 32;

		//create patrol Path for the first time
		if (justTouched(FLOOR) && patrolPathCreated == false && startedPatrol == false)
		{	
			trackPath = patrolPathClass.getPath(patrolStartPointX, patrolStartPointY , patrolEndPointX, patrolEndPointY);
			followThePath();
			Mode = "Patrolling";
			startedPatrol = true;
			patrolStatus = "toEndPoint";
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
			}
		}
	}

	/* update function */
	override public function update():void
	{	
		setVelocity();	
		bulletCounterCheck();
		checkMode();
		checkFacing();
		super.update();	
	}




}

}