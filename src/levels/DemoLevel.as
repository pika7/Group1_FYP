package levels 
{
	
	import org.flixel.*;
	import actors.enemy.Guards;
	import util.Registry;
	
	public class DemoLevel extends Level
	{
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_map.csv", mimeType = "application/octet-stream")] public var mapCSV:Class;
		[Embed(source = "../../assets/img/tilemaps/blackwhite_map.png")] public var demoMapTilesPNG:Class;
		
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_background.csv", mimeType = "application/octet-stream")] public var backgroundCSV:Class;
		[Embed(source = "../../assets/img/tilemaps/demo_bg.png")] public var demoBackgroundTilesPNG:Class;
		
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_over.csv", mimeType = "application/octet-stream")] public var overCSV:Class;
		[Embed(source = "../../assets/img/tilemaps/over_map.png")] public var demoOverTilesPNG:Class;
		
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_markers.csv", mimeType = "application/octet-stream")] public var markersCSV:Class;
		[Embed(source = "../../assets/img/tilemaps/marker_map.png")] public var demoMarkerTilesPNG:Class;
		
		/* parsing */
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_checkpoints.csv", mimeType = "application/octet-stream")] public var itemsCSV:Class;
		[Embed(source = "../../assets/img/tilemaps/checkpoint_map.png")] public var demoItemTilesPNG:Class;
		
		/* enemies */
		public var guards:Guards;
		
		public function DemoLevel() 
		{
			map = new FlxTilemap();
			map.loadMap(new mapCSV, demoMapTilesPNG, 32, 32, 0, 0, 1, 1);
			
			background = new FlxTilemap();
			background.loadMap(new backgroundCSV, demoBackgroundTilesPNG, 32, 32, 0, 0, 0, 4);
			
			over = new FlxTilemap();
			over.loadMap(new overCSV, demoOverTilesPNG, 32, 32, 0, 0, 0, 2);
			
			checkpoints = new FlxTilemap();
			checkpoints.loadMap(new itemsCSV, demoItemTilesPNG, 32, 32, 0, 0, 1, 2);
			
			markers = new FlxTilemap();
			markers.loadMap(new markersCSV, demoMarkerTilesPNG, 32, 32, 0, 0, 1, 3);
			
			width = map.width;
			height = map.height;
			
			add(background);
			add(map);
			add(over);
			
			/* parse things */
			parseCheckpoints(checkpoints);
			parseMarkers(markers);	
		}
	}

}