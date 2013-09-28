package iceteroids.screen 
{
	import iceteroids.Document;
	import iceteroids.Game;
	import iceteroids.screen.InstructionsScreen;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class TitleScreen extends Screen
	{
		public var playBtn:SimpleButton;
		public var instructionsBtn:SimpleButton;
		public function TitleScreen(aDoc:Document) 
		{
			// constructor code
			super(aDoc);
		}
		
		public override function bringIn():void
		{
			//The next line calls the superclass' bringIn();
			super.bringIn();
			//Add a MouseEvent.ClICK listener to playBtn that calls onPlay
			playBtn.addEventListener(MouseEvent.CLICK, onPlay);
			instructionsBtn.addEventListener(MouseEvent.CLICK, onInstructions);
		}
		
		private function onPlay(e:MouseEvent):void
		{
			//Tell the Document class to display the Game screen
			doc.displayScreen(Game);
		}
		
		private function onInstructions(e:MouseEvent):void
		{
			doc.displayScreen(InstructionsScreen);
		}
		
		public override function cleanUp():void
		{
			//Remove event listener for the playBtn
			playBtn.removeEventListener(MouseEvent.CLICK, onPlay);
			instructionsBtn.removeEventListener(MouseEvent.CLICK, onInstructions);
			//Call the superclass' cleanup()
			super.cleanUp();
		}
		

	}
	
}
