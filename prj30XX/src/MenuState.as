package
{
	//Name: Elliot, Charmaine
	//Date: May 31, 2016
	//Title: MenuState.as
	//Description: The main menu where you can view instructions or start the game
	import org.flixel.*;
 
	public class MenuState extends FlxState
	{
		//buttons
		private var startButton:FlxButton;
		private var htpButton:FlxButton;		
		[Embed(source = "../assets/CSSbutton.png")] protected var imgCSSButton:Class;
		[Embed(source = "../assets/HTPbutton.png")] protected var imgHTPButton:Class;
		
		//music
		[Embed(source = "../assets/Melee Menu Piano.mp3")] protected var MeleeMenu:Class;
		
		public function MenuState()
		{
		}
		
		override public function create():void
		{
			add(new FlxSprite(0, 0, Resources.background));
			FlxG.mouse.show();
			
			//create and display buttons
			startButton = new FlxButton(120, 90, null, characterSelect); //button to move to the character select screen
			startButton.loadGraphic(imgCSSButton);
			add(startButton);
			
			htpButton = new FlxButton(120, 250, null, htpGame);  //button to display how to play instructions
			htpButton.loadGraphic(imgHTPButton);
			add(htpButton);
			
			//music
			FlxG.playMusic(MeleeMenu, 0);
		}
		
		//state-changing functions
		private function characterSelect():void
		{
			FlxG.switchState(new CharacterSelect); //switch to the Character Select Screen
		}
		
		private function htpGame():void
		{
			FlxG.switchState(new htpState); //switch to the instruction screen
		}
	}
}
