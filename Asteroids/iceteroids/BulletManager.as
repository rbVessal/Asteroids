package iceteroids 
{
	import flash.geom.Point;
	
	public class BulletManager 
	{
		private var allBullets: Array = new Array();
		private var activeBullets: Array = new Array();
		private var pooledBullets: Array = new Array();
		private var game: Game;
		private var speed: Number;
		private var lifespan:int;
		
		public function BulletManager(aGame:Game, aSize: int = 20, aSpeed:Number = 15, aLifeTime:int = 60) 
		{
			// constructor code
			game = aGame;
			speed = aSpeed;
			lifespan = aLifeTime;
			
			for(var i:int = 0; i< aSize; i++)
			{
				allBullets.push(new Bullet(game));
			}
			
			pooledBullets = allBullets.concat();
			
			
		}
		
		//Create a public function fireBullet in BulletManager
		//Expect same arguments as Bullet's fire method
		//Return type of Boolean
		public function fireBullet(aPos: Point, aRot:Number, ivx:Number, ivy:Number):Boolean
		{
			//Make sure we have bullets availabe in our pool
			if(pooledBullets.length > 0)
			{
				//If so, pop one off the end of the pool
				var b: Bullet  = pooledBullets.pop();
				
				//Calculate its movement values
				//which are compounded onto the passed in movement values
				var rotAsRad:Number = aRot * Math.PI/180;
				ivx += Math.cos(rotAsRad) * speed;
				ivy += Math.sin(rotAsRad) * speed;
				
				//Tell the bullet to fire
				b.fire(aPos, aRot, ivx, ivy);
				
				//Add the bullet to activeBullets, and the display list
				activeBullets.push(b);
				game.bLayer.addChild(b);
				//b.visible = false;
				
				//We fired a bullet, so return true!
				return true;
			}
			//No bullets available, return false
			return false;
		}
		
		public function update():void
		{
			//A tempoaray bullet holding var
			var b: Bullet;
			
			//Iterate over active bullets
			for(var i: int = 0; i< activeBullets.length; i++)
			{
				//cast activeBullets[i] as a Bullet and save it in b
				b = (activeBullets[i] as Bullet);
				
				//Move the bullet
				b.move();
				
				//Make the bullet older
				b.age++;
				
				//If the bullet is too old
				if(b.age > lifespan)
				{
					//Remove it from activeBullets
					activeBullets.splice(i, 1);
					//Add it to pooledBullets
					pooledBullets.push(b);
					//Remove it from the display list
					game.bLayer.removeChild(b);
					//Decrement i (so we don't skip the bullet that was next)
					i--;
					
				}
			}
		}
		
		//public accessor for the activeBullets array
		public function get ActiveBullets():Array
		{
			return activeBullets;
		}
		
		public function killBullet(b:Bullet, index:int):void
		{
			activeBullets.splice(index, 1);
			pooledBullets.push(b);
			game.bLayer.removeChild(b);
		}
		
		public function destroyActiveBullets(b:Bullet, index:int)
		{
			//pooledBullets.pop();
			//b.visible = false;
			activeBullets.splice(index, 1);
			pooledBullets.push(b);
			game.bLayer.removeChild(b);
		}

	}
	
}
