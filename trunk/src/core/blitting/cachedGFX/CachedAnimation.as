package core.blitting.cachedGFX
{
	import core.blitting.Display_Scaling;
	import core.mem.Mem;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class CachedAnimation
	{
		public var id : String ;

		public var framesArray : Array = Mem.array.get() as Array;
		
		public var length : int;	
		
		public function CachedAnimation( $mcToCache : MovieClip, $id : *, $cycleChildren : Boolean = true , $label:FrameLabel=null) : void
		{
			id = String ( $id );
			var mc : MovieClip = $mcToCache;

			var l : int = mc.totalFrames
			var rect : Rectangle ;
			var matrix : Matrix = new Matrix ();
			var decalX : int ;
			var decalY : int ;
			var colorTransform:ColorTransform = mc.transform.colorTransform ;
			
			mc.scaleX *= Display_Scaling.SCALE ;
			mc.scaleY *= Display_Scaling.SCALE ;
			
			for ( var i : int = 1 ; i <= l ; ++i )
			{
				mc.gotoAndStop ( i );
				if ($label == null || mc.currentLabel == $label.name)
				{
					// TODO: getbounds devuelve nuevo rectangulo, hacerlo a mano.
					rect = mc.getBounds( mc );
					
					matrix.identity();
					
					matrix.scale( mc.scaleX, mc.scaleY );	
					matrix.rotate( mc.rotation );
					
					if ( mc.scaleX > 0 )
						decalX = int( -rect.x * mc.scaleX ) ;
					else
						decalX = int( -(rect.width + rect.x) * mc.scaleX )  ;
					
					if ( mc.scaleY > 0 )
						decalY = int( -rect.y * mc.scaleY ) ;
					else
						decalY = int( -(rect.height + rect.y) * mc.scaleY )  ;
					
					matrix.translate( decalX, decalY );
					
					var bitmapData:BitmapData = new BitmapData( mc.width, mc.height, true, 0x00000000 );
					bitmapData.draw( mc, matrix, colorTransform );
					
					framesArray.push ( new CachedFrame ( bitmapData, decalX, decalY ) );
					
					bitmapData = null;
				}
				var k : int =  mc.numChildren
				for ( var j : int = 0 ; j < k; ++j )
				{
					
					var child : MovieClip =  mc.getChildAt(j) as MovieClip ;
					
					if ( child )
					{
						
						if ( child.currentFrame == child.totalFrames )
						{
							if ( $cycleChildren )
								child.gotoAndStop ( 1 ) ;
						}
						else
							child.gotoAndStop(child.currentFrame+1) ;
					}
				}
			}
			
			mc = null ;
			rect = null;
			matrix = null;
			colorTransform = null;
		}
		protected function getBoundingRectangle(object:DisplayObject):Rectangle 
		{
			var rotation:Number = object.rotation;
			if (rotation < 0) {
				rotation = 360 + rotation;
			}
			
			var position:Point = new Point(object.x, object.y);
			if ((rotation > 0) && (rotation < 360)) {
				if (rotation < 90) {
					position.x -= object.height * Math.sin(rotation);
				}
				else if (rotation == 90) {
					position.x -= object.width;
				}
				else if (rotation < 180) {
					position.x -= object.width;
					position.y -= object.width * Math.sin(rotation);
				}
				else if (rotation == 180) {
					position.x -= object.width;
					position.y -= object.height;
				}
				else if (rotation < 270) {
					position.x -= object.height * Math.sin(rotation);
					position.y -= object.height;
				}
				else if (rotation == 270) {
					position.y -= object.height;
				}
				else {
					position.y -= object.width * Math.sin(rotation);
				}
			}
			
			return (new Rectangle( position.x, position.y, object.width, object.height));
		}

		public function clear () : void
		{
			length = 0 ;
			var aFrame : CachedFrame ;
			
			while ( framesArray.length > 0 )
			{
				aFrame = framesArray.pop() ;
				aFrame.clear () ;
			}
			framesArray.length=0;
			Mem.array.put(framesArray);
			framesArray = null ;
		}
		
	}
	
}