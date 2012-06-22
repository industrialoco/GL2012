package  core.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;


	public class FPS_Counter extends Sprite
	{
		
		private var fpsHistory:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ;
		private var fpsCounter:TextField;
		private var currentTime:uint;
		private var oldTime:uint;
		
		
		public function FPS_Counter() 
		{
			fpsCounter = new TextField ();
			addChild(fpsCounter);
			fpsCounter.text = "---"+"fps";
			fpsCounter.textColor = 0x000000;
			currentTime = (new Date()).milliseconds;
			oldTime = currentTime;
			
			this.addEventListener ( Event.ENTER_FRAME, onEnterFrame_handler )
		}
		
		private function onEnterFrame_handler ( evt : Event ):void
		{		
			currentTime = (new Date()).milliseconds ;
			var dt : int = currentTime - oldTime ;
			fpsHistory.push(dt) ;
			fpsHistory.shift() ; 
			var avg_dt : int = 0
			for ( var i : int = 0 ; i < fpsHistory.length ; i++ )
			{
				avg_dt += fpsHistory[i]
			}
			avg_dt = avg_dt / fpsHistory.length 
			fpsCounter.text = int(1000/avg_dt)+"fps" ;
			oldTime = currentTime ;			
		}
		
	}
	
}