package core.tile.objects
{
	import core.blitting.cachedGFX.CachedAnimation;
	
	import flash.geom.Point;
	
	public class TileHolder
	{
		public var idx:int;
		public var row:int;
		public var col:int;
		protected var _tile:TileObject;
			public function get gotTile():Boolean { return _tile != null; }
		protected var _pos:Point;
		public function TileHolder($idx:int, $row:int, $col:int, $x:int, $y:int)
		{
			idx = $idx;
			row = $row;
			col = $col;
			_pos = new Point($x, $y);
		}
		public function setTile($object:TileObject, $tile:CachedAnimation):void
		{
			_tile = $object;
			_tile.idx = idx;
			_tile.setPos(_pos.x, _pos.y);
			_tile.cachedClip.animation = $tile;
		}
		public function clearTile():void
		{
			_tile = null;
		}
	}
}