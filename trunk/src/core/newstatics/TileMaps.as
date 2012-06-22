package core.newstatics
{
	import core.gameObjects.CCInstantiationParams;
	import core.mem.Mem;
	import core.tile.objects.TileMap;
	
	import flash.utils.Dictionary;

	public class TileMaps
	{
		public static var maps:Vector.<TileMap> = new Vector.<TileMap>();
		public static var mapsById:Dictionary = new Dictionary();
		public function TileMaps()
		{

		}
		public static function createMAP($id:String):TileMap
		{
			var vars:CCInstantiationParams = Mem.cciparams.get() as CCInstantiationParams;
			vars.id = $id;
			
			var t:TileMap = new TileMap(vars);
			maps.push(t);
			mapsById[$id] = t;
			return t;
		}
		public static function attachDataToMAP($id:String, $data:String):void
		{
			if (!mapsById[$id])
				throw new Error ("map "+$id+" not found");
			var m:TileMap = mapsById[$id];
			if (m.data)
				throw new Error ("the map "+$id+" contains data");
			m.data = TileMapsData.getTileMapGroupData($data);
		}
	}
}