package
{
	//Name: Charmaine, Elliot
	//Date: May 31, 2016
	//Title: AI.as
	//Desc: The class for all the CPU controller characters
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class AI extends Fighter
	{
		//X: x-coord
		//Y: y-coord
		//image: the AI's image
		//sWidth: the width of each frame of the image
		//sHeight, same as sWidth, but height
		//Reverse: If the sprite can be flipped
		
		private var cdTimer2:Number;
		private var cdLength2:Number = 2;
		
		public function AI(X:Number, Y:Number, image:Class, sWidth:int, sHeight:int, Reverse:Boolean=true)
		{
			super(X, Y, image, sWidth, sHeight); //Pass params off to Fighter
		}
		
		override public function update():void
		{
			
			if (Math.abs(velocity.x) > 0)
			{
				play("walk");
			}
			else
			{
				play("idle");
			}
			
			//If the AI's fallen off the stage, move them back to the top.
			if (x < -50 || y > 1000)
			{
				x = FlxG.width / 2 - 5;
				y = 0;
				percent = 0;
			}
			
			//AI stuff
			var playerCoord:FlxPoint = Resources.fighters.members[0].getCoord(); //Get the player's location
			var thisCoord:FlxPoint = new FlxPoint(x + (width / 2), y + height); //Get this AI's location
			if (x < 20 || x > 720) //If the AI is nearly off the ledge, go back to the center
			{
				followPath(new FlxPath([new FlxPoint(360, 0)]), 200, PATH_HORIZONTAL_ONLY);
			}
			
			if (!paused && !onCooldown && !helpless) //If the AI isn't on cooldown
			{
				if (playerCoord.y >= thisCoord.y) //If the player is at the same level as or below the AI, use sideB
				{
					if (Math.abs(playerCoord.x - thisCoord.x) < 90)
					{
						sideB();
					}
				}
				else //If not, try to jump
				{
					if (jumpCount > 0)
					{
						jump();
					}
					else
					{
						upB();
					}
				}
				
				if (Math.abs(playerCoord.x - thisCoord.x) > 90) //If the player is far away from the AI, randomly either use NeutralB (a ranged attack) or get closer
				{
					if (Math.random() < 0.4)
					{
						neutralB();
					}
					else
					{
						followPath(new FlxPath([playerCoord]), 200, PATH_HORIZONTAL_ONLY);
					}
				}
				
				//If the player is left of the AI, face left, and vice versa
				if (playerCoord.x < thisCoord.x)
				{
					facing = FlxObject.LEFT;
				}
				else
				{
					facing = FlxObject.RIGHT;
				}
			}
			else
			{
				//The cooldown timer
				cdTimer += FlxG.elapsed;
				if (cdTimer >= cdLength)
				{
					onCooldown = false;
					cdLength = 0.25;
					cdTimer = 0;
				}
			}
			
			if (isTouching(FlxObject.FLOOR)) //Reset the jumps the character has and disable helpless when they touch the ground and they don't have all their jumps
			{
				if (jumpCount < 2)
					jumpCount = 2;
					
				if (helpless)
					helpless = false;
			}
		}
	}
}