package core.tile.objects
{
	import core.blitting.BListPool;
	
	import core.gameObjects.CCInstantiationParams;
	import core.gameObjects.CachedClipActor;
	
	public class TileObject extends CachedClipActor
	{
		public var idx:int;
		
		public function TileObject($initParams:CCInstantiationParams)
		{
			super($initParams);
			_interpolated = false;
		}
	}
}