package iceteroids 
{
	
	import flash.display.MovieClip;
	import com.as3toolkit.ui.Keyboarder;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import iceteroids.screen.*;
	import iceteroids.screen.TitleScreen;
	
	
	public class Document extends MovieClip 
	{
		private var game:Game;
		private var kb: Keyboarder;
		//Declare private var to hold the XML we are about to load
		private var levelXML:XML;
		private var currentScreen:Screen;
		//private var titleScreen:TitleScreen;
		
		public function Document() 
		{
			super();
			// constructor code
			trace(this + " created");
			
			//Instantiate Keyboarder
			kb = new Keyboarder(this);
			var xmlRequest:URLRequest = new URLRequest("levels.xml");
			var xmlLoader:URLLoader = new URLLoader(xmlRequest);
			//Add an event listenr to xmlLoader
			xmlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
			
		}
		
		function onXMLLoaded(e:Event):void
		{
			levelXML = new XML(e.target.data);
			trace(levelXML);
			//titleScreen = new TitleScreen(this);
			displayScreen(TitleScreen);
			/*game = new Game(levelXML);
			addChild(game);
			//Call begin method from game
			game.begin();*/
			
			
		}
		
		public function displayScreen(screenClass:Class):void
		{
			if(currentScreen != null)
			{
				currentScreen.bringOut();
			}
			
			if(screenClass == Game)
			{
				//The next line creates a new "screenClass"
				currentScreen = game = new Game(levelXML, this);
				
				//Add currentScreeen to the display list
				addChild(game);
				game.begin();
				game.bringIn();
			}
			else
			{
				currentScreen = new screenClass(this);
				addChild(currentScreen);
				currentScreen.bringIn();
			}
			
			//Tell the currentScreen to bringIn()
			//currentScreen.bringIn();
		}
	}
	
}
