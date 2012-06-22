package core.collisions
{
	

	public class CollisionData
	{
		public var idx1:int;
		public var idx2:int;
		public var callback:Function;
		
		public function CollisionData($idx1:int, $idx2:int, $callback:Function)
		{
			idx1 = $idx1;
			idx2 = $idx2;
			callback = $callback;
		}
	}
}