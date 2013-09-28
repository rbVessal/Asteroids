package iceteroids.screen 
{
	import flash.display.Sprite;
	import iceteroids.Document;
	public class ScreenClass extends Sprite
	{
		protected var doc:Document;
		
		
		public function ScreenClass(aDoc:Document) 
		{
			// constructor code
			doc = aDoc;
		}
		
		public function bringIn():void
		{
			
		}
		public function bringOut():void
		{
			cleanUp();
		}
		public function cleanUp():void
		{
			
		}

	}
	
}
