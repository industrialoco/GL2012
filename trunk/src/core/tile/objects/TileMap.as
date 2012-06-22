package core.tile.objects
{
	import core.blitting.BListPool;
	
	import core.GameCamera;
	import core.gameObjects.CCInstantiationParams;
	import core.gameObjects.GameGroup;
	import core.newstatics.Render;
	import core.tile.data.TileMapGroupData;
	import core.tile.data.TileMapLayerData;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class TileMap extends GameGroup
	{
		public var id:String;
		public var data:TileMapGroupData;
		protected var _layers:Vector.<TileMapLayer>;
		protected var _layersById:Dictionary;
		
		public function TileMap($initParams:CCInstantiationParams)
		{
			id = $initParams.id;
			_layers = new Vector.<TileMapLayer>(); 
			_layersById = new Dictionary(); 
			super($initParams);
		}
		public function spawnLayer($layer:String, $x:int, $y:int, $blist:BListPool):void
		{
			var l:TileMapLayerData = data.getMapLayerById($layer);
			if (!l)
				throw new Error ("map layer "+$layer+" not found.");
			
			createUseLayer(l, $x, $y, $blist);
		}
		protected function createUseLayer($l:TileMapLayerData, $x:int, $y:int, $blist:BListPool):void
		{
			// esta funcion crea el layer usable y lo spawnea en el lugar indicado. tal vez deberia cachear una copia y guardarla para la proxima spawneada
			var l:TileMapLayer = new TileMapLayer(this, $l, $x, $y, $blist);
			add(l);
			_layersById[l.layerData.name] = l;
			_layers.push(l);
		}
		public function destroyLayer($layer:String):void
		{
			var l:TileMapLayer = _layersById[$layer];
			if (l)
			{
				_layersById[$layer]=null;
				_layers.splice(_layers.indexOf(l),1);
				l.dispose();
			}
		}
		protected override function updating($step:uint):void
		{
			super.updating($step);
			for (var l:int = 0; l < _layers.length; l++) 
			{
				_layers[l].proccess();
			}
		}
	}
}