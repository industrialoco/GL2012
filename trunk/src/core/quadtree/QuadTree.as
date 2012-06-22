package core.quadtree
{
	import core.mem.Mem;

	public class QuadTree
	{
		public var root:QuadTreeNode;
		private var tmpNode:QuadTreeNode = root;

		public function QuadTree(_s:Number, _x:Number, _y:Number)
		{
			root = Mem.qtnodePool.get() as QuadTreeNode;
			root.init(null, this);
			
			root.nodeDimension.x = _x;
			root.nodeDimension.y = _y;
			root.nodeDimension.nodeSize = _s;
		}
		public function remove():void
		{
			// TODO : borrar todo
			root.destroy();
			root = null;
			tmpNode=null;
		}
	}
}