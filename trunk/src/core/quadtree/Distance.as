package core.quadtree
{
	import core.mem.Mem;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class Distance
	{
		public function Distance(obj1:DisplayObject, obj2:DisplayObject)
		{
			var bmp1:BitmapData = new BitmapData(obj1.width, obj1.height, true, 0x00000000);
			bmp1.draw(obj1);
			var bmp2:BitmapData = new BitmapData(obj2.width, obj2.height, true, 0x00000000);
			bmp2.draw(obj2);
			
			var minDistance:Number = 999999999999999;
			var tmpDistance:Number;
			var p1:Point = Mem.point.get() as Point;
			var p2:Point = Mem.point.get() as Point;
			
			var x1:int = -1;
			var y1:int = -1;
			
			var t:int = getTimer();
			
			for(var x:int=0; x<=bmp1.width; x++)
			{
				for(var y:int=0; y<=bmp1.height; y++)
				{
					if(isEdgePixel(x,y,bmp1))
					{
						x1 = x;
						y1 = y;
						break;
					}
					
				}
				if(x1!=-1)
					break;
			}
			Mem.point.put(p1);
			Mem.point.put(p2);
			/*trace(getTimer() - t);
			trace("first edge pixel: " + x1, ", " + y1);
			trace(bmp1.getPixel32(-13,0));*/
		}
		
		private function isEdgePixel(x:int, y:int, bmp:BitmapData):Boolean {
			if(bmp.getPixel32(x,y) != 0)
			{
				if(bmp.getPixel32(x-1,y) == 0)
					return true;
				else if(bmp.getPixel32(x+1,y) == 0)
					return true;
				else if(bmp.getPixel32(x,y-1) == 0)
					return true;
				else if(bmp.getPixel32(x,y+1) == 0)
					return true;
				else
					return false;
			}
			else
			{
				return false;
			}
		}
	}
}