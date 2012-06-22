package core
{
	import core.blitting.BlittingLayer;
	import core.blitting.BlittingLayerInfo;
	import core.collisions.GameRect;
	import core.gameObjects.CCInstantiationParams;
	import core.gameObjects.GameBasic;
	import core.gameObjects.IFocuseable;
	import core.gameObjects.PositionableActor;
	import core.mem.Mem;
	import core.newstatics.BasicData;
	import core.tile.data.TileMapGroupData;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class GameCamera extends PositionableActor
	{
		protected var _deadzoneLimitLeft:int;
		protected var _deadzoneLimitRight:int;
		protected var _deadzoneLimitUp:int;
		protected var _deadzoneLimitDown:int;
		
		protected var _visionRectangle:GameRect;
			public function get visionRectangle():GameRect { return _visionRectangle; }
		protected var _deadzoneRectangle:GameRect;
			public function get deadzoneRectangle():GameRect { return _deadzoneRectangle; }
		protected var _tilemapRectangle:GameRect;
			public function get tilemapRectangle():GameRect { return _tilemapRectangle; }
		protected var _visionRectangleHalfWidth:int;
		protected var _visionRectangleHalfHeight:int;
			
		protected var _container:Sprite;
			public function get container():Sprite { return _container; }
			
		protected var _focus:IFocuseable = null;

		protected var _name:String;
			public function get name():String { return _name; }
			
		protected var _layerInfos:Vector.<BlittingLayerInfo>;
		protected var _layerInfosById:Dictionary;
		
		protected var _tilemapgroupDatas:Vector.<TileMapGroupData> = new Vector.<TileMapGroupData>();
		protected var _tilemapgroupDatasById:Dictionary = Mem.dict.get() as Dictionary;
		
		public function GameCamera($initParams:CCInstantiationParams)
		{
			super($initParams);

			_container = new Sprite();
			_layerInfos = new Vector.<BlittingLayerInfo>();
			_layerInfosById = Mem.dict.get() as Dictionary;
			
			BasicData.stage.addChild(_container);
			_visionRectangle = Mem.gamerect.get() as GameRect;
			_visionRectangle.width = BasicData.width;
			_visionRectangle.height = BasicData.height;
			
			_deadzoneRectangle = Mem.gamerect.get() as GameRect;
			_deadzoneRectangle.x = BasicData.width/2;
			_deadzoneRectangle.y = BasicData.height/2;
			_deadzoneRectangle.width = 1;
			_deadzoneRectangle.height = 1;
			
			_tilemapRectangle = Mem.gamerect.get() as GameRect;
			_tilemapRectangle.width = BasicData.width;
			_tilemapRectangle.height = BasicData.height;
			
			_name = $initParams.id;
			
			_container.mouseChildren = false;
			_container.mouseEnabled = false;
		}
		
		public function setCameraValues($visual:GameRect, $deadZone:GameRect = null, $tilemap:GameRect = null):void
		{
			_visionRectangle.x = 			$visual.x;
			_visionRectangle.y = 			$visual.y;
			_visionRectangle.width = 		$visual.width;
			_visionRectangle.height = 		$visual.height;
			if ($deadZone)
			{
				_deadzoneRectangle.x = 			$deadZone.x;
				_deadzoneRectangle.y = 			$deadZone.y;
				_deadzoneRectangle.width = 		$deadZone.width;
				_deadzoneRectangle.height = 	$deadZone.height;
			}
			else
			{
				_deadzoneRectangle.x = 			$visual.width;
				_deadzoneRectangle.y = 			$visual.height;
				_deadzoneRectangle.width = 		1;
				_deadzoneRectangle.height = 	1;
			}
			if ($tilemap)
			{
				_tilemapRectangle.x = 			$tilemap.x;
				_tilemapRectangle.y = 			$tilemap.y;
				_tilemapRectangle.width = 		$tilemap.width;
				_tilemapRectangle.height = 		$tilemap.height;
			}
			else
			{
				_tilemapRectangle.x = 			0;
				_tilemapRectangle.y = 			0;
				_tilemapRectangle.width = 		$visual.width;
				_tilemapRectangle.height = 		$visual.height;
			}
			for (var i:int = 0; i < members.length; i++) 
			{
				if (members[i] is BlittingLayer)
				{
					members[i].setSize(_visionRectangle);
				}
			}
			
			_visionRectangleHalfWidth = _visionRectangle.width/2;
			_visionRectangleHalfHeight = _visionRectangle.height/2;
		}
		protected function getDeadzoneLimitLeft($v:int):int
		{
			return $v -  _visionRectangleHalfWidth + _deadzoneRectangle.x;
		}
		protected function getDeadzoneLimitRight($v:int):int
		{
			return $v -  _visionRectangleHalfWidth+ _deadzoneRectangle.x + _deadzoneRectangle.width;
		}
		protected function getDeadzoneLimitUp($v:int):int
		{
			return $v - _visionRectangleHalfHeight + _deadzoneRectangle.y;
		}
		protected function getDeadzoneLimitDown($v:int):int
		{
			return $v - _visionRectangleHalfHeight + _deadzoneRectangle.y + _deadzoneRectangle.height;
		}
		protected override function updating($step:uint):void
		{
			super.updating($step);

		}
		protected override function rendering():void
		{
			if (_focus)
			{
				if (GameBasic(_focus).updateActive)
				{
					_deadzoneLimitLeft = getDeadzoneLimitLeft(_pos.x);
					_deadzoneLimitRight = getDeadzoneLimitRight(_pos.x);
					_deadzoneLimitUp =  getDeadzoneLimitUp(_pos.y);
					_deadzoneLimitDown = getDeadzoneLimitDown(_pos.y);
					
					if ( _focus.posx < _deadzoneLimitLeft)
					{
						_pos.x = Math.round(_pos.x + Math.max((_focus.posx - _deadzoneLimitLeft)/15, -60));
					}
					else if ( _focus.posx > _deadzoneLimitRight)
					{
						_pos.x = Math.round(_pos.x + Math.min((_focus.posx - _deadzoneLimitRight)/15, 60));
					}
					
					if ( _focus.posy < _deadzoneLimitUp)
					{
						_pos.y = Math.round(_pos.y + Math.max((_focus.posy - _deadzoneLimitUp)/15, -60));
					}
					else if ( _focus.posy > _deadzoneLimitDown )
					{
						_pos.y = Math.round( _pos.y + Math.min((_focus.posy - _deadzoneLimitDown)/15, 60));
					}
					
				}
			}
			if (_pos.x < BasicData.gameArea.x + _visionRectangleHalfWidth) _pos.x = Math.round(  BasicData.gameArea.x + _visionRectangleHalfWidth);
			if (_pos.y < BasicData.gameArea.y + _visionRectangleHalfHeight ) _pos.y = Math.round( BasicData.gameArea.y + _visionRectangleHalfHeight);
			if ((_pos.x + (_visionRectangle.width/2)) > BasicData.gameArea.x + BasicData.gameArea.width)
			{
				_pos.x = Math.round( BasicData.gameArea.x + BasicData.gameArea.width - (_visionRectangle.width/2));
			}
			if ((_pos.y + (_visionRectangle.height/2)) > BasicData.gameArea.y + BasicData.gameArea.height)
			{
				_pos.y = Math.round(  BasicData.gameArea.y + BasicData.gameArea.height - (_visionRectangle.height/2));
			}
			adjustLayersPosition();
			
			super.rendering();
			
		}
		protected function adjustLayersPosition():void
		{
			for (var j:int = 0; j < members.length; j++) 
			{
				if (members[j] is BlittingLayer)
				{
					members[j].offset.x = -_pos.x + _visionRectangleHalfWidth;
					members[j].offset.y = -_pos.y + _visionRectangleHalfHeight;
				}
			}
		}
		protected function drawZones(aLayer:BlittingLayer):void
		{
			aLayer.bitmap.bitmapData.lock();
			for (var j:int = _deadzoneRectangle.x; j < _deadzoneRectangle.x+_deadzoneRectangle.width; j++) 
			{
				aLayer.bitmap.bitmapData.setPixel32(j, _deadzoneRectangle.y, 0xFFFF0000);
			}
			for (j = _deadzoneRectangle.x; j < _deadzoneRectangle.x+_deadzoneRectangle.width; j++) 
			{
				aLayer.bitmap.bitmapData.setPixel32(j, _deadzoneRectangle.y + _deadzoneRectangle.height, 0xFFFF0000);
			}
			for (j = _deadzoneRectangle.y; j < _deadzoneRectangle.y+_deadzoneRectangle.height; j++) 
			{
				aLayer.bitmap.bitmapData.setPixel32(_deadzoneRectangle.x, j, 0xFFFF0000);
			}
			for (j = _deadzoneRectangle.y; j < _deadzoneRectangle.y+_deadzoneRectangle.height; j++) 
			{
				aLayer.bitmap.bitmapData.setPixel32(_deadzoneRectangle.x+_deadzoneRectangle.width, j, 0xFFFF0000);
			}

			for (j = 0; j < _visionRectangle.width; j++) 
			{
				aLayer.bitmap.bitmapData.setPixel32(j, 0, 0xFFFF0000);
			}
			for (j = 0; j < _visionRectangle.width; j++) 
			{
				aLayer.bitmap.bitmapData.setPixel32(j, _visionRectangle.height-1, 0xFFFF0000);
			}
			for (j = 0; j < _visionRectangle.height; j++) 
			{
				aLayer.bitmap.bitmapData.setPixel32(0, j, 0xFFFF0000);
			}
			for (j = 0; j < _visionRectangle.height; j++) 
			{
				aLayer.bitmap.bitmapData.setPixel32(_visionRectangle.width-1, j, 0xFFFF0000);
			}
			aLayer.bitmap.bitmapData.unlock();
		}
		public function setFocus($obj:IFocuseable):void
		{
			_focus = $obj;
		}
		public function addLayerInfos($v:Vector.<BlittingLayerInfo>):void
		{
			for (var i:int = 0; i < $v.length; i++) 
			{
				addLayerInfo($v[i]);
			}
		}
		private var tmpBL:BlittingLayer;
		private var tmpTMGD:TileMapGroupData;
		
		public function addLayerInfo($v:BlittingLayerInfo):void
		{
			tmpBL = new BlittingLayer($v, _visionRectangle.width, _visionRectangle.height);
			add(tmpBL);
			tmpBL.setSize(_visionRectangle);
			tmpBL=null;
			
			_layerInfosById[$v.id] = $v;
			_layerInfos.push($v);
			adjustLayersPosition();
		}
		public function getLayerInfo($id:String):BlittingLayerInfo
		{
			return _layerInfosById[$id];
		}
		// TILEMAPS
		public function addTileMapGroupDatas($v:Vector.<TileMapGroupData>):void
		{
			for (var i:int = 0; i < $v.length; i++) 
			{
				addTileMapGroupData($v[i]);
			}
		}
		private var _tilemapLayer:BlittingLayer;
		public function addTileMapGroupData($tmgd:TileMapGroupData):void
		{
			// guarda la referencia del parametro, y crea un layer de tilemap para esta camera
			
			_tilemapgroupDatasById[$tmgd.name] = $tmgd;
			_tilemapgroupDatas.push($tmgd);
			
			adjustLayersPosition();
		}
		public function isThisVisible($o:PositionableActor):Boolean
		{
			if ( $o.posx < _deadzoneLimitLeft)
			{
				return false;
			}
			else if ( $o.posx > _deadzoneLimitRight)
			{
				return false;
			}
			
			if ( $o.posy < _deadzoneLimitUp)
			{
				return false;
			}
			else if ( $o.posy > _deadzoneLimitDown )
			{
				return false;
			}
			return true;
		}
	}
}