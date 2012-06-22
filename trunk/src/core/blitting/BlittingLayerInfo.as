package core.blitting
{

	public class BlittingLayerInfo
	{
		public var id:String;
		
		protected var _zdeept:int;
			public function get zdeept():int { return _zdeept; }
			
		protected var _renderCopy : Boolean ;
			public function get renderCopy():Boolean { return _renderCopy; }
			
		protected var _renderSmoothing : Boolean ;
			public function get renderSmoothing():Boolean { return _renderSmoothing; }
		
		protected var _renderLists:Vector.<BListPool>
			public function get renderLists():Vector.<BListPool> { return _renderLists; }
			
		public function BlittingLayerInfo( $id : String, $zdeept:int, $renderCopy : Boolean = true , $smoothing : Boolean = false)
		{
			id = $id;
			_zdeept = $zdeept;
			_renderCopy = $renderCopy;
			_renderSmoothing = $smoothing;
			_renderLists= new Vector.<BListPool>();
		}
		public function addRenderList($v:BListPool):void
		{
			_renderLists.push($v);
		}
		public function removeRenderList($v:BListPool):void
		{
			var idx:int = _renderLists.indexOf($v);
			if (idx!=-1)
			_renderLists.splice(idx,1);
		}
		public function removeAllLists():void
		{
			_renderLists.length=0;
		}
	}
}