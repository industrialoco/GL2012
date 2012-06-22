package core.blitting.cachedGFX 
{

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class CachedLibrary 
	{
		
		public static var animations : Dictionary = new Dictionary () ;
		public static var tiles : Dictionary = new Dictionary () ;
		
		public static function addAnimation (  $mcToCache : MovieClip, $id : *, $cycleChildren : Boolean = true , $label:FrameLabel=null ) : void
		{
			animations[$id] = new CachedAnimation ( $mcToCache, $id, $cycleChildren , $label ) ;
		}
		private static var tmpLabels:Array;
		
		public static function addAnimations (  $mcToCache : MovieClip, $id : *, $cycleChildren : Boolean = true ) : void
		{
			tmpLabels = $mcToCache.currentLabels;
			if (tmpLabels.length==0)
			{
				addAnimation($mcToCache, $id, $cycleChildren);
				tmpLabels = null;
				return;
			}
			else
			{
				for (var i:int = 0; i < tmpLabels.length; i++) 
				{
					addAnimation($mcToCache, $id+"."+ tmpLabels[i].name , $cycleChildren, tmpLabels[i]);
				}
				tmpLabels = null;
			}
		}
		
		public static function addTile (  $mcToCache : MovieClip, $id : *, $cycleChildren : Boolean = true , $label:FrameLabel=null ) : void
		{
			tiles[$id] = new CachedAnimation ( $mcToCache, $id, $cycleChildren , $label ) ;
		}
		public static function addTiles (  $mcToCache : MovieClip, $id : *, $cycleChildren : Boolean = true ) : void
		{
			tmpLabels = $mcToCache.currentLabels;
			if (tmpLabels.length==0)
			{
				addTile($mcToCache, $id, $cycleChildren);
				tmpLabels = null;
				return;
			}
			else
			{
				for (var i:int = 0; i < tmpLabels.length; i++) 
				{
					addTile($mcToCache, $id+"."+ tmpLabels[i].name , $cycleChildren, tmpLabels[i]);
				}
				tmpLabels = null;
			}
		}

		public static function deleteAnimation ( $id : * ) : void
		{
			if (  animations[$id] )		
				delete ( animations[$id] );
			else
				throw ( new Error ( "Your trying to delete an animation which is not currently in the Library" ) ) ;
		}

		public static var decals : Dictionary = new Dictionary () ;

		public static function addDecal (  $mcToCache : MovieClip, $id : * ) : void
		{
			decals[$id] = new CachedDecal ( $mcToCache, $id ) ;
		}
		
		public static function deleteDecal( $id : * ) : void
		{
			if (  decals[$id] )		
				delete ( decals[$id] );
			else
				throw ( new Error ( "Your trying to delete a decal which is not currently in the Library" ) ) ;
		}

		public static function deleteTile ( $id : * ) : void
		{
			if (  tiles[$id] )		
				delete ( tiles[$id] );
			else
				throw ( new Error ( "Your trying to delete a tile which is not currently in the Library" ) ) ;
		}
		
		public static function clear () : void
		{
			for each ( var anim:CachedAnimation in animations )
			{
				trace ( anim.id )
				delete ( animations[anim.id] );
			}
		}
	}
}