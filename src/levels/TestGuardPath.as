package levels 
{
	
	import org.flixel.*;
	import util.Registry;
	
	public class TestGuardPath extends LevelGuardPath 
	{
		[Embed(source = "../../assets/csv/test_level/mapCSV_test_level_patrol.csv", mimeType = "application/octet-stream")] public var patrolCSV:Class;
		[Embed(source = "../../assets/img/tilemaps/patrolpath_map.png")] public var patrolPNG:Class;
		public function TestGuardPath() 
		{
			GuardPathMap = new FlxTilemap();
			/* Check the level number and load the appropriate kind of map into GuardPathMap  */
			GuardPathMap.loadMap(new patrolCSV, patrolPNG, 32, 32, 0, 0, 1, 1);
			GuardPathMap.visible = false;
			add(GuardPathMap);
		}
		
	}

}