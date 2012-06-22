package core.collisions
{
	import core.gameObjects.CachedClipActor;
	import core.mem.Mem;
	import core.newstatics.BasicData;
	import core.quadtree.QuadTree;
	
	import flash.utils.Dictionary;

	public class ColliderStatic
	{
		//public static var qt:Quadtree = new Quadtree(-600,-100,2200,900);
		public static var groups:Dictionary = Mem.dict.get() as Dictionary;
		public static var qt:QuadTree;// = new QuadTree(Math.max( BasicData.gameArea.width*3, BasicData.gameArea.height*3),-BasicData.gameArea.width/2,-BasicData.gameArea.height/2);

		public function ColliderStatic()
		{
			renewQT()
		}
		public static function insert($obj:CachedClipActor):void
		{
			qt.root.insertNode($obj);
		}
		public static function update():void
		{
			if (qt)
				qt.root.update();
		}
		public static function renewQT():void
		{
			if (qt)
				qt.remove();
			//trace (BasicData.gameArea.width, BasicData.gameArea.height);
			qt = new QuadTree(Math.max( BasicData.gameArea.width*2, BasicData.gameArea.height*2),-BasicData.gameArea.width/2,-BasicData.gameArea.height/2);
		}
	}
}