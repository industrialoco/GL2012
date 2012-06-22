package core.tile.data
{
	import core.blitting.cachedGFX.CachedLibrary;
	
	import core.load.LoadAssetData;
	import core.newstatics.Assets;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class TileMapLayerData
	{
		protected var _loaded:Boolean = false;
		
		public var name:String;
		public var x:int;
		public var y:int;

		public var visible:Boolean;
		public var tileswidth:int;
		public var tilesheight:int;
		public var tileset:String;
		public var tileWidth:int;
		public var tileHeight:int;
		public var tileSpacingX:int;
		public var tileSpacingY:int;
		
		protected var _rows:Array;
			public function get rows():Array { return _rows; }
		protected var _tiles:Array;
			public function get tiles():Array { return _tiles; }
			
		public function TileMapLayerData()
		{
			_tiles = new Array();
			_rows = new Array();
		}
		public function addRow($row:String):void
		{
			var row:Array = $row.split(",");
			_tiles = _tiles.concat(row);
			_rows.push(row);
		}
		public function loadAssets():void
		{
			if (_loaded)
				return;
			
			var m:MovieClip = new MovieClip();
			var l:LoadAssetData = Assets.getAssetById(tileset);
			if (!l)
				throw new Error ("tileset not found");
			
			var sourcebm:Bitmap = l.loadedData;
			var newm:BitmapData;
			var vx:int = 0;
			var vy:int = 0;
			var tileidx:int = 0;
			do
			{
				newm = new BitmapData(tileWidth, tileHeight);
				newm.copyPixels(sourcebm.bitmapData, new Rectangle(vx,vy, tileWidth, tileHeight), new Point(0,0));
				var nb:Bitmap = new Bitmap(newm);
				var mc:MovieClip = new MovieClip();
				mc.addChild(nb);
				CachedLibrary.addTile(mc, tileset+"."+tileidx)
				vx+=tileWidth;
				tileidx++;
			}
			while (vx< sourcebm.bitmapData.width)
				
			sourcebm = null;

			newm = null;
			
			_loaded = true;
		}
/*		public function getTileBitmap($idx:int):BitmapData
		{
			return _tileBitmaps[$idx];
		}*/
		public function clone():TileMapLayerData
		{
			var l:TileMapLayerData = new TileMapLayerData();
			l._tiles 					= _tiles.concat();
			l._rows						= _rows.concat();
			l.name 						= name;
			l.tileHeight 				= tileHeight;
			l.tileset 					= tileset;
			l.tilesheight 				= tilesheight;
			l.tileSpacingX 				= tileSpacingX;
			l.tileSpacingY 				= tileSpacingY;
			l.tileswidth 				= tileswidth;
			l.tileWidth 				= tileWidth;
			l.x 						= x;
			l.y							= y;
			l.visible					= visible;

			return l;
		}
	}
}