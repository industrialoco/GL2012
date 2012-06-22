package core.tile.data
{
	import flash.utils.Dictionary;

	public class TileMapGroupData
	{
		public var name:String;
		
		protected var _layers:Vector.<TileMapLayerData> ;
			public function get layers():Vector.<TileMapLayerData> { return _layers; }
			
		protected var _layersById:Dictionary;
		
		public function TileMapGroupData()
		{
			_layers = new Vector.<TileMapLayerData>();
			_layersById = new Dictionary();
		}
		public function addMapLayer($data:TileMapLayerData):void
		{
			_layers.push($data);
			_layersById[$data.name] = $data; 
			
			$data.loadAssets();
		}
		public function getMapLayer($idx:int):TileMapLayerData
		{
			return _layers[$idx];
		}
		public function getMapLayerById($id:String):TileMapLayerData
		{
			return _layersById[$id];
		}
		public function getTile($layerId:String, $row:int, $col:int):int
		{
			return _layersById[$layerId].getTile($row, $col);
		}
	}
}