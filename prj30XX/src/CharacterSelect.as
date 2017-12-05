package
{
	//Name: Elliot, Charmaine
	//Date: June 11, 2016
	//Title: CharacterSelect.as
	//Description: The screen where the player chooses their fighter and can choose which gamemode to play
	import org.flixel.*;
 
	public class CharacterSelect extends FlxState
	{
		//buttons
		private var vsModeButton:FlxButton;
		private var dittoModeButton:FlxButton;
		private var backButton:FlxButton;
		[Embed(source = "../assets/VSButton.png")] protected var imgVSButton:Class;
		[Embed(source = "../assets/DittoButton.png")] protected var imgDittoButton:Class;
		[Embed(source = "../assets/backButton.png")] protected var imgBackButton:Class;
		
		//character select buttons
		private var p1Omastar:FlxButton;
		private var p1Ampharos:FlxButton;
		private var p1Lucario:FlxButton;
		[Embed(source = "../assets/p1Oma.png")] protected var imgP1Oma:Class;
		[Embed(source = "../assets/p1Amp.png")] protected var imgP1Amp:Class;
		[Embed(source = "../assets/p1Luc.png")] protected var imgP1Luc:Class;
		
		//character select states
		private var player2rng:int;
		
		//text
		private static var infoText:FlxText;
		
		//music
		[Embed(source = "../assets/Melee Menu Piano.mp3")] protected var MeleeMenu:Class;
 
		public function CharacterSelect()
		{
		}
 
		override public function create():void
		{
			add(new FlxSprite(0, 0, Resources.background));
			
			//music
			FlxG.playMusic(MeleeMenu, 0);
			
			//mouse
			FlxG.mouse.show();
			
			//create and display buttons for selecting characters
			p1Omastar = new FlxButton(60, 100, null, p1ChooseOma);
			p1Omastar.loadGraphic(imgP1Oma);
			add(p1Omastar);
			
			p1Ampharos = new FlxButton(190, 100, null, p1ChooseAmp);
			p1Ampharos.loadGraphic(imgP1Amp);
			add(p1Ampharos);
			
			p1Lucario = new FlxButton(320, 100, null, p1ChooseLuc);
			p1Lucario.loadGraphic(imgP1Luc);
			add(p1Lucario);
			
			//create and display buttons for changing the state
			vsModeButton = new FlxButton(530, 90, null, startVsGame); //button that starts the VS mode
			vsModeButton.loadGraphic(imgVSButton);
			add(vsModeButton);
			
			dittoModeButton = new FlxButton(530, 250, null, startDittoGame); //button that starts the minigame
			dittoModeButton.loadGraphic(imgDittoButton);			
			add(dittoModeButton);
			
			backButton = new FlxButton(530, 410, null, goBack); //button that goes back to the menu
			backButton.loadGraphic(imgBackButton);			
			add(backButton);
			
			//create text that will alert the player if they haven't chosen a character
			infoText = new FlxText(450, 300, 100);
			add(infoText);
			
			//Reset the player's character to unselected, in case it was changed earlier
			Resources.player1Char = "none";
			
			//generate the AI player's character
			player2rng = Math.round(Math.random() * 2) + 3; //generate a number between 3-5, which corresponds to the 3 fighters the AI can play as
			if (player2rng == 3) Resources.player2Char = "Omastar";
			else if (player2rng == 4) Resources.player2Char = "Ampharos";
			else if (player2rng == 5) Resources.player2Char = "Lucario";
			
		}
		
		//functions that will determine the character a player has selected
		private function p1ChooseOma():void
		{
			Resources.player1Char = "Omastar"; //this variable will get passed off to the various gamemodes so your character you selected will be properly displayed
		}
		
		private function p1ChooseAmp():void
		{
			Resources.player1Char = "Ampharos";
		}
		
		private function p1ChooseLuc():void
		{
			Resources.player1Char = "Lucario";
		}
		
		//functions that change the game state
		private function startVsGame():void
		{
			if (Resources.player1Char != "none") //check that the player has selected a character
			{
				FlxG.switchState(new PlayState); //switch to the VS mode state
			}
			else
			{
				infoText.text = "Please select a character first!"; //let the player know that they haven't selected a character yet
			}
		}
		
		private function startDittoGame():void
		{
			if (Resources.player1Char != "none") //check that the player has selected a character
			{
				FlxG.switchState(new DittoStage); //switch to the Minigame state
			}
			else
			{
				infoText.text = "Please select a character first!"; //let the player know that they haven't selected a character yet
			}
		}
		
		private function goBack():void
		{
			FlxG.switchState(new MenuState); //go back to the main menu
		}
	}
}
