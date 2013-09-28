package iceteroids.screen 
{
	import flash.display.Sprite;
	import iceteroids.Document;
	import caurina.transitions.Tweener;
	public class Screen extends Sprite
	{
		protected var doc:Document;
		
		public function Screen(aDoc:Document) 
		{
			// constructor code
			doc = aDoc;
		}
		
		public function bringIn():void
		{
			//Set the y so the screen is off-stage
			y = stage.stageHeight;
			//Set the alpha to 0
			alpha = 0;
			//Add a Tween that moves y to 0, and alpha to 1,
			//with a time of 1.7 seconds, using the "easeOutQuad" transition type
			Tweener.addTween(this, {y:0, alpha:1, time:1.7, transition: "easeInSine"});
		}
		public function bringOut():void
		{	
			Tweener.addTween(this, {y:0, alpha:0, time:1, transition: "easeOutBounce", onComplete:cleanUp()});
			//cleanUp();
		}
		public function cleanUp():void
		{
			if(parent != null)
			{
				stage.focus = doc;
				parent.removeChild(this);
			}
		}

	}
	
}
