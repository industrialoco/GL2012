package core.newstatics
{
	import core.tile.data.TileMapGroupData;
	
	import flash.utils.Dictionary;

	public class TileMapsData
	{
		//TileMapData
		protected static var _mapsDataById:Dictionary = new Dictionary();
		protected static var _mapsData:Vector.<TileMapGroupData> = new Vector.<TileMapGroupData>();
		
		public function TileMapsData()
		{

		}
		
		// ===================== MAIN LOAD COMES FROM LOADASSETDATA ==================================================
		public static function addTileMapGroupDatas($datas:Vector.<TileMapGroupData>):void
		{
			for (var i:int = 0; i < $datas.length; i++) 
			{
				addTileMapGroupData($datas[i]);
			}
		}
		public static function addTileMapGroupData($tiledata:TileMapGroupData):void
		{
			// rellena el tilemapdata con los datos reales dentro.
			if (_mapsDataById[$tiledata.name] != null)
			{
				for (var i:int = 0; i < $tiledata.layers.length; i++) 
				{
					(_mapsDataById[$tiledata.name] as TileMapGroupData).addMapLayer($tiledata.layers[i]);
				}
			}
			else
			{
				_mapsDataById[$tiledata.name] = $tiledata;
			}
		}
		public static function getTileMapGroupData($id:String):TileMapGroupData
		{
			return _mapsDataById[$id];
		}
	}
}