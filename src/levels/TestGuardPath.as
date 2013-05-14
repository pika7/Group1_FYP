package levels 
{
	
	import org.flixel.*;
	import util.Registry;
	
	public class TestGuardPath extends LevelGuardPath 
	{
		[Embed(source = "../../assets/csv/demo_level/mapCSV_demo_level_patrol.csv", mimeType = "application/octet-stream")] public var patrol_0_CSV:Class;
		[Embed(source = "../../assets/csv/2nd_level/mapCSV_2nd_level_patrol.csv", mimeType = "application/octet-stream")] public var patrol_1_CSV:Class;
		[Embed(source = "../../assets/csv/3rd_level/mapCSV_3rd_level_patrol.csv", mimeType = "application/octet-stream")] public var patrol_2_CSV:Class;
		[Embed(source = "../../assets/csv/4th_level/mapCSV_4th_level_patrol.csv", mimeType = "application/octet-stream")] public var patrol_3_CSV:Class;
		[Embed(source = "../../assets/csv/5th_level/mapCSV_5th_level_patrol.csv", mimeType = "application/octet-stream")] public var patrol_4_CSV:Class;
		
		[Embed(source = "../../assets/img/tilemaps/patrolpath_map.png")] public var patrolPNG:Class;
		
		public var patrolMapCSV:Class;
		
		public function TestGuardPath() 
		{
			/* load different map depending on current level */
			switch(Registry.gameStats.level)
			{
				case 0:
					patrolMapCSV = patrol_0_CSV;
					break;
					
				case 1:
					patrolMapCSV = patrol_1_CSV;
					break;
					
				case 2:
					patrolMapCSV = patrol_2_CSV;
					break;
					
				case 3:
					patrolMapCSV = patrol_3_CSV;
					break;
					
				case 4:
					patrolMapCSV = patrol_4_CSV;
					break;
			}
			
			GuardPathMap = new FlxTilemap();
			/* Check the level number and load the appropriate kind of map into GuardPathMap  */
			GuardPathMap.loadMap(new patrolMapCSV, patrolPNG, 32, 32, 0, 0, 1, 1);
			GuardPathMap.visible = false;
			add(GuardPathMap);
		}
		
	}

}