package
{
	//Name: Elliot, Charmaine
	//Date: May 31, 2016
	//Title: PlayState.as
	//Description: The "VS Mode", primary game mode where you fight an AI player
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PlayState extends FlxState
	{
		public var stageImage:FlxSprite;
		public var player:Fighter;
		public var enemy:AI; 
		public var ground:FlxGroup; //this group is required so we can have fighters collide with the ground
		
		//percent variables
		public static var p1Percent:FlxText;
		public static var p2Percent:FlxText;
		//public var p1Char:int; //0-2, Oma/Amp/Luc, regular, controlled by p1
		//public var p2Char:int; //3-5, Oma/Amp/Luc, shiny, controlled by p2
		
		private var startX:int = 0;
		
		override public function create():void
		{
			//groups, these allow us to have the fighters collide with the ground
			Resources.fighters = new FlxGroup();
			ground = new FlxGroup();
			
			add(new FlxSprite(0, 0, Resources.background));
			
			//stage sprites and hitboxes
			stageImage = new FlxSprite(75, 275, Resources.tempTower);
			stageImage.height -= 236; //alters the hitbox around the stage so it is somewhat smaller than the sprite
			stageImage.width -= 40;
			stageImage.offset = new FlxPoint(8, 106); //this offsets the stage's hitbox from the default (which is just a rectangle around the image). The adjustment lets us give the stage a pseudo-3D effect, where the player stand infront of the "back" part of the image
			stageImage.moves = false; //this line and the following 3 lines make is so we can collide with the stage, and the stage won't move around as attacks and fighters hit it
			stageImage.immovable = true;
			stageImage.solid = true;
			ground.add(stageImage);
			add(stageImage);
			
			//percent
			p1Percent = new FlxText(10, 10, 500);
			p1Percent.size = 10;
			p2Percent = new FlxText(10, 25, 500);
			p2Percent.size = 10;
			add(p1Percent);
			add(p2Percent);
			
			add(new FlxText(600, 30, 200, "Press [Esc] to return to character selection any time"));
			
			//Make player
			if (Resources.player1Char == "Omastar") Resources.fighters.add(add(new Fighter(FlxG.width / 2 - 5, 150, Resources.omastar, 51, 44)));
			else if (Resources.player1Char == "Ampharos") Resources.fighters.add(add(new Fighter(FlxG.width / 2 - 5, 150, Resources.ampharos, 60, 64)));
			else if (Resources.player1Char == "Lucario") Resources.fighters.add(add(new Fighter(FlxG.width / 2 - 5, 150, Resources.lucario, 53, 62)));
			
			//Make AI
			if (Resources.player2Char == "Omastar") Resources.fighters.add(add(new AI(300, 150, Resources.omastarS, 51, 44)));
			else if (Resources.player2Char == "Ampharos") Resources.fighters.add(add(new AI(300, 150, Resources.ampharosS, 60, 64)));
			else if (Resources.player2Char == "Lucario") Resources.fighters.add(add(new AI(300, 150, Resources.lucarioS, 53, 62)));
			
			//music
			FlxG.playMusic(Resources.BattleMusic, 0);
		}
		
		override public function update():void
		{
			super.update();
			
			//percent gauges
			p1Percent.text = "Player percentage: " + Resources.fighters.members[0].percent + "%";
			p2Percent.text = "CPU percentage: " + Resources.fighters.members[1].percent + "%";
			
			//collisions
			FlxG.collide(Resources.fighters, ground); //make it so fighters collide with the ground
			
			//If the player presses escape, return to the character selection screen
			if (FlxG.keys.justReleased("ESCAPE"))
				FlxG.switchState(new CharacterSelect);
				
			//Victory conditions, doesn't deserve its own state because it's so minor
			if (Resources.fighters.members[0].x < -20 || Resources.fighters.members[0].x > 820 || Resources.fighters.members[0].y > 800)
			{
				FlxG.switchState(new VictoryState(Resources.fighters.members[1]));
			}
			else if (Resources.fighters.members[1].x < -20 || Resources.fighters.members[1].x > 820 || Resources.fighters.members[1].y > 800)
			{
				FlxG.switchState(new VictoryState(Resources.fighters.members[0]));
			}
		}
	}
}