/////////////////////////////////////////////////////

//Tick.as -- used for time-based accurate motion and fps counter

/////////////////////////////////////////////////////

//usage:

//call getFtime() once per frame to update the value (Tick.ftime) 

//multiply Tick.ftime onto all speed values. (ex: mc.x += speed*Tick.ftime)

package core.updater
{
	
	import flash.utils.getTimer;
	
	public class Tick 
	{
		
		//---------------------------------------
		
		private static var oldtime:int=0;
		public static  var ftime:Number=0;
		public static  var fps:uint=0;
		public static  var secs:int=getTimer();
		public static  var fps_txt:uint=0;
		
		//---------------------------------------
		
		public static function getFtime():void {
			
			ftime=(getTimer()-oldtime)/1000;
			fps++;
			if ((getTimer()-secs)>1000) {
				secs=getTimer();
				fps_txt=fps;
				fps=0;
			}
			oldtime=getTimer();
		}
		//---------------------------------------
	}
}
