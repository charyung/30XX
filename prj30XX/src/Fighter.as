package
{
	//Name: Charmaine, Elliot
	//Date: May 31, 2016
	//Title: Fighter.as
	//Desc: The class for all the fighting characters
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.utils.getQualifiedClassName;
	
	public class Fighter extends FlxSprite //INHERITANCE
	
	{
		private var move:Move;
		private var species:String;
		
		public var charging:Boolean = false; //If the player is in the middle of using an mCharge move
		public var onCooldown:Boolean = false; //If the player is on cooldown and isn't allowed to use another move
		protected var cdLength:Number = 0.25; //Cooldown length
		protected var cdTimer:Number = 0; //The cooldown timer, to see if the player is still on cooldown
		protected var jumpCount:int = 2; //The amount of jumps a player gets
		protected var helpless:Boolean = false; //If the character just used upB
		
		public var percent:int = 0;
		public var paused:Boolean = false;
		
		public function Fighter(X:Number, Y:Number, image:Class, sWidth:int, sHeight:int, Reverse:Boolean=true)
		{
			super(X, Y);
			loadGraphic(image, true, true, sWidth, sHeight);
			maxVelocity.x = 100;
			maxVelocity.y = 500;
			acceleration.y = 500;
			drag.x = maxVelocity.x * 4;
			species = getQualifiedClassName(image);
			
			addAnimation("walk", [0, 1], 10); //Walking
			addAnimation("idle", [0], 0, false); //Doing nothing
			addAnimation("extra1", [2, 3], 10, false); //This and the following ones are just for the characters that have more than 2 frames of animation for their attacks
			addAnimation("extra2", [4, 5], 1, false);
			addAnimation("extra3", [6, 7], 1, false);
			addAnimation("extra4", [8], 0, false);
			addAnimation("extra5", [9, 10, 9, 10, 9, 10], 60, false);
		}
		
		override public function update():void
		{
			acceleration.x = 0; //Slow the player down
			if (!paused && !onCooldown) //If the player hasn't just finished using a move
			{
				if (FlxG.keys.LEFT) //Movement and attacks being used
				{
					acceleration.x = -maxVelocity.x * 4;
					facing = LEFT;
					
					if (FlxG.keys.justPressed("Z") && !helpless)
					{
						sideB();
					}
					else
					{
						play("walk");
					}
				}
				else if (FlxG.keys.RIGHT)
				{
					acceleration.x = maxVelocity.x * 4;
					facing = RIGHT;
					
					if (FlxG.keys.justPressed("Z") && !helpless)
					{
						sideB();
					}
					else
					{
						play("walk");
					}
				}
				else if (FlxG.keys.UP)
				{
					if (FlxG.keys.justPressed("Z") && !helpless)
					{
						upB();
					}
				}
				else if (FlxG.keys.DOWN)
				{
					if (FlxG.keys.justPressed("Z") && !helpless)
					{
						downB();
					}
				}
				else
				{
					if (FlxG.keys.justPressed("Z") && !helpless)
					{
						neutralB();
					}
					else
					{
						if (!charging)
						{
							play("idle");
						}
					}
					
				}
				
				if (FlxG.keys.justPressed("SPACE") && !helpless)
				{
					jump();
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
			
			//The the player's fallen off the stage, move them back to the top.
			if (y > 1000)
			{
				x = FlxG.width / 2 - 5;
				y = 0;
				percent = 0;
			}
			
			super.update();
		}
		
		//The following functions, named [direction]B, are the player's attacks. They change according to the species of the fighter.
		protected function neutralB():void
		{
			if (species == "Resources_omastar" || species == "Resources_omastarS")
			{
				cdLength = 1;
				onCooldown = true;
				if (facing == FlxObject.LEFT)
				{
					move = new mProjectile((x - 25), (y + 14), 30, 30, Resources.rockBlast, 6, this, 1, 1);
				}
				else if (facing == FlxObject.RIGHT)
				{
					move = new mProjectile((x + 46), (y + 14), 30, 30, Resources.rockBlast, 6, this, 1, 1);
				}
			}
			else if (species == "Resources_ampharos" || species == "Resources_ampharosS")
			{
				cdLength = 1;
				onCooldown = true;
				if (facing == FlxObject.LEFT)
				{
					move = new mCharge((x - 5), y, 40, 20, Resources.chargeBeamCharge, 5, this, 1, 5, 45);
				}
				else if (facing == FlxObject.RIGHT)
				{
					move = new mCharge((x + width + 5), y, 40, 20, Resources.chargeBeamCharge, 5, this, 1, 5, 45);
				}
			}
			else if (species == "Resources_lucario" || species == "Resources_lucarioS")
			{
				play("extra1");
				charging = true;
				cdLength = 1;
				onCooldown = true;
				if (facing == FlxObject.LEFT)
				{
					move = new mCharge(x, (y + 22), 13, 13, Resources.auraSphere, 5, this, 1, 1);
				}
				else if (facing == FlxObject.RIGHT)
				{
					move = new mCharge((x + 44), (y + 22), 13, 13, Resources.auraSphere, 5, this, 1, 1);
				}
			}
			
			FlxG.state.add(move);
		}
		
		protected function sideB():void
		{
			if (species == "Resources_omastar" || species == "Resources_omastarS")
			{
				cdLength = 0.5;
				onCooldown = true;
				if (facing == FlxObject.LEFT)
				{
					move = new mMelee("side", (x - 45), (y + 34), 60, 5, Resources.scald, 6, this, 1.5, 0.5);
				}
				else if (facing == FlxObject.RIGHT)
				{
					move = new mMelee("side", (x + 36), (y + 34), 60, 5, Resources.scald, 6, this, 1.5, 0.5);
				}
			}
			else if (species == "Resources_ampharos" || species == "Resources_ampharosS")
			{
				cdLength = 0.5;
				onCooldown = true;
				if (facing == FlxObject.LEFT)
				{
					play("extra1");
					move = new mMelee("side", x, y, 60, 61, Resources.thunderPunch, 6, this, 1.5, 0.5);
				}
				else if (facing == FlxObject.RIGHT)
				{
					play("extra1");
					move = new mMelee("side", x, y, 60, 61, Resources.thunderPunch, 6, this, 1.5, 0.5);
				}
			}
			else if (species == "Resources_lucario" || species == "Resources_lucarioS")
			{
				onCooldown = true;
				play("extra2");
				//play("extra3");
				
				if (facing == FlxObject.LEFT)
				{
					move = new mMelee("side", x, (y + 31), 53, 5, Resources.boneRush, 3, this, 1.5, 0.5, 30, 10, true, true);
				}
				else if (facing == FlxObject.RIGHT)
				{
					
					move = new mMelee("side", x, (y + 31), 53, 5, Resources.boneRush, 3, this, 1.5, 0.5, 30, 10, true, true);
				}
			}
			
			FlxG.state.add(move);
		}
		
		protected function upB():void
		{
			if (species == "Resources_omastar" || species == "Resources_omastarS")
			{
				move = new mMelee("up", x, (y - (height / 2)), 30, 60, Resources.surf, 12, this, 0.2, 3, 45, 15);
			}
			else if (species == "Resources_ampharos" || species == "Resources_ampharosS")
			{
				play("extra2");
				move = new mMelee("up", (x + 5), (y + 19), 50, 60, Resources.magnetRise, 12, this, 0.2, 3, 45, 15);
			}
			else if (species == "Resources_lucario" || species == "Resources_lucarioS")
			{
				play("extra4");
				move = new mMelee("up", (x + 27), (y + 12), 18, 20, Resources.highJumpKick, 1, this, 0.1, 4, 90, 0, false, true);
			}
			
			helpless = true;
			FlxG.state.add(move);
		}
		
		protected function downB():void
		{
			if (species == "Resources_omastar" || species == "Resources_omastarS")
			{
				move = new mMelee("down", (x - (width / 2)), (y + height - 9), 120, 10, Resources.whirlpool, 13, this, 3, 0.1, 45, 30);
			}
			else if (species == "Resources_ampharos" || species == "Resources_ampharosS")
			{
				play("extra2");
				if (facing == FlxObject.LEFT)
				{
					velocity.y = -10;
					move = new mMelee("down", (x - 42), (y + 27), 65, 14, Resources.thunder, 4, this, 3, 0.1, 45, 5);
				}
				else if (facing == FlxObject.RIGHT)
				{
					velocity.y = -10;
					move = new mMelee("down", (x + 37), (y + 27), 65, 14, Resources.thunder, 4, this, 3, 0.1, 45, 5);
				}
			}
			else if (species == "Resources_lucario" || species == "Resources_lucarioS")
			{
				onCooldown = true;
				cdTimer = 1;
				play("extra5");
				if (facing == FlxObject.LEFT)
				{
					move = new mMelee("down", (x - 11), (y + 18), 23, 13, Resources.closeCombat, 2, this, 5, 0.5, 20, 60);
				}
				else if (facing == FlxObject.RIGHT)
				{
					move = new mMelee("down", (x + 41), (y + 18), 23, 13, Resources.closeCombat, 2, this, 5, 0.5, 20, 60);
				}
			}
				
			FlxG.state.add(move);
		}
		
		//Jumping. It simply sends the player up as long as they have jumps.
		protected function jump():void
		{
			if (jumpCount > 0)
			{
				velocity.y = -maxVelocity.y / 2;
				jumpCount--;
			}
		}
		
		//Gets the coordinate of the player, except it shifts the given location to the center of the player's sprite for AI distance detection purposes.
		public function getCoord():FlxPoint
		{
			return new FlxPoint(x + (width / 2), y + height);
		}
		
		//Knock the fighter back.
		//direction: The direction to knock the fighter back in
		//knockback: How much to knock the fighter back by
		//kbAngle: The angle to knock the fighter back at
		public function knockback(direction:String, knockback:Number, kbAngle:Number):void
		{	
			maxVelocity.x = 1000; //Let the player go as far as the attack sends them
			maxVelocity.y = 1000;
			
			var radAngle:Number = (kbAngle * Math.PI) / 180; //Change kbAngle to radian because that's what Flixel uses
			
			if (direction == "left") //from the left, hitting the character right
			{
				velocity.x = drag.x * (Math.sin(radAngle) * knockback) * (0.1 * percent);
				y--;
				velocity.y = (Math.cos(radAngle) * knockback) * (0.1 * percent) * -1;
			}
			else if (direction == "right") //from the right, hitting the character left
			{
				velocity.x = drag.x * (Math.sin(radAngle) * knockback) * (0.1 * percent) * -1;
				y--;
				velocity.y = (Math.cos(radAngle) * knockback) * (0.1 * percent) * -1;
			}
			
			maxVelocity.x = 100; //Reset max movement speed back to normal
			maxVelocity.y = 500;
		}
		
		//Stops the player from moving, used by the attacks
		public function stopMovement():void
		{
			paused = true;
		}
		
		//Restart the player's movement, also used by the attacks
		public function startMovement():void
		{
			paused = false;
		}
	}
}