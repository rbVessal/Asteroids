package iceteroids.screen 
{
	
	import flash.display.SimpleButton;
	import iceteroids.Document;
	import iceteroids.screen.TitleScreen;
	import iceteroids.Game;
	import flash.events.MouseEvent;
	
	public class InstructionsScreen extends Screen
	{
		
		public var titleBtn:SimpleButton;
		public var gameBtn:SimpleButton;
		public function InstructionsScreen(aDoc:Document) 
		{
			// constructor code
			super(aDoc);
		}
		
		public override function bringIn():void
		{
			super.bringIn();
			titleBtn.addEventListener(MouseEvent.CLICK, onTitle);
			gameBtn.addEventListener(MouseEvent.CLICK, onGame);
		}
		
		private function onTitle(e:MouseEvent):void
		{
			doc.displayScreen(TitleScreen);
		}
		
		private function onGame(e:MouseEvent):void
		{
			doc.displayScreen(Game);
		}
		
		public override function cleanUp():void
		{
			titleBtn.removeEventListener(MouseEvent.CLICK, onTitle);
			gameBtn.removeEventListener(MouseEvent.CLICK, onGame);
			
			super.cleanUp();
		}
		
	}
	
}
