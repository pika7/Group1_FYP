/* this class handles the weapon changing UI */

package ui 
{
	import org.flixel.*;
	import util.Registry;
	import actors.Player;
	
	public class WeaponUI extends FlxGroup
	{
		[Embed(source = '../../assets/img/ui/weaponbar.png')] private var labelPNG:Class;
		[Embed(source = '../../assets/img/ui/button_highlight.png')] private var highlightPNG:Class;
		
		/* positioning constants */
		private const LABEL_X:int = 0;
		private const LABEL_Y:int = 548;
		private const BUTTON_Y:int = 548;
		private const BUTTON_HIGHLIGHT_Y:int = 545;
		private const TRANQ_BUTTON_X:int = 160;
		private const HOOKSHOT_BUTTON_X:int = 210;
		private const SMOKE_BOMB_BUTTON_X:int = 260;
		private const STUN_GRENADE_BUTTON_X:int = 310;

		protected var weaponArray:Array;
		protected var label:FlxSprite;
		protected var highlight:FlxSprite;
		protected var tranqButton:TranqButton;
		protected var hookshotButton:HookshotButton;
		protected var stunGrenadeButton:StunGrenadeButton;
		protected var smokeBombButton:SmokeBombButton;
		
		public function WeaponUI() 
		{
			super();
			
			/* array indices correspond to weapon numbers in player */
			weaponArray = new Array(TRANQ_BUTTON_X, HOOKSHOT_BUTTON_X, SMOKE_BOMB_BUTTON_X, STUN_GRENADE_BUTTON_X);
			
			/* highlight */
			highlight = new FlxSprite(weaponArray[Player.TRANQ], BUTTON_HIGHLIGHT_Y, highlightPNG);
			highlight.scrollFactor.x = 0;
			highlight.scrollFactor.y = 0;
			add(highlight);
			
			/* main label */
			label = new FlxSprite(LABEL_X, LABEL_Y, labelPNG);
			label.scrollFactor.x = 0;
			label.scrollFactor.y = 0;
			add(label);
			
			/* tranq button */
			tranqButton = new TranqButton(TRANQ_BUTTON_X, BUTTON_Y);
			tranqButton.scrollFactor.x = 0;
			tranqButton.scrollFactor.y = 0;
			tranqButton.onUp = tranqOnUp;
			add(tranqButton);
			
			/* hookshot button */
			hookshotButton = new HookshotButton(HOOKSHOT_BUTTON_X, BUTTON_Y);
			hookshotButton.scrollFactor.x = 0;
			hookshotButton.scrollFactor.y = 0;
			hookshotButton.onUp = hookshotOnUp;
			add(hookshotButton);
			
			/* smoke bomb */
			smokeBombButton = new SmokeBombButton(SMOKE_BOMB_BUTTON_X, BUTTON_Y);
			smokeBombButton.scrollFactor.x = 0;
			smokeBombButton.scrollFactor.y = 0;
			smokeBombButton.onUp = smokeBombOnUp;
			add(smokeBombButton);
			
			/* stun grenade */
			stunGrenadeButton = new StunGrenadeButton(STUN_GRENADE_BUTTON_X, BUTTON_Y);
			stunGrenadeButton.scrollFactor.x = 0;
			stunGrenadeButton.scrollFactor.y = 0;
			stunGrenadeButton.onUp = stunGrenadeOnUp;
			add(stunGrenadeButton);
		}
		
		override public function update():void
		{			
			super.update();
		}
		
		/**
		 * Returns true if any button is currently being pressed.
		 * 
		 * @return True if any button is currently being pressed.
		 */
		public function pressed():Boolean
		{
			return tranqButton.status || hookshotButton.status || smokeBombButton.status || stunGrenadeButton.status;
		}
		
		/**
		 * This only changes the display of the weapon UI! Doesn't actually change the weapon set.
		 * This is also INCREDIBLE spaghetti code.  I am amazed I managed to have two classes call back and
		 * forth like this.
		 */
		public function setWeaponDisplay(weapon:int):void
		{
			highlight.x = weaponArray[weapon];
		}
		
		//////////// FUNCTIONS FOR BUTTONS ///////////////
		private function tranqOnUp():void
		{
			Registry.player.setWeapon(Player.TRANQ);
		}
		
		private function hookshotOnUp():void
		{
			Registry.player.setWeapon(Player.HOOKSHOT);
		}
		
		private function smokeBombOnUp():void
		{
			Registry.player.setWeapon(Player.SMOKEBOMB);
		}
		
		private function stunGrenadeOnUp():void
		{
			Registry.player.setWeapon(Player.STUNGRENADE);
		}
	}
}