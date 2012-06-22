package core.gameObjects
{
	import core.blitting.BListPool;

	public class CCInstantiationParams extends InstantiationParams
	{
		public var id:String;
		public var container:BListPool;
		public var data:*;
		public function CCInstantiationParams()
		{

		}
		public function clear():void
		{
			id = null;
			container = null;
			data = null;
		}
	}
}