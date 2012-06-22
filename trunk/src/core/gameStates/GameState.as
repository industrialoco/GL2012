package core.gameStates
{
	import core.blitting.BlittingLayer;
	import core.gameObjects.GameGroup;
	import core.newstatics.Render;
	import core.newstatics.TileMaps;
	import core.tile.objects.TileMap;

	public class GameState extends GameGroup
	{
		public function GameState():void
		{
			super(null);
		}
		public override function initialize():void
		{
			super.initialize();
			manageTileMaps();
			manageCameras();
		}
		protected function manageTileMaps():void
		{
			// to override
		}
		protected function manageCameras():void
		{
			Render.createDefaultCamera();
		}
		public function createTilemapFromGroup($id:String, $groupid:String):TileMap
		{
			//Render.createNewMapFromGroup($id, $groupid);
			var tm:TileMap;
			tm = createTilemap($id);
			TileMaps.attachDataToMAP($id, $groupid);
			return tm;
		}
		private var _tilemapLayer:BlittingLayer;
		public function createTilemap($id:String):TileMap
		{
			var tm:TileMap;
			tm = TileMaps.createMAP($id)
			add (tm);
			return tm;
			//Render.createNewMap($id);
		}
		protected override function disposing():void
		{
			deleteCameras();
			super.disposing();
		}
		protected function deleteCameras():void
		{
			Render.deleteCameras();
		}
	}
}