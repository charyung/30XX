package 
{
	//Name: Charmaine, Elliot
	//Date: May 31, 2016
	//Title: mCharge.as
	//Desc: The class for all the moves that require charging
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	 
	public class mCharge extends Move
	{
		private var user:Fighter;
		private var dmg:Number;
		private var kb:Number;
		private var kbAngle:Number;
		private var xOffset:Number; //How far from the top left corner of the user's sprite is this attack's sprite, on the x axis
		private var yOffset:Number; //How far from the top left corner of the user's sprite is this attack's sprite, on the y axis
		
		//X: x-coord
		//Y: y-coord
		//sWidth: the width of each frame of the image
		//sHeight, same as sWidth, but height
		//img: Attack's spritesheet
		//frames: The amount of frames the sprite has
		//user: Who used the attack
		//dmg: The amount of damage the attack deals
		//kb: The amount of knockback the attack deals
		//kbAngle: The angle the attack sends opponents back at
		//fps: The framerate of the animation
		//pauseUser: Whether the attack pauses the use
		
		public function mCharge(X:int, Y:int, sWidth:int, sHeight:int, img:Class, frames:int, user:Fighter, dmg:Number, kb:Number, kbAngle:Number=45, fps:int=30, pauseUser:Boolean=true) 
		{
			this.user = user;
			this.dmg = dmg;
			this.kb = kb;
			this.kbAngle = kbAngle;
			
			super(X, Y, sWidth, sHeight, img, frames, user, dmg, kb, kbAngle, fps, pauseUser);
			
			xOffset = x - user.x; //Set xOffset according to how far away this sprite's top left corner is from the user's sprite's top left corner, on the x axis
			yOffset = y - user.y; //Set yOffset according to how far away this sprite's top left corner is from the user's sprite's top left corner, on the y axis
			
			loadGraphic(img, false, true, sWidth, sHeight);
			
			addAnimation("fire", [(frames)], fps, false);
			
			if (user.facing == FlxObject.LEFT) //Make the sprite face the appropriate direction depending on the user's facing
			{ 
				facing = FlxObject.LEFT;
			}
			
			if (pauseUser) //If the attack is set to stop the user from moving, stop them.
			{
				user.stopMovement();
			}
			
			user.onCooldown = true; //Set the user on cooldown
		}
		
		override public function update():void
		{
			if (_curAnim.name == "shoot") //If the player is still on the first, charging, part of the attack, 
			{
				//Move the attack with the player,
				x = user.x + xOffset;
				y = user.y + yOffset;
				
				//And let the user fire the attack
				if (finished && ((getDefinitionByName(getQualifiedClassName(user)) == "[class Fighter]" && FlxG.keys.justPressed("Z")) || getDefinitionByName(getQualifiedClassName(user)) == "[class AI]"))
				{
					user.charging = false; //The user is no longer charging an attack
					play("fire"); //Play the firing animation
					if (user.facing == FlxObject.LEFT) //Move the sprite according to the direction the user's facing
					{
						acceleration.x = -1000;
					}
					else
					{
						acceleration.x = 1000;
					}
				}
			}
			
			//If the attack is completely finished (i.e. the user has fired the attack), let them move again
			if (_curAnim.name == "fire" && finished)
			{
				user.startMovement();
			}
			
			//Collision check: If the attack collides with anyone who isn't the user, send them back and deal damage to them
			for (var i:int = 0; i < Resources.fighters.length; i++)
			{
				if (FlxCollision.pixelPerfectCheck(this, Resources.fighters.members[i]) && Resources.fighters.members[i] != user)
				{
					if (x < Resources.fighters.members[i].x) //if this is left of enemy
					{
						Resources.fighters.members[i].knockback("left", kb, kbAngle);
					}
					else if (x > Resources.fighters.members[i].x)
					{
						Resources.fighters.members[i].knockback("right", kb, kbAngle);
					}
					kill(); //Delete itself on contact
					Resources.fighters.members[i].percent += dmg;
				}
			}
			
			//When the projectile is off the screen, delete itself
			if (x > 800 + (width * 2) || x < 0 - (width * 2))
			{
				kill();
			}
		}
	}

}