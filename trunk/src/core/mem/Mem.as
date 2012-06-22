package core.mem
{
	import core.collisions.GameRect;
	import core.gameObjects.CCInstantiationParams;
	import core.gameObjects.InstantiationParams;
	import core.quadtree.QuadTreeNode;
	
	import de.polygonal.ds.pooling.DynamicObjectPool;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class Mem
	{
		public static var dict:DynamicObjectPool = new DynamicObjectPool(Dictionary);
		public static var array:DynamicObjectPool = new DynamicObjectPool(Array);
		public static var qtnodePool:DynamicObjectPool = new DynamicObjectPool(QuadTreeNode);
		public static var gamerect:DynamicObjectPool = new DynamicObjectPool(GameRect);
		public static var point:DynamicObjectPool = new DynamicObjectPool(Point);
		public static var rect:DynamicObjectPool = new DynamicObjectPool(Rectangle);
		public static var iparams:DynamicObjectPool = new DynamicObjectPool(InstantiationParams);
		public static var cciparams:DynamicObjectPool = new DynamicObjectPool(CCInstantiationParams);
		
		public function Mem()
		{
		}
	}
}