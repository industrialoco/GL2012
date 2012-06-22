package core.blitting 
{
	
	import core.blitting.cachedGFX.CachedClip;
	import core.blitting.cachedGFX.CachedFrame;
	import core.collisions.GameRect;
	import core.gameObjects.GameGroup;
	import core.mem.Mem;
	import core.newstatics.BasicData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BlittingLayer extends GameGroup
	{
		public var bitmap:Bitmap;
		
		protected var _blittingLayerInfo:BlittingLayerInfo;
			public function get blittingLayerInfo():BlittingLayerInfo { return _blittingLayerInfo; }
			
		public var offset:Point;
		
		private var offsetX:int;
		private var offsetY:int;
		
		protected var _layerRec : Rectangle;
			public function get layerRec():Rectangle { return _layerRec; }
		
		protected var _renderRec 		: Rectangle 		= Mem.rect.get() as Rectangle;
		protected var _renderMatrix	: Matrix				= new Matrix ();
		protected var _renderPoint 	: Point 				= Mem.point.get() as Point;
		protected var _renderColTrans : ColorTransform		= null ;
		
		protected var hasContentToErase : Boolean ;
		
		private var bitmapData:BitmapData;
		private var bitmapDataWidth:int;
		private var bitmapDataHeight:int;

		public function BlittingLayer($blinfo:BlittingLayerInfo, $width : int, $height : int ) : void
		{
			$width *= Display_Scaling.SCALE ;
			$height *= Display_Scaling.SCALE ;
			bitmap = new Bitmap( new BitmapData ( $width, $height, true, 0x00000000), "auto", false );
			super (null);
			
			offset = Mem.point.get() as Point;
			BasicData.stage.addChildAt(bitmap, 0);
			_layerRec = Mem.rect.get() as Rectangle;
			_layerRec.width = $width;
			_layerRec.height = $height;
			_blittingLayerInfo = $blinfo;
			
			hasContentToErase = false ;
			bitmapData = bitmap.bitmapData;
			bitmapDataWidth = bitmapData.width;
			bitmapDataHeight = bitmapData.height;
		}

		public function destroy () : void
		{
			removeAllLists () ;
			_blittingLayerInfo = null;
			if ( bitmap.parent )
				bitmap.parent.removeChild ( this.bitmap );
			bitmap.bitmapData.dispose();
			bitmap.bitmapData = null;
			bitmap = null;
			bitmapData = null;
		}
		
		public function removeAllLists () : void
		{
			blittingLayerInfo.removeAllLists ();
		}
		
		private var renderListsLength:int;
		private var iterat1:int;
		private var renderLists:Vector.<BListPool>;
		private var myList:BListPool;
		private var myClip:CachedClip;
		private var myFrame:CachedFrame;

		protected override function updating($step:uint):void
		{
			super.updating($step);

			if ( !this.bitmap.root ) return ;

			renderLists = blittingLayerInfo.renderLists;
			renderListsLength = blittingLayerInfo.renderLists.length;
			
			for ( iterat1 = 0 ; iterat1 < renderListsLength ; ++iterat1 )
			{				
				myList = renderLists[iterat1] ;
				
				if ( myList.head )
					myClip = myList.head ;
				else
					continue ;
				
				while ( myClip )
				{					
					if ( myClip.isPlaying )
					myClip.update();
					myClip = myClip.next;
				}
				myList = null;
			}
			renderListsLength = 0;
			iterat1 = 0;
			renderLists = null;
			myList = null;
			myClip = null;
		}
		protected override function rendering():void
		{
			if ( !this.bitmap.root ) return ;
			
			offsetX = offset.x;
			offsetY = offset.y;
			
			bitmapData.lock();

			if ( hasContentToErase )
			{
				bitmapData.fillRect ( _layerRec, 0x11FFFFFF );
				hasContentToErase = false ;
			}
			renderLists = blittingLayerInfo.renderLists as Vector.<BListPool>;
			renderListsLength = blittingLayerInfo.renderLists.length;
			for ( iterat1 = 0 ; iterat1 < renderListsLength ; ++iterat1 )
			{				
				myList = renderLists[iterat1] as BListPool;

				if ( myList.head )
					myClip = myList.head as CachedClip ;
				else
					continue ;
					
				while ( myClip )
				{					
					if ( myClip.visible && myClip.animation && onScreen(myClip))
					{
						myFrame	= myClip.frame as CachedFrame;
						_renderColTrans = myClip.colorTransform as ColorTransform;
						
						if ( _blittingLayerInfo.renderCopy && !_renderColTrans && myClip.rotation == 0 && myClip.blendMode == null) 
						{
							_renderRec.width 	= myFrame.width;
							_renderRec.height 	= myFrame.height;
							_renderPoint.x 		= myClip.x * Display_Scaling.SCALE - myFrame.pivotX;
							_renderPoint.y		= myClip.y * Display_Scaling.SCALE - myFrame.pivotY;
							_renderPoint.x      += offsetX;
							_renderPoint.y      += offsetY;

							bitmapData.copyPixels( myFrame.bitmapData, _renderRec, _renderPoint, null, null , true);
						}
						else
						{	
							_renderMatrix.identity ();
							_renderMatrix.translate ( - myFrame.pivotX, - myFrame.pivotY );
							_renderMatrix.scale ( myClip.scaleX, myClip.scaleY ) ;
							if ( myClip.rotation != 0 )
								_renderMatrix.rotate ( myClip.rotation / 180 * 3.14159 ); 
							_renderMatrix.translate ( myClip.x * Display_Scaling.SCALE , myClip.y * Display_Scaling.SCALE );

							_renderMatrix.translate ( offsetX, offsetY); 
							bitmapData.draw ( myFrame.bitmapData, _renderMatrix, _renderColTrans, myClip.blendMode, null, _blittingLayerInfo.renderSmoothing )
						}
						myFrame = null;
						hasContentToErase = true ;
					}
					myClip = myClip.next as CachedClip;
				}
				myList = null;
			}
			bitmapData.unlock();
			
			renderListsLength = 0;
			iterat1 = 0;
			renderLists = null;
			myList = null;
			myClip = null;
			myFrame = null;
		}
		
		protected function onScreen($c:CachedClip):Boolean
		{
			if ($c.left > (bitmapDataWidth-offsetX))
				return false;
			if ($c.right < -offsetX)
				return false;
			if ($c.top > (bitmapDataHeight-offsetY))
				return false;
			if ($c.bottom < -offsetY)
				return false;
			return true;
		}
		public function setSize($r:GameRect):void
		{
			bitmap.x = $r.x;
			bitmap.y = $r.y;
			bitmap.bitmapData.dispose();
			bitmap.bitmapData = new BitmapData ( $r.width, $r.height, true, 0x00000000 );
			bitmapData = bitmap.bitmapData;
			bitmapDataWidth = bitmapData.width;
			bitmapDataHeight = bitmapData.height;
		}
		public function clone():BlittingLayer
		{
			var o:BlittingLayer = new BlittingLayer( blittingLayerInfo, bitmap.width, bitmap.height);
			return o;
		}
	}
}