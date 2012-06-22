package core.blitting.cachedGFX
{

	
	import flash.display.BitmapData;
	
	public class CachedFrame 
	{
		public var bitmapData : BitmapData ;
		public var pivotX : int;
		public var pivotY : int;
		public var width : int;
		public var height : int;
		
		public function CachedFrame( $bmp : BitmapData, $pivotX : int, $pivotY : int ) : void
		{
			bitmapData = $bmp;
			
			pivotX = $pivotX;
			pivotY = $pivotY;
			
			width = bitmapData.width;
			height = bitmapData.height;
		}
		
		public function clear () : void
		{
			bitmapData.dispose () ;
			bitmapData = null ;
		}
		
	}
	 
}