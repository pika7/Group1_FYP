package actors.enemy 
{
	import org.flixel.*;
	import util.Registry;
	import actors.enemy.patrolPathNode;
	
	public class patrolPathList
	{	
		private const COST_ORTHOGONAL:int = 10;
		private const MAPTILEWIDTH:Number = 60;
		private const MAPTILEHEIGHT:Number = 25;
		private var pathMap:FlxTilemap; 
		
		private var tileGroup:Array;
		private var visited:Array;
		private var notVisited:Array;
		
		private var tempNoise:FlxSprite;
		private var tempTile:patrolPathNode;
		private var tempDistance:Number;
		private var tempPoint:FlxPoint;
		private var tempIndex:int = 0;
		
		private var endPoint:FlxPoint 
		private var enemyPoint:FlxPoint = new FlxPoint(0, 0);
		private var playerPoint:FlxPoint = new FlxPoint(0, 0);
		
		private var startNodeIndex:int;
		private var endNodeIndex:int;
	
		private var endNodePoint:FlxPoint = new FlxPoint(0, 0);
		private var startNodePoint:FlxPoint = new FlxPoint(0, 0);
		private var pointsForPath:FlxGroup = new FlxGroup();
		private var pointPath:FlxPath;
		private var startPoint:FlxPoint = new FlxPoint(0, 0);
	
		private var trackPath:Array;
		private var currentF:int;
		private var currentG:int;
		private var tempNode:patrolPathNode;
		private var tempNodeIndex:int = 0
	
		public var startNode:patrolPathNode;
		public var endNode:patrolPathNode;
		private var currentNode:patrolPathNode;
		
		private var minimumDistance:Number;
		private var minimumTileIndex:int;
		
		private var enemyTileX:int = 0;
		private var enemyTileY:int = 0;
		private var playerTileX:int = 0;
		private var playerTileY:int = 0;
		
		private var ladderDirection:String;
		
		public function patrolPathList() 
		{
			//initialize the class with map information
			tileGroup = [];
			pathMap = Registry.levelGuardPath.GuardPathMap;
			parsePathMap(pathMap); //store all the map tiles into the map
			minimumDistance = 0;
			minimumTileIndex = 0;
			ladderDirection = "";
		}
		
		public function getPath(startX:int, startY:int, endX:int, endY:int):Array //will return flxpath later
		{
			//for getting the start point of the patrol path (guard position)
			visited = [];
			notVisited = [];
			
			enemyPoint.x = int(startX / Registry.TILESIZE); 
			enemyPoint.y = int(startY / Registry.TILESIZE);		
			
			playerPoint.x = int(endX / Registry.TILESIZE);
			playerPoint.y = int(endY / Registry.TILESIZE);
			
			startNode = getStartNode();
			endNode =  getEndNode();
			
			//Registry.guardStartPoint = startNode;
			//Registry.guardEndPoint = endNode;
			
			//for checking direction when climbing the ladder
			if (endNode.y < startNode.y)
			{
				ladderDirection = "UP";
			}
			else if (endNode.y > startNode.y)
			{
				ladderDirection = "DOWN";
			}
			else if (endNode.y == startNode.y)
			{
				ladderDirection = "NONE";
			}
			
			Registry.guardLadderDirection = ladderDirection;
			
			//tileGroup = parse all the nodes from the map
			//initialize all the prev pointer of each node	 to null
			for (var i:int = 0; i < tileGroup.length; i++)
			{
				tempNode = tileGroup[i];
				tempNode.prev = null;
			}
			
			//put startNode into open list
			notVisited.push(startNode);
			
			//initial node - g cost 0
			startNode.g = 0;
			startNode.h = Math.abs((startNode.x - endNode.x) + (startNode.y - endNode.y));
			startNode.f = startNode.h;
			
			//we have an open list
			//until 
			while (notVisited.length > 0)
			{
				currentF = int.MAX_VALUE;
				
				for (var j:int = 0; j < notVisited.length; j++)
				{
					tempNode = notVisited[j];
					
					if (tempNode.f < currentF)
					{
						currentNode = notVisited[j];
						currentF = currentNode.f;
					}
				}
					
				//if we have reached the destination node
				//traverse the node backwards
				if (currentNode == endNode)
				{
					return createPath(currentNode);
				}
				
				//put the already visted node in visited
				//take out the current node
				notVisited.splice(notVisited.indexOf(currentNode), 1);
				
				visited.push(currentNode);
				
				//get adjacent nodes to the current node
				for each(var node:patrolPathNode in getAdjacentTiles(currentNode))
				{
					//skip already visited nodes
					if (visited.indexOf(node) > -1) //node exists 
					{
						continue;
					}
					
					//G cost = current node + 
					currentG = currentNode.g + node.cost;
					
					//node doesn't exist in open list
					//put it in open list
					if ( notVisited.indexOf(node) == -1 )	
					{
						node.prev = currentNode;
						notVisited.push(node);
						node.g = currentG;
						node.h = Math.abs((node.x - endNode.x) + (node.y - endNode.y));
						node.f = node.g + node.h;
					}
					else if (currentG < node.g)
					{
						node.prev = currentNode;
						node.g = currentG;
						node.h = Math.abs((node.x - endNode.x) + (node.y - endNode.y));
						node.f = node.g + node.h;
					}
				}
			
			}
			return trackPath;
		}	
		
		public function createPath(end:patrolPathNode):Array
		{
			var resultPath:Array  = new Array();
			
			if (end == null)
			{
				return resultPath;
			}
			var n:patrolPathNode = end;
			while (n.prev != null)
			{
				resultPath.push(new FlxPoint(n.x, n.y));
				n = n.prev;
				
			}
			return resultPath.reverse();
		
		}
		public function getAdjacentTiles(n:patrolPathNode):Array
		{
			var Xhere:int = n.x;
			var Yhere:int = n.y;
			var traverseNode:patrolPathNode;
			var adjacentTiles:Array = new Array();
			var targetIndex:int = 0; 
			
			if (Xhere > 0)
			{
				if (nodeExists(Xhere - 1, Yhere) == true)
				{
					traverseNode = tileGroup[tempIndex];
					traverseNode.cost =  COST_ORTHOGONAL;
					adjacentTiles.push(traverseNode);
				}
			}
			if (Xhere < pathMap.widthInTiles - 1)
			{
				if (nodeExists(Xhere + 1, Yhere) == true)
				{
					traverseNode = tileGroup[tempIndex];
					traverseNode.cost =  COST_ORTHOGONAL;
					adjacentTiles.push(traverseNode);
				}
			}
			if (Yhere > 0)
			{	
				if (nodeExists(Xhere, Yhere-1) == true)
				{
					traverseNode = tileGroup[tempIndex];
					traverseNode.cost =  COST_ORTHOGONAL;
					adjacentTiles.push(traverseNode);
				}
				
			}
			if (Yhere < pathMap.widthInTiles - 1)
			{
				if (nodeExists(Xhere, Yhere+1) == true)
				{
					traverseNode = tileGroup[tempIndex];
					traverseNode.cost =  COST_ORTHOGONAL;
					adjacentTiles.push(traverseNode);
				}
				
			}
	
			return adjacentTiles;
		}
		
		public function nodeExists(x:int, y:int):Boolean
		{
			var checkNode:patrolPathNode;
			for (var i:int = 0; i < tileGroup.length; i++)
			{
				checkNode = tileGroup[i];
				if (checkNode.x == x && checkNode.y == y)
				{
					tempIndex = i;
					return true;
				}
			}
			return false;
		}
	
		
		public function getStartNode():patrolPathNode
		{
			for (var i:int = 0; i < tileGroup.length; i++)
			{	
				if (i == 0) //starting node 
				{
					tempTile = tileGroup[i]; //in TILE coordinates
					minimumDistance = Math.abs(Math.sqrt(((tempTile.x - enemyPoint.x)*(tempTile.x - enemyPoint.x)) + ((tempTile.y - enemyPoint.y) * (tempTile.y - enemyPoint.y))));
					tempDistance = minimumDistance;
				}
				else //from the 2nd node
				{
					tempTile = tileGroup[i];
					tempDistance = Math.abs(Math.sqrt(((tempTile.x - enemyPoint.x) * (tempTile.x - enemyPoint.x)) + ((tempTile.y - enemyPoint.y) * (tempTile.y - enemyPoint.y))));
					
				}
				if (tempDistance < minimumDistance || tempDistance == minimumDistance) //compare the new distances
				{
					minimumDistance = tempDistance;
					minimumTileIndex = i;
				}
			}
			return tileGroup[minimumTileIndex]; //this is our destination	
			startNodeIndex = minimumTileIndex;
		}
		
		//for calculating the closest tile (our destination) to noise radius 
		public function getEndNode():patrolPathNode
		{
			for (var i:int = 0; i < tileGroup.length; i++)
			{	
				if (i == 0) //starting node 
				{
					tempTile = tileGroup[i];
					minimumDistance = Math.abs(Math.sqrt(((tempTile.x - playerPoint.x)*(tempTile.x - playerPoint.x)) + ((tempTile.y - playerPoint.y)*(tempTile.y - playerPoint.y))));
					tempDistance = minimumDistance;
				}
				else //from the 2nd node
				{
					tempTile = tileGroup[i];
					tempDistance = Math.abs(Math.sqrt(((tempTile.x - playerPoint.x)*(tempTile.x - playerPoint.x)) + ((tempTile.y - playerPoint.y)*(tempTile.y - playerPoint.y))));
					
				}
				if (tempDistance < minimumDistance || tempDistance == minimumDistance) //compare the new distances
				{
					minimumDistance = tempDistance;
					minimumTileIndex = i;
				}
			}
			return tileGroup[minimumTileIndex]; //this is our destination
			endNodeIndex = minimumTileIndex;
			
		}
		
		/* parsing tiles in the path map */
		public function parsePathMap(map:FlxTilemap):void
		{
			for (var ty:int = 0; ty < map.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < map.widthInTiles; tx++)
				{
					if (map.getTile(tx, ty) == 1)
					{
						tileGroup.push(new patrolPathNode(tx, ty));
						//adding each tile to the list in tile coordinates
					}
				}
			}
		}
	
		
		}	
}