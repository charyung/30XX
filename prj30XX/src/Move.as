package 
{
	//Name: Charmaine, Elliot
	//Date: May 31, 2016
	//Title: Resources.as
	//Desc: The class in which all the move types inherit from
	
	import adobe.utils.CustomActions;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	 
	public class Move extends FlxSprite
	{
		private var direction:String;
		private var user:Fighter;
		private var dmg:Number;
		private var kb:Number;
		private var kbAngle:Number;
		private var keepUserInPlace:Boolean;
		
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
		
		public function Move(X:int, Y:int, sWidth:int, sHeight:int, img:Class, frames:int, user:Fighter, dmg:Number, kb:Number, kbAngle:Number=45, fps:int=30, pauseUser:Boolean=false) 
		{
			this.direction = direction;
			this.user = user;
			this.dmg = dmg;
			this.kb = kb;
			this.kbAngle = kbAngle;
			
			super(X, Y);
			
			if (pauseUser) //If the attack is set to stop the user from moving, stop them.
			{
				user.stopMovement();
			}
			
			var framesArr:Array = new Array(); //Make an array for all the numbers from 0 to frames for addAnimation below
			for (var i:int = 0; i < frames; i++)
			{
				framesArr.push(i);
			}
			
			loadGraphic(img, true, true, sWidth, sHeight);
			addAnimation("shoot", framesArr, fps, false); //Add an animation with the frames array and according to fps
			
			play("shoot");
		}
		
		override public function update():void //Empty because every type of attack is slightly different
		{
		}
		
		override public function kill():void //Whenever a move deletes itself, let the player move again
		{
			user.startMovement();
			super.kill();
		}
	}

}