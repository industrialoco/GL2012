package core.quadtree
{
	public class NodeDimension
	{
		public var x:Number;
		public var y:Number;
		public var nodeSize:Number;
		
		public function NodeDimension()
		{ }
		
		public function get middleX():Number {
			return x + (nodeSize / 2);
		}
		
		public function get middleY():Number {
			return y + (nodeSize / 2);
		}
		
		public function get right():Number {
			return x + nodeSize;
		}
		
		public function get bottom():Number {
			return y + nodeSize;
		}
	}
}