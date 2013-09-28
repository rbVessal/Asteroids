package iceteroids 
{
	import flash.display.Sprite;
	import flash.events.*;
	import com.as3toolkit.events.KeyboarderEvent;
	import com.as3toolkit.ui.Keyboarder;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import iceteroids.screen.Screen;
	import iceteroids.screen.*;
	
	public class Game extends Screen
	{
		//asteroids will hold the Asteroid objects in play
		private var asteroids:Array;
		private var player: Player;
		public var aLayer: Sprite = new Sprite();//asteroids
		public var bLayer: Sprite = new Sprite();//bullet
		public var pLayer: Sprite = new Sprite();//player
		public var uLayer: Sprite = new Sprite();//UFO
		private var isOver:Boolean = false;
		
		private var hud:HUD;

		private var levelXML:XML;
		private var currentLevel:int = -1;
		
		private var ufoSpawnTimer:Timer;
		private var ufos:Array = new Array();
		
		public function Game(xml:XML, aDoc:Document) 
		{
			// constructor code
			trace(this + " created");
			super(aDoc);
			hud = new HUD(xml.hud[0]);
			levelXML = xml;
		}
		
		public function begin():void
		{
			
			//Set up the layers in desired order
			addChild(hud);
			addChild(aLayer);
			addChild(bLayer);
			addChild(pLayer);
			addChild(uLayer);
			//instantiate our Array - no length or type necessary
			//ActionScript Arrays hold references to objects
			asteroids = new Array();
			
			//Instantiate the player
			player = new Player(this);
			pLayer.addChild(player);
			
			//Add the UFO to the uLayer
			//uLayer.addChild();
			
			//Intialize ufoSpawnTimer
			//the delay value will change in nextLevel()
			ufoSpawnTimer = new Timer(1000,0);
			
			
			nextLevel();
			addEventListener(Event.ENTER_FRAME, update);
			
			//Keyboarder.Instance gets us a reference to the Keyboarder class from anywhere
			//addEventListener should be familar...just new Events
			Keyboarder.Instance.addEventListener(KeyboarderEvent.FIRST_PRESS, onKP);
			Keyboarder.Instance.addEventListener(KeyboarderEvent.RELEASE, onKR);
			//Add an event listener for ufoSpawnTimer that calls a onSpawnUFO function
			ufoSpawnTimer.start();
			ufoSpawnTimer.addEventListener(TimerEvent.TIMER, onSpawnUFO);
		}
		
		public function update(e:Event):void
		{
			//Tell each of the ufos to move
			var u:UFO;
			for(var us:int = 0; us<ufos.length; us++)
			{
				u = ufos[us];
				u.move();
				u.bulletMan.update();
				
				for(var p:int = 0; p< u.bulletMan.ActiveBullets.length; p++)
				{
					b = u.bulletMan.ActiveBullets[p];
					
					if(b.hitTestObject(player))
					{
						if(player.hitTestPoint(b.x, b.y, true))
						{
							u.bulletMan.killBullet(b, p);
							u.bulletMan.destroyActiveBullets(b, p);
							if(hud.Lives > 0)
							{
								hud.takeLives(1);
								player.destroy();
							}
							
							else
							{
								gameOver();
							}
							return;
						}
					}
				}
				
				for(var pb:int = 0; pb< player.bulletManager.ActiveBullets.length; pb++)
				{
					b = player.bulletManager.ActiveBullets[pb];
					if(b.hitTestObject(u))
					{
						if(u.hitTestPoint(b.x, b.y, true))
						{
							player.bulletManager.killBullet(b, pb);
							hud.addPoints(1000);
							u.destroy();
							//removeChild(u);
							ufos.splice(us, 1);
							break;
						}
					}
				}
				
				if(u.hitTestObject(player))
				{
					if(player.hitTestPoint(u.x, u.y, true))
					{
						hud.addPoints(500);
						u.destroy();
						ufos.splice(us, 1);
						if(hud.Lives > 0)
						{
							hud.takeLives(1);
							player.destroy();
							
						}
						else
						{
							gameOver();
						}
						us--;
						return;
					}
				}
			}
			
			//update the player's bullets
			player.bulletManager.update();
			//Declare some temp holders
			var a: Asteroid;
			var b:Bullet;
			
			//For tacking whether bullets killed the asteroid
			var aWasDestroyed: Boolean;
			
			for(var j: int = 0; j <asteroids.length; j++)
			{
				//Change what was in the loop to this
				//because we need to get at an Asteroid more than once.
				//we'll save it into a 
				a = asteroids[j] as Asteroid;
				//move just like before
				a.move();
				//reset aWasDestroyed
				aWasDestroyed = false;
				
				//Add a for-loop that will iterate over ActiveBullets
				for(var k: int = 0; k< player.bulletManager.ActiveBullets.length; k++)
				{
					//Create a temp reference to the current bullet
					b = player.bulletManager.ActiveBullets[k] as Bullet;
					
					//Check the bounding boxes
					if(b.hitTestObject(a))
					{
						//if that cheap test passed, check the pixels
						if(a.hitTestPoint(b.x, b.y, true))
						{
							//If that more expensive test passed,
							//destroy the asteroid!
							//(make sure you modify Asteroid class 
							//to remove the click event!)
							a.destroy();
							
							//Decrement j by one, because we don't 
							//want to skip over the asteroid that 
							//takes a's place in the array!
							j--;
							
							//Mark aWasDestroyed as true
							aWasDestroyed = true;
							
							//call killBullet()
							player.bulletManager.killBullet(b, k);
							break;
						}//end if hitTestPoint
					}//end if hitTestObject
					
					/*if(b.hitTestObject(u))
					{
						u.destroy();
					}
					for(var m: int = 0; m<u.bulletMan.ActiveBullets.length; m++)
					{
						var uBull = u.bulletMan.ActiveBullets[m] as Bullet;
						if(uBull.hitTestObject(player))
						{
							
							hud.takeLives(1);
							player.destroy();
						}
					}*/
				}//end inner bullet loop
				
				//So long as the asteroid was not destroyed by a bullet
				if(aWasDestroyed == false && player.respawning == false && 
				   isOver == false)
				{
					//To a quick test against the player
					if(a.hitTestObject(player))
					{
						//To a more precise test against the player
						if(a.hitTestPoint(player.x, player.y, true))
						{
							//Destroy the asteroid
							a.destroy();
							//Remember to decrement j
							j--;
							//If there are still lives to lose
							if(hud.Lives > 0)
							{
								//update the lives
								hud.takeLives(1);
								//Destroy the player
								player.destroy();
							}
							else
							{
								//otherwise it's game over, man
								gameOver();
							}
						}
						   
					}
				}
				if(isOver == false)
				{
					player.doKeys();
					player.move();
				}
			}//end outer asteroid loop
			//player.bulletManager.update();
			player.doKeys();
			player.move();
			
			if(asteroids.length == 0)
			{
				nextLevel();
			}
			
		}
		
		public function destroyAsteroid(a:Asteroid):void
		{
			//indexOf() searches an Array for some element
			//if found, it returns that index
			//if not found, it returns -1
			
			//find the index of the Asteroid that was destroyed
			var index: int = asteroids.indexOf(a);
			
			//if that index is valid
			if(index > -1)
			{
				//splice() removes elements from an Array by index
				//the first number specifices where to start
				//the second number specifies how many elements to remove
				
				//remove one Asteroid from the Array starting at
				//asteroids[index]
				asteroids.splice(index, 1);
				//add points to score for each asteroid destoryed
				hud.addPoints(100);
			}
			
			if(a.scaleX > 0.6)
			{
				//make some baby asteroids
				spawnChildAsteroids(a);
			}
			trace("There are " + asteroids.length + " asteroids left!");
		}
		
		public function spawnChildAsteroids(a:Asteroid):void
		{
			//ca is a temperorary local child-Asteroid
			var ca: Asteroid;
			
			//make 3 new Asteroid objects
			//addchild them onto the Display List
			for(var i: int = 0; i<3; i++)
			{
				ca = new Asteroid(this);
				aLayer.addChild(ca);
				ca.init(levelXML.levels[0].level[currentLevel].asteroids[0]);
				ca.x = a.x;
				ca.y = a.y;
				//make our new asteroids a little evil
				ca.scaleX = ca.scaleY = a.scaleX * 0.66;
				asteroids.push(ca);
			}
		}
		
		//onKP is short for "onKeyPressed"
		private function onKP(e:KeyboarderEvent):void
		{
			//switch statements are like a chain of if/if else/if else/else
			//but easier to read
			
			switch(e.keyCode)
			{
				case Keyboard.UP:
				{
					trace("up pressed");
					player.up_mc.visible = true;
					trace(player.up_mc.visible);
					break;
				}
				case Keyboard.LEFT:
				{
					trace("left pressed");
					player.left_mc.visible = true;
					trace(player.left_mc.visible);
					break;
				}
				case Keyboard.RIGHT:
				{
					trace("right pressed");
					player.right_mc.visible = true;
					trace(player.right_mc.visible);
					break;
				}
				default:
				{
					trace("some other key pressed " + e.keyCode);
					break;
				}
			}
		}
		
		///onKR is short for "onKeyRelease"
		private function onKR(e:KeyboarderEvent): void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
				{
					trace("up released");
					player.up_mc.visible = false;
					trace(player.up_mc.visible);
					break;
				}
				case Keyboard.LEFT:
				{
					trace("left released");
					player.left_mc.visible = false;
					trace(player.left_mc.visible);
					break;
				}
				case Keyboard.RIGHT:
				{
					trace("right released");
					player.right_mc.visible = false;
					trace(player.right_mc.visible);
					break;
				}
				default:
				{
					trace("some other key released " + e.keyCode);
					break;
				}
			}
		}
		
		public function gameOver():void
		{
			player.visible = false;
			hud.message_txt.text = "Game Over";
			isOver = true;
			//Set ufoSpawnTimer to stop
			ufoSpawnTimer.stop();
			(parent as Document).displayScreen(LoseScreen);
			cleanUp();
		}
		
		public function nextLevel():void
		{
			//Increment current level
			currentLevel++;
			//Compare our currentLevel to the number of levels available
			//Notice the cast to XMLList..and that XMLList's .length()
			//is diff. than Array's .length
			//Array's .length is a property, XMLList's .length() is a function
			if(currentLevel < (levelXML.levels[0].level as XMLList).length())
			{
				var a:Asteroid;
				var l:XML = levelXML.levels[0].level[currentLevel];
				
				//How many asteroids
				var numroids:int = l.asteroids[0].@number;
				
				for(var i: int = 0; i< numroids; i++)
				{
					a = new Asteroid(this);
					aLayer.addChild(a);
					//pass the asteroids node in to the Asteroid's init()
					a.init(l.asteroids[0]);
					asteroids.push(a);
				}
				player.init(l.player[0]);
				
				ufoSpawnTimer.delay = l.UFO.@spawnDelay;
				ufoSpawnTimer.reset();
				
				
			}
			
			else
			{
				isOver = true;
				hud.message_txt.text = "You Win!";
				(parent as Document).displayScreen(WinScreen);
			}
		}
		
		//Stub for onSpawnUFO function
		public function onSpawnUFO(e:TimerEvent):void
		{
			trace("Timer: " + e);
			var ufo:UFO = new UFO(this, player);
			uLayer.addChild(ufo);
			ufo.init(levelXML.levels.level[currentLevel].UFO[0]);
			ufos.push(ufo);
			
			trace("Cordinates of UFO: " + ufo.x + ufo.y);
			
			
		}
		
		public override function cleanUp():void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			
			//Keyboarder.Instance gets us a reference to the Keyboarder class from anywhere
			//addEventListener should be familar...just new Events
			Keyboarder.Instance.removeEventListener(KeyboarderEvent.FIRST_PRESS, onKP);
			Keyboarder.Instance.removeEventListener(KeyboarderEvent.RELEASE, onKR);
			//Add an event listener for ufoSpawnTimer that calls a onSpawnUFO function
			//ufoSpawnTimer.start();
			ufoSpawnTimer.removeEventListener(TimerEvent.TIMER, onSpawnUFO);
			for(var i:int = 0; i<ufos.length; i++)
			{
				ufos[i] = null;
			}
		}
		
		
		
		

	}
	
}
