package 
{
	//Name: Charmaine, Elliot
	//Date: May 31, 2016
	//Title: Fighter.as
	//Desc: The class for all the resources
	
	import org.flixel.*;
	 
	public class Resources 
	{
		public static var fighters:FlxGroup;
		
		[Embed(source = "../assets/temporalTower.png")] public static var tempTower:Class;
		[Embed(source = "../assets/bg.png")] public static var background:Class; //background image
		[Embed(source="../assets/ditto.png")] public static var ditto:Class; //27, 22
		[Embed(source = "../assets/Super DFttF.mp3")] public static var BattleMusic:Class; //music that plays
		
		//Omanyte
		[Embed(source="../assets/omastar2.png")] public static var omastar:Class; //51, 44
		[Embed(source="../assets/omastar2S.png")] public static var omastarS:Class; //51, 44
		[Embed(source = "../assets/rockBlast.png")] public static var rockBlast:Class;
		[Embed(source = "../assets/scald.png")] public static var scald:Class;
		[Embed(source = "../assets/surf.png")] public static var surf:Class;
		[Embed(source = "../assets/whirlpool.png")] public static var whirlpool:Class;
		
		//Ampharos
		[Embed(source = "../assets/ampharos.png")] public static var ampharos:Class; // 60, 71
		[Embed(source = "../assets/ampharosS.png")] public static var ampharosS:Class; // 60, 71
		[Embed(source = "../assets/chargeBeamCharge.png")] public static var chargeBeamCharge:Class;
		[Embed(source = "../assets/thunderPunch.png")] public static var thunderPunch:Class;
		[Embed(source = "../assets/magnetRise.png")] public static var magnetRise:Class; //50, 60, 15 FPS
		[Embed(source = "../assets/thunder2.png")] public static var thunder:Class; //65, 14
		
		//Lucario
		[Embed(source = "../assets/lucario.png")] public static var lucario:Class; //51, 62
		[Embed(source = "../assets/lucarioS.png")] public static var lucarioS:Class; //51, 62
		[Embed(source = "../assets/auraSphere.png")] public static var auraSphere:Class;
		[Embed(source = "../assets/boneRush.png")] public static var boneRush:Class;
		[Embed(source = "../assets/highJumpKick.png")] public static var highJumpKick:Class; //(x + 27), (y + 12); 18, 20
		[Embed(source = "../assets/closeCombat.png")] public static var closeCombat:Class; //(x + 41), (y + 18); 23, 13
		
		public static var player1Char:String = "none";
		public static var player2Char:String = "none";
		
		public function Resources() 
		{
		}
		
	}

}