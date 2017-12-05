package 
{
	//Name: Charmaine, Elliot
	//Date: May 31, 2016
	//Title: mProjectile.as
	//Desc: The class for all projectile moves
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class mProjectile extends Move //Projectiles
	{
		private var user:Fighter;
		private var dmg:Number;
		private var kb:Number;
		private var kbAngle:Number;
		
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
		
		public function mProjectile(X:int, Y:int, sWidth:int, sHeight:int, img:Class, frames:int, user:Fighter, dmg:Number, kb:Number, kbAngle:Number=45, fps:int=30, pauseUser:Boolean=true) 
		{
			this.user = user;
			this.dmg = dmg;
			this.kb = kb;
			this.kbAngle = kbAngle;
			
			super (X, Y, sWidth, sHeight, img, frames, user, dmg, kb, kbAngle, fps, pauseUser);
			
			//Make the sprite face the appropriate direction depending on the user's facing
			if (user.facing == FlxObject.LEFT)
			{ 
				facing = FlxObject.LEFT;
				acceleration = (new FlxPoint(-1000, 0));
			}
			else if (user.facing == FlxObject.RIGHT)
			{
				acceleration = (new FlxPoint(1000, 0));
			}
		}
		
		override public function update():void
		{
			if (finished) //If the animation is done, let the player move again
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
					
					Resources.fighters.members[i].percent += dmg;
					
					kill(); //Delete itself on collision
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