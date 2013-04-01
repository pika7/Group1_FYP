package actors.enemy
{
import util.Registry;
import org.flixel.FlxSprite;

public class sightRanges extends FlxSprite
{
	[Embed(source = '../../../assets/img/enemies/sightRanges.png')] private var sightRangePNG:Class;

	public var alertLevel:int = 0;
	
	public function sightRanges(X:int, Y:int)
	{	
		super(X, Y);
		width = 341;
		height = 128;
		facing = RIGHT;
		visible = true;

		loadGraphic(sightRangePNG, false, true, 321, 128);
		addAnimation("alert0", [0], 0, false);
		addAnimation("alert1", [1], 0, false);
		addAnimation("alert2", [2], 0, false);
	}

	override public function update():void
	{
		velocity.x = 100;
		checkAlertLevel();
	}

	public function checkAlertLevel():void
	{
		switch (alertLevel)
		{	
			case 0:
				play("alert0");	
				break;
			case 1:
				play("alert1");
				break;
			case 2:
				play("alert2");
				break;
			case 3:
				play("alert2");
				break;
		}
	}

	}	

}