package iceteroids.screen 
{
	
	import flash.display.MovieClip;
	import iceteroids.Document;
	import iceteroids.screen.TitleScreen;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class WinScreen extends Screen
	{
		public var titleBtn:SimpleButton;
		
		public function WinScreen(aDoc:Document) 
		{
			// constructor code
			super(aDoc);
		}
		
		public override function bringIn():void
		{
			super.bringIn();
			titleBtn.addEventListener(MouseEvent.CLICK, onTitle);
		}
		
		public function onTitle(e:MouseEvent):void
		{
			doc.displayScreen(TitleScreen);
		}
		
		public override function cleanUp():void
		{
			titleBtn.removeEventListener(MouseEvent.CLICK, onTitle);
						
			super.cleanUp();
		}
	}
	
}
