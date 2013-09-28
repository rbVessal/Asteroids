package iceteroids.screen 
{
	
	import flash.display.MovieClip;
	import iceteroids.Document;
	import iceteroids.screen.TitleScreen;
	import flash.utils.Timer;
	import caurina.transitions.Tweener;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class LoseScreen extends Screen 
	{
		
		//private var timer:Timer;
		public var titleBtn:SimpleButton;
		public function LoseScreen(aDoc:Document) 
		{
			// constructor code
			super(aDoc);
		}
		
		public override function bringIn():void
		{
			super.bringIn();
			titleBtn.addEventListener(MouseEvent.CLICK, onTitleScreen);
			//doc.displayScreen(this);
			//timer.start();
			//timer.addEventListener(TimerEvent.TIMER, onTitleScreen);
			//doc.displayScreen(LoseScreen);
			//super.cleanUp();
			
		}
		public function onTitleScreen(e:MouseEvent):void
		{
			doc.displayScreen(TitleScreen);
			//super.cleanUp();
			//timer.delay = 2000;
			//timer.reset();
			//Tweener.addTween(this, {y:0, alpha:1, time:1.7, delay: 20, transition: "easeInSine"});
			
		}
		public override function cleanUp():void
		{
			titleBtn.removeEventListener(MouseEvent.CLICK, onTitleScreen);
						
			super.cleanUp();
		}
	}
	
}
