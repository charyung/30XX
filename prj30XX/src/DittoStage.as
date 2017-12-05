package
{
	//Name: Elliot, Charmaine
	//Date: June 8, 2016
	//Title: DittoStage.as
	//Description: The minigame where you try and keep a dummy in the air for as long as possible
	import flash.utils.Timer;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class DittoStage extends FlxState
	{
		//http://forums.flixel.org/index.php/topic,3189.0.html
		//http://forums.flixel.org/index.php?topic=3453.0
		
		public var stageImage:FlxSprite;
		public var player:Fighter;
		public var enemy:AI;
		public var ground:FlxGroup;
		
		private var sprite:FlxSprite;
		private var path:FlxPath;
		private var pathEnd:FlxPoint;
		private var coordText:FlxText;
		private var dittoAir:Timer;
		
		private var startX:int = 0;
		
		//highscores
		private var highscoresList:FlxText;
		private var highscoresArray:Array;
		private var currentScore:int;
		private var attemptInProgress:Boolean;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			FlxG.mouse.show();
			Resources.fighters = new FlxGroup();
			ground = new FlxGroup();
			
			add(new FlxSprite(0, 0, Resources.background));
			
			//Stage
			stageImage = new FlxSprite(75, 275, Resources.tempTower);
			stageImage.height -= 236;
			stageImage.width -= 40;
			stageImage.offset = new FlxPoint(8, 106);
			
			stageImage.moves = false;
			stageImage.immovable = true;
			stageImage.solid = true;
			ground.add(stageImage);
			add(stageImage);
			
			sprite = new FlxSprite(10, 255);
			
			//make player
			player = new Fighter(FlxG.width/2 - 5, 0, Resources.omastar, 51, 44);
			add(player);
			Resources.fighters.add(player);
			
			//enemy = new AI(100, 256, ditto, 27, 22);
			enemy = new AI(300, 100, Resources.ditto, 27, 22);
			add(enemy);
			Resources.fighters.add(enemy);
			
			//coordText = new FlxText(10, 10, 500);
			//add(coordText);
			
			//music
			FlxG.playMusic(Resources.BattleMusic, 0);
			
			//highscores
			highscoresList = new FlxText(50, 30, 500);
			add(highscoresList);
			dittoAir = new Timer(100, 0); //makes a timer tick every tenth of a second, each tick will be a point
			highscoresArray = new Array();
			for (var x:int = 0; x < 10; x++)
			{
				highscoresArray[x] = 0;
			}
			highscoresArray[9] = 0;
			listHighscores();
			
			add(new FlxText(600, 30, 200, "Press [Esc] to return to character selection any time"));
		}
		
		override public function update():void
		{			
			super.update();
			
			//coordText.text = Resources.fighters.members[0].percent + ", " + Resources.fighters.members[1].percent + ", " + Resources.fighters.members[2].percent + ", " + dittoAir.currentCount;
			
			FlxG.collide(Resources.fighters, ground);
			FlxG.collide(Resources.fighters, Resources.fighters);
			
			if (!Resources.fighters.members[1].isTouching(FlxObject.FLOOR))
			{
				dittoAir.start();
				attemptInProgress = true;
			}
			else if (Resources.fighters.members[1].isTouching(FlxObject.FLOOR))
			{
				currentScore = dittoAir.currentCount;
				dittoAir.stop();
				dittoAir.reset();
				if (attemptInProgress == true) //this check is necessary because otherwise it attempts to run everything under this every frame ditto is on the ground, causing massive framerate issues
				{
					attemptInProgress = false;
					if (currentScore > highscoresArray[9])
					{
						highscoresArray[9] = currentScore;
						quicksort(highscoresArray, 0, 9);
						listHighscores();
					}
				}
			}
			
			//If the player presses escape, return to the character selection screen
			if (FlxG.keys.justReleased("ESCAPE"))
				FlxG.switchState(new CharacterSelect);
		}
		
		public function listHighscores():void
		{
			highscoresList.text = "";
			for (var x:int = 0; x < 10; x++)
			{
				highscoresList.text += (x+1) + ". " + highscoresArray[x] + "\n"; 				
			}
		}
		
		//******** DEMONSTRATING QUICKSORT ***********
		//using quicksort to sort and display a highscores list
		private function quicksort(a:Array, l:int, r:int):void
		{
			//a: Array being sorted
			//l: Left
			//r: Right
			var temp:int = 0; //To hold the number being swapped, like in bubblesort
			var p:int = l;
			var lo:int = l;
			var ro:int = r;
		   
			if (l < r)
			{
				while (a[r] < a[p]) //While the number being compared is less than the pivot
				{
					r--; //move the right marker left
				}
				temp = a[p]; //swap
				a[p] = a[r];
				p = r;
				a[r] = temp;
				
				while (a[l] > a[p])
				{
					l++;
				}
				temp = a[p];
				a[p] = a[l];
				p = l;
				a[l] = temp;
				
				quicksort(a, lo, p - 1);
				quicksort(a, p + 1, ro);
			}
		}
	}
}