package core.blitting 
{
	import core.blitting.cachedGFX.CachedClip;
	
	public class BListPool extends BListBase
	{
		
		protected var _freeList : BListBase ;
		protected var _poolSize : int ;
		protected var _poolGrowthRate : int ;

		public function BListPool(p_poolSize : int, p_poolGrowthRate : int) 
		{
			super() ;
			
			_poolSize		= p_poolSize ;
			_poolGrowthRate	= p_poolGrowthRate ;
			_freeList		= new BListBase() ;
			
			increasePoolSize(_poolSize) ;
		}

		protected function increasePoolSize(p_size : int) : void
		{
			var i : int ;
			for (i = 0; i < p_size; ++i)
			{
				_freeList.append( new CachedClip( null ) ) ;
			}
		}

		public function create( p_addToTail : Boolean ) : CachedClip
		{
			if ( !_freeList.head )
			{
				increasePoolSize(_poolGrowthRate ) ;
				trace("increase BList poolsize! : " + _freeList.length) ;
			}
			
			var clip : CachedClip = _freeList.removeHead() ;
			
			if (p_addToTail) 
				append( clip );
			else 
				prepend( clip );
			
			return clip ;
		}

		public function dispose( p_clip : CachedClip ) : void
		{
			p_clip.visible = true ;
			p_clip.isPlaying = true ;
			p_clip.colorTransform = null ;
			p_clip.animation = null;
			_freeList.append( remove( p_clip ) ) ;
		}
		
		override public function clear () : void
		{
			super.clear() ;
			_freeList.clear() ;
			_freeList = null ;
		}
		
		override public function dump() : String
		{
			var output : String ;
			
			output = super.dump() ;
			
			output += "\nfreelist : \n" + _freeList.dump() ;
			
			return output ;
		}
		
	}
	
}