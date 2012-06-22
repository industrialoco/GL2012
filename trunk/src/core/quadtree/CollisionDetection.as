package core.quadtree
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class CollisionDetection
	{
		private var parent:DisplayObject;
		
		public function CollisionDetection(p:DisplayObject)
		{
			parent = p;
		}
		
		public function checkCollision(obj1:DisplayObject, obj2:DisplayObject):Boolean {
			// get the bounding box of the object
			var rect1:Rectangle;
			rect1 = obj1.getBounds(parent);
			
			// get the bounding box of the object
			var rect2:Rectangle;
			rect2 = obj2.getBounds(parent);
			
			// get the intersection of the two rectangles
			var intersectRect:Rectangle = rect1.intersection(rect2);
			
			if(intersectRect.width < 1 || intersectRect.height < 1)
				return false;
			
			// get the bitmap data pixels that are within the intersection rectangle
			var bData1:BitmapData = drawBitmapRect(obj1, intersectRect);
			var bData2:BitmapData = drawBitmapRect(obj2, intersectRect);
			
			
			
			var t:int = getTimer();
			
			for(var x:int=0; x <= intersectRect.width; x++)
			{
				for(var y:int=0; y <= intersectRect.height; y++)
				{
					if(bData1.getPixel32(x,y) != 0x00000000 && bData2.getPixel32(x,y) != 0x00000000)
					{
						bData1.dispose();
						bData1 = null;
						bData2.dispose();
						bData2 = null;
						
						return true;
					}
				}
			}
			
			trace(getTimer() - t);
			
			return false;
		}
		
		private function drawBitmapRect(obj:DisplayObject, rect:Rectangle):BitmapData {
			var matrix:Matrix = new Matrix(1,0,0,1,obj.x - rect.x, obj.y - rect.y);
			
			var intersectBitmapData:BitmapData = new BitmapData(rect.width,rect.height,true,0x00000000);
			intersectBitmapData.draw(obj,matrix,null,null);
			
			return intersectBitmapData;
		}
	}
}