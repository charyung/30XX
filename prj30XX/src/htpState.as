package
{
	//Name: Elliot, Charmaine
	//Date: June 15, 2016
	//Title: htpState.as
	//Description: The screen that displays the controls and how the two gamemodes work
	import org.flixel.*;
 
	public class htpState extends FlxState
	{
		//button
		private var backButton:FlxButton;
		[Embed(source = "../assets/backButton.png")] protected var imgBackButton:Class;
		
		//text
		private static var infoText:FlxText;
		
		//music
		[Embed(source = "../assets/Melee Menu Piano.mp3")] protected var MeleeMenu:Class;
 
		public function htpState()
		{
		}
 
		override public function create():void
		{
			add(new FlxSprite(0, 0, Resources.background));
			
			//music
			FlxG.playMusic(MeleeMenu, 0);
			
			//mouse
			FlxG.mouse.show();
			
			//create and display the back button			
			backButton = new FlxButton(530, 500, null, goBack); //button that goes back to the menu
			backButton.loadGraphic(imgBackButton);			
			add(backButton);
			
			//create the how to play text
			infoText = new FlxText(100, 100, 600);
			infoText.text = "Use the left and right arrow keys to move, the spacebar to jump, and Z to use attacks. \n Pressing Z while holding a direction (up, side, and down) will perform a different attack depending on the direction, and each character has a different set of moves. \n The objective of VS Mode is to knock your opponent off of the screen while keeping yourself on screen. Every attack that lands will deal damage, called 'Percent'. The more percentage you have, the further attacks will knock you backwards. \n If you get knocked off of the stage, you will want to use both of your jumps, then use your up attack to try and 'recover' back up to the stage. \n \n The objective of the Ditto Minigame is to keep the Ditto (purple guy) in the air as long as possible using atacks. When the Ditto touches the ground again, your score will be compared and recorded in the highscores list.";
			infoText.size = 10;
			add(infoText);
		}
		
		//function that changes the game state
		private function goBack():void
		{
			FlxG.switchState(new MenuState); //go back to the main menu
		}
	}
}
