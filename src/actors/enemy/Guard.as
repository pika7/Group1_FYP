/*  Guard Class
 *  Will be integrated into GuardGroup later
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
		[Embed(source = '../../../assets/img/enemies/guard.png')] private var guardPNG:Class;
		
		/* initialization of variables */
		private const GRAVITY:int = 600;
		private const levelZeroVelocity:Number = 100;
		private const levelOneVelocity:Number = 200;
		private const levelTwoVelocity:Number = 300;
		
		private var stopDelay:FlxDelay = new FlxDelay(2000);
		private var tempVelocity:int;
		private var xVelocity:Number;
		private var bullet:FlxSprite;
		private var currentBullet:FlxSprite;
		private var bulletDelay:FlxDelay = new FlxDelay(1500);
		private var shootingNow:Boolean = false;
		private var lastLocation:FlxPoint = new FlxPoint(0, 0);
		private var stoppingNow:Boolean = false;
		private var sightRangeGraphic:FlxSprite;
		private var climbing:Boolean = false;
		private var canClimb:Boolean = false;
		private var bulletCounter:Number = 0;
		private var noiseCounter:Number = 0;
		private var climbLadderPatrol:Boolean = false; 
		private var noisePoint:FlxPoint = new FlxPoint;
		public var noiseDetected:Boolean = false;
		private var climbingDown:Boolean = false;
		private var ladderStopCounter:Number = 0;
		private var ladderStopCheck:Boolean = false;
		public var trackPath:Array;
		private var patrolPathClass:patrolPathList;
		public var climbDown:Boolean = false;
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
		
		private var checkNum:int = 0;
		
		private var XinTile:int = 0;
		private var YinTile:int = 0;
		
		
		private var prevpt:FlxPoint = new FlxPoint(0,0);
		private var travelpt:FlxPoint = new FlxPoint(0, 0);
		
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
		
		
		private var noiseSourceX:int;
		private var noiseSourceY:int;
		private var noiseReached:Boolean = false;
		private var noiseTile:invisibleNoiseTile;
		
		private var patrolPathCreated:Boolean = false;
		private var startedPatrol:Boolean = false;
		private var stopMarkerPoint:FlxPoint = new FlxPoint(0, 0);
		private var goBackToOriginalPlace:Boolean = false;
		private var goBackToPathPoint:FlxPoint = new FlxPoint(0, 0);
		
		
		private var noiseDetectedFirstTime:Boolean = false;
		
		/* constructor */
		public function Guard(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(guardPNG, true, true, 128, 128, true);
			width = 128;
			height = 128;
			
			/* sprite speed initialization*/
			acceleration.y = GRAVITY;
			velocity.x = levelZeroVelocity / 2;
			/* sprite animations */
			addAnimation("walk", [0], 0, false);
			addAnimation("shoot", [1], 0, false);
			addAnimation("alert", [2], 0, false);
			addAnimation("search", [3], 0, false);
			
			/*other sprite properties*/
			facing = RIGHT;	
			initializeBullets();
			
			/* set the initial mode */
			Mode = "Normal";
			//will change to getter method later
			
			alertLevel = 0;
			
			/* pathfinding stuff */
			patrolPathClass = new patrolPathList();
			travelpt = new FlxPoint(0, 0);
			loadMarkers();
			
			noiseTile = new invisibleNoiseTile(0, 0);
			
			/*patrol route coordinates */
			patrolStartPointX = 48;
			patrolStartPointY = 657;
			patrolEndPointX = 974;
			patrolEndPointY = 337;
			
 		}
		
		public function noiseFinallyReached():void
		{
		//	trace("executed");
			noiseReached = true;
		}
		
		
		public function followThePath():void
		{	
				bottomMarkerInPathGroup = [];
				topMarkerInPathGroup = [];
		
				//reset marker booleans
				bottomMarkerInPath = false;
				topMarkerInPath = false;
			
				//check markers
				checkMarkers(trackPath);	
		
				//store the endpoint
				tempEndDestinationPoint.x = Registry.guardEndPoint.x * Registry.TILESIZE;
				tempEndDestinationPoint.y = Registry.guardEndPoint.y * Registry.TILESIZE;
			
		if (isTouching(FLOOR))  //case when noise is detected on floor
		{	
				var temppt:FlxPoint;
				var anotherTempPt:FlxPoint;
				var markerTempPt:FlxPoint;			 

				//NEED TO GO UP - 
				if (Registry.guardLadderDirection == "UP")
				{
					minimumMarkerDistance = 0;
					
					//get the marker position with minimum distance from the endpoint so we can choose to climb that marker
					if (bottomMarkerInPath == true)
					{
						//search for the marker position IN that path
						if (touchedBottomMarker == false)
						{	
							//find the closest marker first so you can move there
							for (var mIndex:int = 0; mIndex < bottomMarkerInPathGroup.length; mIndex++)
							{	
								markerTempPt = bottomMarkerInPathGroup[mIndex];
								if (mIndex == 0)
								{
									minimumMarkerDistance = Math.abs(Math.sqrt(((markerTempPt.x - tempDestinationPoint.x) * (markerTempPt.x - tempDestinationPoint.x)) + ((markerTempPt.y - tempDestinationPoint.y) * (markerTempPt.y - tempDestinationPoint.y)))); 
									tempMarkerDistance = minimumMarkerDistance;
								}
								else
								{
									tempMarkerDistance = Math.abs(Math.sqrt(((markerTempPt.x - tempDestinationPoint.x) * (markerTempPt.x - tempDestinationPoint.x)) + ((markerTempPt.y - tempDestinationPoint.y) * (markerTempPt.y - tempDestinationPoint.y)))); 
								}
								
								if (tempMarkerDistance < minimumMarkerDistance || tempMarkerDistance==minimumMarkerDistance)
								{
										minimumMarkerDistance = tempMarkerDistance;
										tempMarkerIndex = mIndex;
								}
							}
							bottomMarkerMovePoint = bottomMarkerInPathGroup[tempMarkerIndex];							
							FlxVelocity.moveTowardsPoint(this, bottomMarkerMovePoint, xVelocity);
							velocity.y = 0;
						}					
					}		
				}
				/* NEED TO GO DOWN WHEN TOUCHING THE FLOOR */
				if (Registry.guardLadderDirection == "DOWN")
				{
					minimumMarkerDistance = 0;
					
					//get the marker position with minimum distance from the endpoint so we can choose to climb that marker
					if (topMarkerInPath == true)
					{
						//search for the marker position in that path
						if (touchedTopMarker == false)
						{
							tempDestinationPoint.x = Registry.guardEndPoint.x * Registry.TILESIZE;
							tempDestinationPoint.y = Registry.guardEndPoint.y * Registry.TILESIZE;	
						}
						for (var markerIndex:int = 0; markerIndex < topMarkerInPathGroup.length; markerIndex++)
							{	
								markerTempPt = topMarkerInPathGroup[markerIndex];
								if (markerIndex== 0)
								{
									minimumMarkerDistance = Math.abs(Math.sqrt(((markerTempPt.x - tempDestinationPoint.x) * (markerTempPt.x - tempDestinationPoint.x)) + ((markerTempPt.y - tempDestinationPoint.y) * (markerTempPt.y - tempDestinationPoint.y)))); 
									tempMarkerDistance = minimumMarkerDistance;
						
								}
								else
								{
									tempMarkerDistance = Math.abs(Math.sqrt(((markerTempPt.x - tempDestinationPoint.x) * (markerTempPt.x - tempDestinationPoint.x)) + ((markerTempPt.y - tempDestinationPoint.y) * (markerTempPt.y - tempDestinationPoint.y)))); 
								}
								
								if (tempMarkerDistance < minimumMarkerDistance || tempMarkerDistance == minimumMarkerDistance)
								{
										minimumMarkerDistance = tempMarkerDistance;
										tempMarkerIndex = markerIndex;
								}
							}
							topMarkerMovePoint = topMarkerInPathGroup[tempMarkerIndex];							
							FlxVelocity.moveTowardsPoint(this, topMarkerMovePoint, xVelocity);
							velocity.y = 0;
					}
				}
				if (Registry.guardLadderDirection == "NONE")
				{
					tempEndDestinationPoint.x = Registry.guardEndPoint.x * Registry.TILESIZE;
					tempEndDestinationPoint.y = Registry.guardEndPoint.y * Registry.TILESIZE;;
					FlxVelocity.moveTowardsPoint(this, tempEndDestinationPoint, xVelocity);
					velocity.y = 0;
				}
			
		}
		else if (climbing == true)
		{			
			if (Registry.guardLadderDirection == "DOWN")
			{			
				climbing == true; 
				velocity.y = xVelocity/2;
				x = tempBottomMarker.x -20;
				velocity.x = 0;
				acceleration.y = 0;
			}								
			
			if (Registry.guardLadderDirection == "UP")
			{
				climbing = true;
				velocity.y = - xVelocity / 2;
				x = tempBottomMarker.x -20;
				velocity.x = 0;
				acceleration.y = 0;
				
			}
		
		}
		
		}
		/* check if there are markers in path */
		public function checkMarkers(pathArray:Array):void
		{
			//check the whole path first for markers
			for (var i:int = 0; i < pathArray.length; i++)
			{
					var checkPoint:FlxPoint;
					checkPoint = pathArray[i];
					checkPoint.x = checkPoint.x * Registry.TILESIZE;
					checkPoint.y = checkPoint.y * Registry.TILESIZE;
					
					//if there is at leas
					if (checkBottomMarkers(checkPoint))
					{
						bottomMarkerInPath = true;
						bottomMarkerInPathGroup.push(checkPoint);
					}
					if (checkTopMarkers(checkPoint))
					{
						topMarkerInPath = true;
						topMarkerInPathGroup.push(checkPoint);
					}	
			}		
		}
		
		/* function for bottom marker reaction */
		public function bottomMarkerReaction():void
		{
			if (touchedBottomMarker == true && Registry.guardLadderDirection == "UP")
			{
				climbing = true;
				velocity.y = - xVelocity / 2;
				x = tempBottomMarker.x	 - 20;
				velocity.x = 0;
				acceleration.y = 0;	
			}
			if (touchedBottomMarker == true && (Registry.guardLadderDirection == "DOWN"))
			{
				climbing = false;
				velocity.y = 30;		
				velocity.x = 80;
				acceleration.y = GRAVITY / 3;
				FlxVelocity.moveTowardsPoint(this, tempEndDestinationPoint, xVelocity);
			}
			if (touchedBottomMarker == true && climbing == true && Registry.guardLadderDirection == "NONE")
			{
				climbing = false;
				velocity.y = 0;		
				x = tempXSetMarker.x -20;
				acceleration.y = GRAVITY;		
				velocity.x = 50;		
				FlxVelocity.moveTowardsPoint(this, tempEndDestinationPoint, xVelocity);
					
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
			Mode = "noiseDetected";
			
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
		
		/*function for top marker reaction */
		public function topMarkerReaction():void
		{
			if (Registry.guardLadderDirection == "UP" && climbing == true && touchedTopMarker==true)
			{
				climbing = false;
				y = tempXSetMarker.y - 80; 
				acceleration.y = GRAVITY;
				touchedTopMarker = false;	
				FlxVelocity.moveTowardsPoint(this, tempEndDestinationPoint, xVelocity);
			}
			if (Registry.guardLadderDirection == "DOWN" && touchedTopMarker == true)
			{
				climbing = true;
				x = tempXSetMarker.x -20;
				acceleration.y = 0;
				velocity.x = 0;
				velocity.y = 30;
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
			if (isTouching(FLOOR))
			{
				//climbing = false;
				goingDown = false;
				goingUp = false;
				
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
				}
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
		/*Always use this function to trigger the marker bottom  = true"*/
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
		
		/* sets the bottommarkertouched boolean variable to false after going past certain coordinates */
		private function checkTouchedBottomMarker():void
		{
			if (touchedBottomMarker == true && climbing==true)
			{
				if (velocity.y < 0) //going up
				{
					if (y < tempBottomMarker.y - 167)
					{
						touchedBottomMarker = false;
					}
				}
			}
			if (touchedBottomMarker == true)
			{
				
				if (x > tempBottomMarker.x +30 || x < tempBottomMarker.x -30)
				{
					touchedBottomMarker = false;
					
				}
			}
		}
		
		/* sets the topmarkertouched boolean variable to false after going past certain coordinates */
		private function checkTouchedTopMarker():void
		{
			if (touchedTopMarker == true)
			{
				if ((x < tempTopMarker.x +10 ) || (x > tempTopMarker.x +10))
				{
					touchedTopMarker = false;
				}
			}
		}
		
		
		public function handleEnemyStop(guard:Guard, marker:Marker):void
		{	
			if (touchedMarker==false && Mode == "Normal") //only stop at the marker in Normal mode
			{
				velocity.x = 0;
				touchedMarker = true;
			}			
		}
						
		/* guard sees player if in sight range */
		public function seePlayer(sightrange:sightRanges, player:Player):void
		{
			pixelCounter += FlxG.elapsed;
			if (pixelCounter > 0.5) //check it every 0.5 frame
			{
				if (FlxCollision.pixelPerfectCheck(sightrange, player))	
				{
					detected = true;
					canSee = true;
					pixelCounter = 0;
				}
			}	
		}
		
	
		/* update function */
		override public function update():void
		{	
			setVelocity();	
			bottomMarkerReaction();
			topMarkerReaction();
			checkTouchedBottomMarker();
			checkTouchedTopMarker();
			bulletCounterCheck();
			checkMode();
			checkFacing();
			super.update();		
			
			
								
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
				var patrolEndPointXInTiles:int = (patrolEndPointX / 32) - 1;
				var patrolEndPointYInTiles:int = patrolEndPointY / 32;
				var patrolStartPointXInTiles:int = patrolStartPointX / 32;
				var patrolStartPointYInTiles:int = patrolStartPointY / 32;
			
				
				if (patrolPathCreated == false && startedPatrol == false)
				{
					trackPath = patrolPathClass.getPath(patrolStartPointX, patrolStartPointY , patrolEndPointX, patrolEndPointY);
					followThePath();
					startedPatrol = true;
				}			
				//reached the end
				if (startedPatrol == true && (patrolEndPointXInTiles == xInTiles) && (patrolEndPointYInTiles==yInTiles))
				{
					stopCounter += FlxG.elapsed;
					velocity.x = 0;
					if (stopCounter > 2)
					{	
						trackPath = patrolPathClass.getPath(patrolEndPointX, patrolEndPointY , patrolStartPointX, patrolStartPointY);
						followThePath();
						stopCounter = 0;
					}
				}
				//came back to the startPoint
				if (startedPatrol == true && (patrolStartPointXInTiles == xInTiles) && (patrolStartPointYInTiles == yInTiles))
				{
					stopCounter += FlxG.elapsed;
					velocity.x = 0;
					if (stopCounter > 2)
					{
						trackPath = patrolPathClass.getPath(patrolStartPointX, patrolStartPointY , patrolEndPointX, patrolEndPointY);
						followThePath();
						stopCounter = 0;
					}
				}
			}
			else if (Mode == "noiseDetected")
			{	
				/* checking if the guard needs to turn back while following */
				var traversePoint:Marker;
				
				
				
				for (var i:int = 0; i < stopMarkerGroup.length; i++)
				{
					traversePoint = stopMarkerGroup[i];
					stopMarkerPoint.x = int(traversePoint.x / Registry.TILESIZE);
					stopMarkerPoint.y = int(traversePoint.y / Registry.TILESIZE);
														
					/* stop at stopmarker point when it is folloiwng noise 
					 * but hasn't reached the noise yet */
					if (noiseReached ==false && ((xInTiles == stopMarkerPoint.x -1) && (yInTiles == stopMarkerPoint.y)))
					{
						//stop and go back to patrol mode
						stopCounter += FlxG.elapsed;
						velocity.x = 0;
						if (stopCounter > 2)
						{
							//find the nearest path from this point to where the noise is detected for the first time
							trackPath = patrolPathClass.getPath(x, y, goBackToPathPoint.x, goBackToPathPoint.y);
							followThePath();
							stopCounter = 0;
							goBackToOriginalPlace = true;
						}
					}
				}
				
				/*reached the source of noise */
				if ((xInTiles == noiseTile.x) && (yInTiles == noiseTile.y))
				{
					noiseReached = true;
					velocity.x = 0;
							
					
					stopCounter += FlxG.elapsed;
					if (stopCounter > 2)
					{
							//find the nearest path from this point to where the noise is detected for the first time
							trackPath = patrolPathClass.getPath(x, y, goBackToPathPoint.x, goBackToPathPoint.y);
							followThePath();
							stopCounter = 0;							
							noiseReached = false;
							noiseTile.exists = false;
							goBackToOriginalPlace = true;
							
					}
					
				}
				
				/* reached where the noise was detected for the first time after searching the noisepoint */
				if (goBackToOriginalPlace == true && (xInTiles == (int(goBackToPathPoint.x / Registry.TILESIZE))) && (yInTiles == (int(goBackToPathPoint.y / Registry.TILESIZE))))
				{
					
					Mode = "Normal"; 
					noiseDetected = false;
					noiseDetectedFirstTime = false;
					goBackToOriginalPlace = false;
					
				}
				
				/* No need to go back to the place where noise was detected for the first time - follow the noise */
				if (goBackToOriginalPlace == false && noiseReached == false )
				{
					//trace("lastfexecuted", Registry.player.x, Mode, noiseTile.x, noiseTile.y, xInTiles, yInTiles);
					trackPath = patrolPathClass.getPath(startX, startY, endX, endY);
					followThePath();
				}	
			}
			else if (Mode == "inSightRangeFar")
			{
				/*- player in sight range but far
				 * overlap sightrange - two graphics
				 * one smaller and one larger
					- speed increase
					- will go back to Mode = Normal if player gets out of guard’s sight range (running away/smoke bomb) for more than 10 seconds
					- but will be much faster
					- player quite far from the guard - guard not sure if he saw smth or not 
					- alertLevel = 1
				 * 
				 */
			}
			else if (Mode == "inSightRangeClose")
			{
				/*- player in sight range up close
					- speed increase
					- will alert other guards if the player gets out of guard’s sight range for more than 3 seconds
					- will go back to patrol mode, but will be much faster
					- will shoot on sight. 
					-if noise is detected, will not follow - the delay will still be in effect
				 */					
			}			
		}
		
		
		/* load marker positions for later use */
		private function loadMarkers():void
		{
			bottomMarkerGroup = [];
			topMarkerGroup = [];
			stopMarkerGroup = [];
			var tempStopMarker:Marker;
			
			for (var i:int = 0; i < Registry.markers_ladderBottom.length; i++)
			{
				bottomMarkerGroup.push(Registry.markers_ladderBottom.members[i]);
			}
			
			for (var j:int = 0; j < Registry.markers_ladderTop.length; j++)
			{
				topMarkerGroup.push(Registry.markers_ladderTop.members[j]);
			}
			for (var k:int = 0; k < Registry.markers_enemyStop.length; k++)
			{
				stopMarkerGroup.push(Registry.markers_enemyStop.members[k]);			
			}
			
		}

		/* load bottom ladder marker positions for reference */
		
		private function checkBottomMarkers(point:FlxPoint):Boolean
		{	var checkMarker:Marker;
			for (var i:int = 0; i < bottomMarkerGroup.length; i++)
			{
				 checkMarker = bottomMarkerGroup[i];
				 //add 27 to y as offset
				 if (point.x == checkMarker.x && point.y + 27 == checkMarker.y)
				 {
					 return true;
				 }
			}
			return false;
		}
		
		/* load top ladder marker positions for reference */
		private function checkTopMarkers(point:FlxPoint):Boolean
		{
			var checkMarker:Marker;
			for (var i:int = 0; i < topMarkerGroup.length; i++)
			{
				 checkMarker = topMarkerGroup[i];
				 //deduct 37 as offset
				 if (point.x == checkMarker.x && point.y - 37 == checkMarker.y)
				 {
					 return true;
				 }
			}
			return false;
		}
	}

}