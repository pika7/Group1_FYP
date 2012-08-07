/* you're going to have to change the classpath to your own flixel directory later */
/* tools > Global Classpaths */

package  
{
	import actors.enemy.Guard;
	import actors.Player;
	import levels.TestLevel;
	import org.flixel.*;
	import util.Registry;
	
	public class PlayState extends FlxState
	{
		public function PlayState() 
		{	
			
		}
		
		override public function create():void
		{
			Registry.level = new TestLevel();
			add(Registry.level);
			
			Registry.player = new Player(20, 20);
			add(Registry.player);
			
			Registry.guard = new Guard(150, 20);
			add(Registry.guard);
			add(Registry.bulletGroup);
		}
		
		override public function update():void
		{
			/////////////////////////////////////////
			// CAMERA CONTROLS
			/////////////////////////////////////////
			FlxG.worldBounds = new FlxRect(0, 0, Registry.level.width, Registry.level.height);
			FlxG.camera.setBounds(0, 0, Registry.level.width, Registry.level.height);
			FlxG.camera.follow(Registry.player, FlxCamera.STYLE_PLATFORMER);
			
			/////////////////////////////////////////
			// COLLISION CONTROLS
			/////////////////////////////////////////
			FlxG.collide(Registry.level, Registry.player);
			FlxG.collide(Registry.level, Registry.guard);
			
			super.update();
		}
		
	}

}