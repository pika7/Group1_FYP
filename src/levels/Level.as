/*
 * This is an abstract class that should not be called.
 * The use of this class is to enable us to place a variable
 * in the Registry that can hold any level.
 */

package levels 
{
	
	import objs.GoalItem;
	import objs.Hole;
	import org.flixel.*;
	import objs.Marker;
	import objs.Exit;
	import util.Registry;
	
	public class Level extends FlxGroup
	{
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_map.csv", mimeType = "application/octet-stream")] public var demoMapCSV:Class;
		[Embed(source = "../../assets/csv/2nd_level/mapCSV_2nd_level_map.csv", mimeType = "application/octet-stream")] public var mapCSV2:Class;
		[Embed(source = "../../assets/csv/3rd_level/mapCSV_3rd_level_map.csv", mimeType = "application/octet-stream")] public var mapCSV3:Class;
		[Embed(source = "../../assets/csv/4th_level/mapCSV_4th_level_map.csv", mimeType = "application/octet-stream")] public var mapCSV4:Class;
		[Embed(source = "../../assets/csv/5th_level/mapCSV_5th_level_map.csv", mimeType = "application/octet-stream")] public var mapCSV5:Class;
		
		[Embed(source = "../../assets/img/tilemaps/blackwhite_map.png")] public var demoMapTilesPNG:Class;
		[Embed(source = "../../assets/img/tilemaps/blackwhite_map.png")] public var mapTilesPNG2:Class;
		[Embed(source = "../../assets/img/tilemaps/blackwhite_map.png")] public var mapTilesPNG3:Class;
		[Embed(source = "../../assets/img/tilemaps/blackwhite_map.png")] public var mapTilesPNG4:Class;
		[Embed(source = "../../assets/img/tilemaps/blackwhite_map.png")] public var mapTilesPNG5:Class;
		
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_background.csv", mimeType = "application/octet-stream")] public var demoBackgroundCSV:Class;
		[Embed(source = "../../assets/csv/2nd_level/mapCSV_2nd_level_background.csv", mimeType = "application/octet-stream")] public var backgroundCSV2:Class;
		[Embed(source = "../../assets/csv/3rd_level/mapCSV_3rd_level_background.csv", mimeType = "application/octet-stream")] public var backgroundCSV3:Class;
		[Embed(source = "../../assets/csv/4th_level/mapCSV_4th_level_background.csv", mimeType = "application/octet-stream")] public var backgroundCSV4:Class;
		[Embed(source = "../../assets/csv/5th_level/mapCSV_5th_level_background.csv", mimeType = "application/octet-stream")] public var backgroundCSV5:Class;
		
		[Embed(source = "../../assets/img/tilemaps/demo_bg.png")] public var demoBackgroundTilesPNG:Class;
		[Embed(source = "../../assets/img/tilemaps/bg2.png")] public var backgroundTilesPNG2:Class;
		[Embed(source = "../../assets/img/tilemaps/bg3.png")] public var backgroundTilesPNG3:Class;
		[Embed(source = "../../assets/img/tilemaps/bg4.png")] public var backgroundTilesPNG4:Class;
		[Embed(source = "../../assets/img/tilemaps/bg5.png")] public var backgroundTilesPNG5:Class;
		
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_over.csv", mimeType = "application/octet-stream")] public var demoOverCSV:Class;
		[Embed(source = "../../assets/csv/2nd_level/mapCSV_2nd_level_over.csv", mimeType = "application/octet-stream")] public var overCSV2:Class;
		[Embed(source = "../../assets/csv/3rd_level/mapCSV_3rd_level_over.csv", mimeType = "application/octet-stream")] public var overCSV3:Class;
		[Embed(source = "../../assets/csv/4th_level/mapCSV_4th_level_over.csv", mimeType = "application/octet-stream")] public var overCSV4:Class;
		[Embed(source = "../../assets/csv/5th_level/mapCSV_5th_level_over.csv", mimeType = "application/octet-stream")] public var overCSV5:Class;
		
		[Embed(source = "../../assets/img/tilemaps/over_map.png")] public var demoOverTilesPNG:Class;
		[Embed(source = "../../assets/img/tilemaps/over_map.png")] public var overTilesPNG2:Class;
		[Embed(source = "../../assets/img/tilemaps/over_map.png")] public var overTilesPNG3:Class;
		[Embed(source = "../../assets/img/tilemaps/over_map.png")] public var overTilesPNG4:Class;
		[Embed(source = "../../assets/img/tilemaps/over_map.png")] public var overTilesPNG5:Class;
		
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_markers.csv", mimeType = "application/octet-stream")] public var demoMarkersCSV:Class;
		[Embed(source = "../../assets/csv/2nd_level/mapCSV_2nd_level_markers.csv", mimeType = "application/octet-stream")] public var markersCSV2:Class;
		[Embed(source = "../../assets/csv/3rd_level/mapCSV_3rd_level_markers.csv", mimeType = "application/octet-stream")] public var markersCSV3:Class;
		[Embed(source = "../../assets/csv/4th_level/mapCSV_4th_level_markers.csv", mimeType = "application/octet-stream")] public var markersCSV4:Class;
		[Embed(source = "../../assets/csv/5th_level/mapCSV_5th_level_markers.csv", mimeType = "application/octet-stream")] public var markersCSV5:Class;
		
		[Embed(source = "../../assets/img/tilemaps/marker_map.png")] public var demoMarkerTilesPNG:Class;
		[Embed(source = "../../assets/img/tilemaps/marker_map.png")] public var markerTilesPNG2:Class;
		[Embed(source = "../../assets/img/tilemaps/marker_map.png")] public var markerTilesPNG3:Class;
		[Embed(source = "../../assets/img/tilemaps/marker_map.png")] public var markerTilesPNG4:Class;
		[Embed(source = "../../assets/img/tilemaps/marker_map.png")] public var markerTilesPNG5:Class;
		
		/* parsing */
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_checkpoints.csv", mimeType = "application/octet-stream")] public var demoItemsCSV:Class;
		[Embed(source = "../../assets/csv/2nd_level/mapCSV_2nd_level_checkpoints.csv", mimeType = "application/octet-stream")] public var itemsCSV2:Class;
		[Embed(source = "../../assets/csv/3rd_level/mapCSV_3rd_level_checkpoints.csv", mimeType = "application/octet-stream")] public var itemsCSV3:Class;
		[Embed(source = "../../assets/csv/4th_level/mapCSV_4th_level_checkpoints.csv", mimeType = "application/octet-stream")] public var itemsCSV4:Class;
		[Embed(source = "../../assets/csv/5th_level/mapCSV_5th_level_checkpoints.csv", mimeType = "application/octet-stream")] public var itemsCSV5:Class;
		
		[Embed(source = "../../assets/img/tilemaps/checkpoint_map.png")] public var demoItemTilesPNG:Class;
		[Embed(source = "../../assets/img/tilemaps/checkpoint_map.png")] public var itemTilesPNG2:Class;
		[Embed(source = "../../assets/img/tilemaps/checkpoint_map.png")] public var itemTilesPNG3:Class;
		[Embed(source = "../../assets/img/tilemaps/checkpoint_map.png")] public var itemTilesPNG4:Class;
		[Embed(source = "../../assets/img/tilemaps/checkpoint_map.png")] public var itemTilesPNG5:Class;
		
		public var map:FlxTilemap;
		protected var background:FlxTilemap;
		protected var checkpoints:FlxTilemap;
		protected var markers:FlxTilemap;
		protected var over:FlxTilemap;
		
		public var width:int;
		public var height:int;
		
		protected var mapCSV:Class;
		protected var backgroundCSV:Class;
		protected var overCSV:Class;
		protected var markersCSV:Class;
		protected var itemsCSV:Class;
		
		protected var mapTilesPNG:Class;
		protected var backgroundTilesPNG:Class;
		protected var overTilesPNG:Class;
		protected var markerTilesPNG:Class;
		protected var itemTilesPNG:Class;
		
		/* enumerate the checkpoints */
		protected const GOAL_ITEM:int = 1;
		protected const EXIT:int = 2;
		protected const HOLE:int = 3;
		
		public function Level() 
		{
			/* load different map depending on current level */
			switch(Registry.gameStats.level)
			{
				case 0:
					mapCSV = demoMapCSV;
					backgroundCSV = demoBackgroundCSV;
					overCSV = demoOverCSV;
					markersCSV = demoMarkersCSV;
					itemsCSV = demoItemsCSV;
					
					mapTilesPNG = demoMapTilesPNG;
					backgroundTilesPNG = demoBackgroundTilesPNG;
					overTilesPNG = demoOverTilesPNG;
					markerTilesPNG = demoMarkerTilesPNG;
					itemTilesPNG = demoItemTilesPNG;
					break;
					
				case 1:
					mapCSV = mapCSV2;
					backgroundCSV = backgroundCSV2;
					overCSV = overCSV2;
					markersCSV = markersCSV2;
					itemsCSV = itemsCSV2;
					
					mapTilesPNG = mapTilesPNG2;
					backgroundTilesPNG = backgroundTilesPNG2;
					overTilesPNG = overTilesPNG2;
					markerTilesPNG = markerTilesPNG2;
					itemTilesPNG = itemTilesPNG2;
					break;
					
				case 2:
					mapCSV = mapCSV3;
					backgroundCSV = backgroundCSV3;
					overCSV = overCSV3;
					markersCSV = markersCSV3;
					itemsCSV = itemsCSV3;
					
					mapTilesPNG = mapTilesPNG3;
					backgroundTilesPNG = backgroundTilesPNG3;
					overTilesPNG = overTilesPNG3;
					markerTilesPNG = markerTilesPNG3;
					itemTilesPNG = itemTilesPNG3;
					break;
					
				case 3:
					mapCSV = mapCSV4;
					backgroundCSV = backgroundCSV4;
					overCSV = overCSV4;
					markersCSV = markersCSV4;
					itemsCSV = itemsCSV4;
					
					mapTilesPNG = mapTilesPNG4;
					backgroundTilesPNG = backgroundTilesPNG4;
					overTilesPNG = overTilesPNG4;
					markerTilesPNG = markerTilesPNG4;
					itemTilesPNG = itemTilesPNG4;
					break;
					
				case 4:
					mapCSV = mapCSV5;
					backgroundCSV = backgroundCSV5;
					overCSV = overCSV5;
					markersCSV = markersCSV5;
					itemsCSV = itemsCSV5;
					
					mapTilesPNG = mapTilesPNG5;
					backgroundTilesPNG = backgroundTilesPNG5;
					overTilesPNG = overTilesPNG5;
					markerTilesPNG = markerTilesPNG5;
					itemTilesPNG = itemTilesPNG5;
					break;
			}
			
			map = new FlxTilemap();
			map.loadMap(new mapCSV, mapTilesPNG, 32, 32, 0, 0, 1, 1);
			
			background = new FlxTilemap();
			background.loadMap(new backgroundCSV, backgroundTilesPNG, 32, 32, 0, 0, 0, 4);
			
			over = new FlxTilemap();
			over.loadMap(new overCSV, overTilesPNG, 32, 32, 0, 0, 0, 2);
			
			checkpoints = new FlxTilemap();
			checkpoints.loadMap(new itemsCSV, itemTilesPNG, 32, 32, 0, 0, 1, 2);
			
			markers = new FlxTilemap();
			markers.loadMap(new markersCSV, markerTilesPNG, 32, 32, 0, 0, 1, 3);
			
			width = map.width;
			height = map.height;
			
			add(background);
			add(map);
			add(over);
			
			/* parse things */
			parseCheckpoints(checkpoints);
			parseMarkers(markers);	
		}
		
		/////////////////////////////////////////
		// PARSING FUNCTIONS
		/////////////////////////////////////////
		
		public function parseCheckpoints(map:FlxTilemap):void
		{
			for (var ty:int = 0; ty < map.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < map.widthInTiles; tx++)
				{
					/* Change this according to the tile number in DAME */
					switch (map.getTile(tx, ty))
					{
						case 0:
							break;
						
						case GOAL_ITEM:
							new GoalItem(tx, ty);
							break;
						
						case EXIT:
							new Exit(tx, ty);
							break;
							
						case HOLE:
							new Hole(tx, ty);
							break;
							
						default:
							trace("Invalid checkpoint.");
							break;
					}
				}
			}
		}
		
		public function parseExit(map:FlxTilemap):void
		{
			for (var ty:int = 0; ty < map.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < map.widthInTiles; tx++)
				{
					/* Change this according to the tile number in DAME */
					if (map.getTile(tx, ty) == 2)
					{
						new Exit(tx, ty);
					}
				}
			}
		}
		
		public function parseMarkers(map:FlxTilemap):void
		{
			for (var ty:int = 0; ty < map.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < map.widthInTiles; tx++)
				{
					/* Change this according to the tile number in DAME */
					/* TODO: improve this, clumsy */
					
					switch (map.getTile(tx, ty))
					{
						case 0:
							break;
						case Marker.LADDER_BOTTOM:
							new Marker(tx, ty, Marker.LADDER_BOTTOM);
							break;
						case Marker.LADDER_TOP:
							new Marker(tx, ty, Marker.LADDER_TOP);
							break;
						case Marker.HOOKSHOTABLE:
							new Marker(tx, ty, Marker.HOOKSHOTABLE);
							break;
						case Marker.ENEMYSTOP:
							new Marker(tx, ty, Marker.ENEMYSTOP);
							break;
						default:
							trace("Parsing error: invalid marker: " + map.getTile(tx, ty));
							break;
					}
				}
			}
		}
		
		
		
	}

}