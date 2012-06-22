package core.tile.parser
{
	import core.load.BaseXMLParser;
	import core.tile.data.TileMapGroupData;
	import core.tile.data.TileMapLayerData;

	public class TileMapDataParser extends BaseXMLParser
	{
		public function TileMapDataParser()
		{
		}
		public function parseTileMapData($data:XML):Vector.<TileMapGroupData>
		{
			var datas:Vector.<TileMapGroupData> = new Vector.<TileMapGroupData>();
			for each (var layer:* in $data.layers)
			{
				for each (var group:* in layer.group)
				{
					datas.push( parseTileMapGroupData(group));
				}
			}
			return datas;
		}
		public function parseTileMapGroupData($data:XML):TileMapGroupData
		{
			var group:TileMapGroupData = new TileMapGroupData();
			group.name = $data.@name;
			for each (var maplayer:* in $data.maplayer)
			{
				group.addMapLayer( parseTileMapMapLayer(maplayer));
			}
			return group;
		}
		public function parseTileMapMapLayer($data:XML):TileMapLayerData
		{
			var maplayer:TileMapLayerData = new TileMapLayerData();
			maplayer.name = 		$data.@name;
			maplayer.x =			$data.@x;
			maplayer.y = 			$data.@y;
			maplayer.visible = 		parseBoolean($data.@visible);
			maplayer.tileswidth = 	$data.@width;
			maplayer.tilesheight = 	$data.@height;
			maplayer.tileset = 		$data.@tileset;
			maplayer.tileWidth = 	$data.@tileWidth;
			maplayer.tileHeight = 	$data.@tileHeight;
			maplayer.tileSpacingX = $data.@tileSpacingX;
			maplayer.tileSpacingY = $data.@tileSpacingY;
			
			for each (var row:* in $data.row)
			{
				maplayer.addRow(row);
			}
			
			return maplayer;
		}
	}
}