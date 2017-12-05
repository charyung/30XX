package 
{
	//Name: Charmaine, Elliot
	//Date: May 31, 2016
	//Title: mMelee.as
	//Desc: The class for all the melee attacks
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class mMelee extends Move //Close ranged moves
	{
		private var direction:String;
		private var user:Fighter;
		private var dmg:Number;
		private var kb:Number;
		private var kbAngle:Number;
		private var keepMoveWithUser:Boolean;
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
		//pauseUser: Whether the attack pauses the user
		//keepMoveWithUser: Whether the attack moves as the user also moves
		
		public function mMelee(direction:String, X:int, Y:int, sWidth:int, sHeight:int, img:Class, frames:int, user:Fighter, dmg:Number, kb:Number, kbAngle:Number=45, fps:int=30, pauseUser:Boolean=true, keepMoveWithUser:Boolean=false) 
		{
			solid = true;
			this.user = user;
			this.direction = direction;
			this.dmg = dmg;
			this.kb = kb;
			this.kbAngle = kbAngle;
			this.keepMoveWithUser = keepMoveWithUser;
			
			super (X, Y, sWidth, sHeight, img, frames, user, dmg, kb, kbAngle, fps, pauseUser);
			
			xOffset = x - user.x; //Set xOffset according to how far away this sprite's top left corner is from the user's sprite's top left corner, on the x axis
			yOffset = y - user.y; //Set yOffset according to how far away this sprite's top left corner is from the user's sprite's top left corner, on the y axis
			
			if (user.facing == FlxObject.LEFT) //Make the sprite face the appropriate direction depending on the user's facing
			{ 
				facing = FlxObject.LEFT;
			}
			
			play("shoot");
		}
		
		override public function update():void
		{
			if (finished) //When the animation's done, delete itself and let the player move agian
			{
				user.startMovement();
				kill();
			}
			
			if (keepMoveWithUser) //If the attack is set to move with the move, move with them.
			{
				x = user.x + xOffset;
				y = user.y + yOffset;
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
					Resources.fighters.members[i].percent += dmg;
				}
			}
			
			//If the attack is an upB move, send the user up.
			if (FlxCollision.pixelPerfectCheck(this, user) && direction == "up")
			{
				user.y--; //Give the player a very slight boost upwards, because for whatever reason the next line doesn't work if the player is on the ground.
				user.velocity.y = -user.maxVelocity.y * kb * 0.25;
			}
		}
	}

}