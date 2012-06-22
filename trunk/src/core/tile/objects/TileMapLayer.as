package core.tile.objects
{
	import core.blitting.BListPool;
	import core.blitting.cachedGFX.CachedLibrary;
	
	import core.GameCamera;
	import core.gameObjects.CCInstantiationParams;
	import core.gameObjects.GameBasic;
	import core.gameObjects.PositionableActor;
	import core.newstatics.Render;
	import core.tile.data.TileMapLayerData;
	
	import de.polygonal.ds.Itr;
	import de.polygonal.ds.SLL;
	import de.polygonal.ds.SLLNode;
	
	public class TileMapLayer extends PositionableActor
	{
		protected var _tm:TileMap;
		protected var _layerData:TileMapLayerData;
			public function get layerData():TileMapLayerData { return _layerData; }
		protected var _container:BListPool;
		
		protected var _list:Vector.<TileHolder>;
			public function get list():Vector.<TileHolder> { return _list; }
		
		protected var _rows:Vector.<Vector.<TileHolder>>;
			public function get rows():Vector.<Vector.<TileHolder>> { return _rows; }
			
		protected var _cols:Vector.<Vector.<TileHolder>>;
			public function get cols():Vector.<Vector.<TileHolder>> { return _cols; }
		protected var _aliveObjects:SLL;
		
		public function TileMapLayer($tm:TileMap, $l:TileMapLayerData, $x:int, $y:int, $container:BListPool)
		{
			_tm = $tm;
			_layerData = $l;
			_container = $container;
			super(null);
			_pos.x = $x;
			_pos.y = $y;
			_aliveObjects = new SLL();
			createDataStructure();
			_interpolated = false;
			//populateData();
		}
		protected function populateData():void
		{
			var idx1:int = 0;
			var idx2:int = 0;
			var idx3:int = 0;
			var rows:Array = _layerData.rows;
			var totalRows:int = rows.length;
			var totalWidth:int = _layerData.tileswidth;

			var t:GameBasic;
			
			for (idx1 = 0; idx1 < totalRows; idx1++) 
			{
				for (idx2 = 0; idx2 < totalWidth; idx2++) 
				{
					idx3 = rows[idx1][idx2];
					//t = recycle(TileObject, _container);
					_rows[idx1][idx2].setTile(t as TileObject, CachedLibrary.tiles[_layerData.tileset+"."+idx3]);
					_aliveObjects.append(t);
				}
			}
			
		}
		
		private var cams:Vector.<GameCamera>;
		private var lasttopLimit:int;
		private var lastbottomLimit:int;
		private var lastleftLimit:int;
		private var lastrightLimit:int;
		private var topLimit:int;
		private var bottomLimit:int;
		private var leftLimit:int;
		private var rightLimit:int;
		private var r:int;
		private var c:int;
		private var indexof:int;
		private var idx1:int;
		private var idx2:int;
		private var tileval:int;
		private var indexes:Vector.<int> = new Vector.<int>();
		private var tmpObject:GameBasic;
		private var ip:CCInstantiationParams;
		private var _aobj:SLLNode;
		
		public function proccess():void
		{
			ip = new CCInstantiationParams();
			ip.container = _container;
			
			cams = Render.getCameras();
			
			for (var i:int = 0; i < cams.length; i++)
			{
				// obtiene los limites de la camara
				
				topLimit = 		(cams[i].posy - _pos.y	-	(cams[i].visionRectangle.height/2) + cams[i].tilemapRectangle.y 	)/_layerData.tileSpacingY;
				bottomLimit = 	(cams[i].posy - _pos.y	-	(cams[i].visionRectangle.height/2) + cams[i].tilemapRectangle.y + cams[i].tilemapRectangle.height )/_layerData.tileSpacingY;
				leftLimit = 	(cams[i].posx - _pos.x	-	(cams[i].visionRectangle.width/2) + cams[i].tilemapRectangle.x	)/_layerData.tileSpacingX;
				rightLimit = 	(cams[i].posx - _pos.x	-	(cams[i].visionRectangle.width/2) + cams[i].tilemapRectangle.x + cams[i].tilemapRectangle.width	)/_layerData.tileSpacingX;
				
				
				if (topLimit == lasttopLimit && leftLimit == lastleftLimit && bottomLimit == lastbottomLimit && rightLimit == lastrightLimit)
				{
					return;
				}
				trace (topLimit + " " + bottomLimit + " " + leftLimit + " " + rightLimit);
				if (topLimit<0) topLimit=0;
				if (leftLimit<0) leftLimit=0;
				if (topLimit>_layerData.tilesheight) topLimit=_layerData.tilesheight;
				if (leftLimit>_layerData.tileswidth) leftLimit=_layerData.tileswidth;
				
				if (bottomLimit<0) bottomLimit=0;
				if (rightLimit<0) rightLimit=0;
				if (bottomLimit>_layerData.tilesheight) bottomLimit=_layerData.tilesheight;
				if (rightLimit>_layerData.tileswidth) rightLimit=_layerData.tileswidth;
				
				for (r = topLimit; r < bottomLimit; r++) 
				{
					for (c = leftLimit; c < rightLimit; c++) 
					{
						if (indexes.indexOf(_rows[r][c].idx)==-1)
						{
							indexes.push(_rows[r][c].idx);
						}
					}
				}
			}
			_aobj = _aliveObjects.head;
			while (_aobj!= null)
			{
				if (_aobj.val is TileObject)
				{
					tmpObject = _aobj.val as TileObject;
					indexof = indexes.indexOf((tmpObject as TileObject).idx)
					if (indexof==-1 && !tmpObject.forRecycle && !tmpObject.recycled )
					{
						_list[(tmpObject as TileObject).idx].clearTile();
						tmpObject.toRecycle();
						_aobj = _aobj.unlink();
					}
					else
					{
						indexes.splice(indexof,1);
						_aobj = _aobj.next;
					}
				}
			}

			for (idx2 = indexes.length-1; idx2 >=0 ; idx2--) 
			{
				idx1 = indexes[idx2];
				r = _list[idx1].row;
				c = _list[idx1].col;
				tileval = _layerData.rows[r][c];
				tmpObject = recycle(TileObject, ip );
				_list[idx1].setTile(tmpObject as TileObject, CachedLibrary.tiles[_layerData.tileset+"."+tileval]);
				_aliveObjects.append(tmpObject);
				indexes.splice(idx2,1);
			}
			
			lasttopLimit = topLimit;
			lastbottomLimit = bottomLimit;
			lastrightLimit = rightLimit;
			lastleftLimit = leftLimit;
			
			// tengo todos los que faltan
		}

		protected function createDataStructure():void
		{
			var idx1:int = 0;
			var idx2:int = 0;
			var idx3:int = 0;
			_list = new Vector.<TileHolder>();
			// crea la lista
			var lidx:int=0;
			for (idx1 = 0; idx1 < _layerData.tilesheight; idx1++) 
			{
				for (idx2 = 0; idx2 <  _layerData.tileswidth; idx2++)
				{
					_list.push(new TileHolder(lidx, idx1, idx2, (idx2 * _layerData.tileSpacingX)+_pos.x, (idx1 * _layerData.tileSpacingY)+_pos.y));
					lidx++;
				}
			}
			idx1=0;
			idx2=0;
			idx3=0;
			// hace el que es por columna
			_cols=new Vector.<Vector.<TileHolder>>();
			for (idx1 = 0; idx1 < _layerData.tileswidth; idx1++) 	// idx1 = col
			{
				_cols.push(new Vector.<TileHolder>());
				for (idx2 = 0; idx2 < _layerData.tilesheight; idx2++)		// idx2 = row 
				{
					idx3 = (idx2*_layerData.tileswidth) + idx1;
					_cols[idx1].push( _list[idx3]);
				}
			}
			idx1=0;
			idx2=0;
			idx3=0;
			// hace el que es por fila
			_rows=new Vector.<Vector.<TileHolder>>();
			for (idx1 = 0; idx1 < _layerData.tilesheight; idx1++) 	// idx1 = row
			{
				_rows.push(new Vector.<TileHolder>());
				for (idx2 = 0; idx2 < _layerData.tileswidth; idx2++)		// idx2 = col 
				{
					idx3 = (idx1*_layerData.tileswidth) + idx2;
					_rows[idx1].push( _list[idx3]);
				}
			}
		}
		protected override function disposing():void
		{
			super.disposing();
		}
	}
}