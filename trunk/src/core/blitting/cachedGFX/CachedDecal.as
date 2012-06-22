package core.blitting.cachedGFX 
{
	
	import core.blitting.Display_Scaling;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class CachedDecal 
	{
	
		public var id : String ;
		
		public var bitmapData : BitmapData ;
		public var pivotX : int ;
		public var pivotY : int ;
		public var width : int ;
		public var height : int ;
		
		public function CachedDecal( $mcToCache : MovieClip, $id : * ) : void
		{
			id = String ( $id );
			var mc : MovieClip = $mcToCache;
			
			mc.scaleX *= Display_Scaling.SCALE ;
			mc.scaleY *= Display_Scaling.SCALE ;

			var rect : Rectangle ;
			var matrix : Matrix = new Matrix ();
			var colorTransform : ColorTransform = mc.transform.colorTransform ;
			
			mc.gotoAndStop ( 1 );
			rect = mc.getBounds( mc );
				
			matrix.identity();
			
			matrix.scale( mc.scaleX, mc.scaleY );	
			matrix.rotate(mc.rotation);
			
			if ( mc.scaleX > 0 )
				pivotX = int( -rect.x * mc.scaleX ) ;
			else
				pivotX = int( -(rect.width + rect.x) * mc.scaleX )  ;
			
			if ( mc.scaleY > 0 )
				pivotY = int( -rect.y * mc.scaleY ) ;
			else
				pivotY = int( -(rect.height + rect.y) * mc.scaleY )  ;
			
			matrix.translate( pivotX, pivotY );
			
			bitmapData = new BitmapData( mc.width, mc.height, true, 0x00000000 );
			bitmapData.draw( mc, matrix, colorTransform );
			
			width = bitmapData.width ;
			height = bitmapData.height ;
			
			mc = null ;
		}
		
		public function clear () : void
		{
			bitmapData.dispose () ;
			bitmapData = null ;
		}
		
	}
	
}