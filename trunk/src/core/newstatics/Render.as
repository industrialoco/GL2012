package core.newstatics
{
	import core.GameCamera;
	import core.GameLib;
	import core.blitting.BListPool;
	import core.blitting.BlittingLayerInfo;
	import core.gameObjects.CCInstantiationParams;
	import core.mem.Mem;
	import core.tile.data.TileMapGroupData;
	
	import flash.utils.Dictionary;

	public class Render
	{
		public static var gameplayBlist:BListPool = new BListPool(1,1);
		public static var tilemapBlist:Vector.<BListPool> = new Vector.<BListPool>();//new BListPool(1,1);
		
		public static const defaultCameraName:String = "default";
		public static function get defaultCamera():GameCamera { return getCamera(defaultCameraName); }
		
		protected static var _cameras:Vector.<GameCamera>= new Vector.<GameCamera>();
		protected static var _camerasById:Dictionary = Mem.dict.get() as Dictionary;
		
		protected static var _layerInfos:Vector.<BlittingLayerInfo> = new Vector.<BlittingLayerInfo>();
		protected static var _layerInfosById:Dictionary = Mem.dict.get() as Dictionary;
		
		protected static var _tilemapgroupDatas:Vector.<TileMapGroupData> = new Vector.<TileMapGroupData>();
		protected static var _tilemapgroupDatasById:Dictionary = Mem.dict.get() as Dictionary;
		
		public function Render()
		{
		}
		
		//	====================================================================================================================================================
		//	====================================================================================================================================================
		//	=====================================							CAMERAS							====================================================
		//	====================================================================================================================================================
		//	====================================================================================================================================================
		public static function getCameras():Vector.<GameCamera>
		{
			return _cameras;
		}
		public static function createDefaultCamera():GameCamera
		{
			return createCamera(defaultCameraName);
		}
		public static function createCamera($id:String, $addExistingLayers:Boolean=true):GameCamera
		{
			var params:CCInstantiationParams = Mem.cciparams.get() as CCInstantiationParams;
			params.id = $id;
			var c:GameCamera = new GameCamera(params);
			GameLib.updater.add(c);
			_cameras.push(c);
			_camerasById[$id] = c;

			if ($addExistingLayers)
			{
				c.addLayerInfos(_layerInfos);
				//c.addTileMapGroupDatas(_tilemapgroupDatas);
			}
			return c;
		}
		public static function getCamera($id:String):GameCamera
		{
			return _camerasById[$id];
		}
		
		public static function deleteCameras():void
		{
			var c:GameCamera
			while (_cameras.length >0) 
			{
				c = _cameras.pop();
				_camerasById[c.name] = null;
				c.dispose();
			}
			
		}
		//	====================================================================================================================================================
		//	====================================================================================================================================================
		//	=====================================               BLITTING LAYER INFO                          ===================================================
		//	====================================================================================================================================================
		//	====================================================================================================================================================
		public static function addDefaultLayers():void
		{
			createLayerInfo("gameplay", 10, true, false);
			createLayerInfo("tilemap", 20, true, false);
			addListToLayerInfo("gameplay", gameplayBlist);
			tilemapBlist.push( new BListPool(1,1));
			addListToLayerInfo("tilemap", tilemapBlist[0]);
		}
		public static function createTileMapBList():BListPool
		{
			var bl:BListPool = new BListPool(1,1);
			tilemapBlist.push(bl);
			addListToLayerInfo("tilemap", bl);
			return bl;
		}
		public static function createLayerInfo ( $id : String, $zdeept:int, $renderCopy : Boolean = true , $smoothing : Boolean = false, $addToExistingCams:Boolean=true) : BlittingLayerInfo
		{
			var blinfo:BlittingLayerInfo = new BlittingLayerInfo($id, $zdeept, $renderCopy, $smoothing);
			
			_layerInfos.push(blinfo);
			_layerInfosById[$id] = blinfo;
			if ($addToExistingCams)
			{
				for (var i:int = 0; i < _cameras.length; i++) 
				{
					_cameras[i].addLayerInfo(blinfo);
				}
			}
			return blinfo ;
		}
		public static function addListToLayerInfo($id:String, $blist:BListPool):void
		{
			BlittingLayerInfo(_layerInfosById[$id]).addRenderList($blist);
		}
	}
}