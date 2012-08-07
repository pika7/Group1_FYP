package levels 
{
	
	import org.flixel.*;
	
	public class TestLevel extends Level
	{
		[Embed(source = "../../assets/csv/test_level/mapCSV_test_level_map.csv", mimeType = "application/octet-stream")] public var mapCSV:Class;
		[Embed(source = "../../assets/img/tilemaps/blackwhite_map.png")] public var mapTilesPNG:Class;
		
		[Embed(source = "../../assets/csv/test_level/mapCSV_test_level_background.csv", mimeType = "application/octet-stream")] public var backgroundCSV:Class;
		[Embed(source = "../../assets/img/tilemaps/striped_bg.png")] public var backgroundTilesPNG:Class;
		
		public function TestLevel() 
		{
			map = new FlxTilemap;
			map.loadMap(new mapCSV, mapTilesPNG, 32, 32, 0, 0, 1, 1);
			
			background = new FlxTilemap;
			background.loadMap(new backgroundCSV, backgroundTilesPNG, 32, 32, 0, 0, 0, 1);
			
			width = map.width;
			height = map.height;
			
			add(background);
			add(map);
		}
		
	}

}