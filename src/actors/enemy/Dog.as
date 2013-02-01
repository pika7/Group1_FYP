package actors.enemy 
{
	import org.flixel.*;
	import util.Registry;
	
	public class Dog extends FlxSprite
	{
		[Embed(source = '../../../assets/img/enemies/dog.png')] private var dogPNG:Class;
		/* initialization of variables */
		private const GRAVITY:int = 600;
		private const levelZeroVelocity:Number = 100;
		private const levelOneVelocity:Number = 120;
		private const levelTwoVelocity:Number = 130;
		private const levelThreeVelocity:Number = 140;
		private var alertLevel:int;
		private var patrolPathClass:patrolPathListDog;
		
		private var patrolStartPointX:int;
		private var patrolStartPointY:int;
		private var patrolEndPointX:int;
		private var patrolEndPointY:int;
		
		private var tempEndDestinationPoint:FlxPoint = new FlxPoint(0, 0);
		private var tempStartDestinationPoint:FlxPoint = new FlxPoint(0, 0);
		
		
		private var tempPt:FlxPoint = new FlxPoint(0, 0);
		
		private var PrevPt:FlxPoint = new FlxPoint(0, 0);
		private var tempNextPt:FlxPoint = new FlxPoint(0,0);
		
		public var trackPath:Array;
		private var pointsToFollow:Array;
		
		private var stopCounter:Number = 0;
		private var Mode:String = "";
		private var patrolStatus:String = "";
		private var goBackPatrol:Boolean = false;
		private var startedPatrol:Boolean = false;
		private var patrolStatusBeforeNoise:String = "";
		private var patrolPathCreated:Boolean = false;
		private var xVelocity:Number;

		public function Dog(X:int, Y:int, patrolStartX:int, patrolStartY:int, patrolEndX:int, patrolEndY:int)
		{
			super(X, Y);
			loadGraphic(dogPNG, true, true, 32, 32, true);
			width = 32;
			height = 32;
	
			/* sprite speed initialization*/
			acceleration.y = GRAVITY;
			
			xVelocity = 80;

			/* sprite animations */
			addAnimation("walk", [0], 0, false);
			addAnimation("shoot", [0], 0, false);
			addAnimation("alert", [0], 0, false);
			addAnimation("search", [0], 0, false);

			/*other sprite properties*/
			facing = RIGHT;	

			/* set the initial mode */
			Mode = "Normal";
			//will change to getter method later

			alertLevel = 0;

			/* pathfinding stuff */
			patrolPathClass = new patrolPathListDog();
			patrolStartPointX = patrolStartX;
			patrolStartPointY = patrolStartY;
			patrolEndPointX = patrolEndX;
			patrolEndPointY = patrolEndY;
			
		}
		
		/* create the path array for following */
		public function createThePath():void	
		{
			pointsToFollow = [];
			
			//store start point
			tempStartDestinationPoint.x = Registry.dogStartPoint.x;
			tempStartDestinationPoint.y = Registry.dogStartPoint.y;
			tempEndDestinationPoint.x = Registry.dogEndPoint.x;
			tempEndDestinationPoint.y = Registry.dogEndPoint.y;
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
					
					pointsToFollow.push(tempPt);
				}
				else if (((tempPt.x == PrevPt.x) && (tempPt.y == PrevPt.y + 1) && (tempNextPt.x == tempPt.x + 1) && (tempNextPt.y == tempPt.y) ) || ((tempPt.x == PrevPt.x) && (tempPt.y == PrevPt.y + 1) && (tempNextPt.x == tempPt.x - 1) && (tempNextPt.y == tempPt.y)) )
				{	
		
					pointsToFollow.push(tempPt);
				}
				else if (((tempPt.x == PrevPt.x) && (tempPt.y == PrevPt.y - 1) && (tempNextPt.x == tempPt.x + 1) && (tempNextPt.y == tempPt.y) ) || ((tempPt.x == PrevPt.x) && (tempPt.y == PrevPt.y - 1) && (tempNextPt.x == tempPt.x - 1) && (tempNextPt.y == tempPt.y)))
				{
				
					pointsToFollow.push(tempPt);
				}
				else if (((tempPt.x == PrevPt.x+1) && (tempPt.y == PrevPt.y) && (tempNextPt.x == tempPt.x) && (tempNextPt.y == tempPt.y + 1)) || ((tempPt.x == PrevPt.x -1) && (tempPt.y == PrevPt.y) && (tempNextPt.x == tempPt.x) && (tempNextPt.y == tempPt.y + 1)))
				{
		
					pointsToFollow.push(tempPt);
				}
			}

		}
			pointsToFollow.push(tempEndDestinationPoint);
		}
		
		/* start following the created path */
		public function startFollowing():void
		{
			var xInTiles:int = int(x / 32);
			var yInTiles:int = int(y /32);

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
				velocity.x = xVelocity;
				acceleration.y = GRAVITY;
			}	
			else if (((yInTiles == tempPt.y) && ((xInTiles > tempPt.x)))) //need to move left
			{		
				facing = LEFT;
				velocity.x = -xVelocity;
				acceleration.y = GRAVITY;
			}
		}
		
		/* check enemy mode */
		public function checkMode():void
	{
		var xInTiles:int = (x / 32);
		var yInTiles:int = ((y ) / 32);

		if (Mode == "Normal")
		{	
			play("walk");
			var patrolEndPointXInTiles:int = patrolEndPointX / 32;
			var patrolEndPointYInTiles:int = patrolEndPointY / 32;
			var patrolStartPointXInTiles:int = patrolStartPointX / 32;
			var patrolStartPointYInTiles:int = patrolStartPointY / 32;
		
			trackPath = patrolPathClass.getPath(patrolStartPointX, patrolStartPointY , patrolEndPointX, patrolEndPointY);
			createThePath();
			
			//create patrol Path for the first time
			if (justTouched(FLOOR) && patrolPathCreated == false && startedPatrol == false)
			{	
				trackPath = patrolPathClass.getPath(patrolStartPointX, patrolStartPointY , patrolEndPointX, patrolEndPointY);
				createThePath();
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
					createThePath();
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
					createThePath();
					Mode = "Patrolling";
					patrolStatus = "toEndPoint";
					stopCounter = 0;
					facing = RIGHT;
				}
			}
			else if (goBackPatrol == true) 
			{
				if (patrolStatusBeforeNoise == "toEndPoint")
				{
					goBackPatrol = false;
					trackPath = patrolPathClass.getPath(x, y, patrolEndPointX, patrolEndPointY);
					createThePath();
					facing = RIGHT;
					Mode = "Patrolling";
				}
				if (patrolStatusBeforeNoise == "toStartPoint")
				{	
					goBackPatrol = false;
					trackPath = patrolPathClass.getPath(x, y, patrolStartPointX, patrolStartPointY);
					createThePath();
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
		
	}
	
	
		/* update function */
		override public function update():void
		{	
			checkMode();
			super.update();	
		}
		
	}
	
}

