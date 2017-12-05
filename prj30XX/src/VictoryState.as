package 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Chair
	 */
	public class VictoryState extends FlxState
	{
		
		public function VictoryState(Victor:Fighter) 
		{
			var winText:FlxText = new FlxText(50, 100, 700);
			winText.size = 100;
			
			if (Victor == Resources.fighters.members[0])
				winText.text = "Player wins!";
			else if (Victor == Resources.fighters.members[1])
				winText.text = "CPU wins!";
				
			var returnText:FlxText = new FlxText(50, 300, 700, "Press [Esc] to return to character select screen.");
			
			add(winText);
			add(returnText);
		}
		
		public override function update():void
		{
			if (FlxG.keys.justReleased("ESCAPE"))
				FlxG.switchState(new CharacterSelect);
		}
		
	}

}