package core.load
{
	import core.newstatics.Assets;
	import core.newstatics.BasicData;
	
	import flash.events.Event;

	public class DynamicLoader extends BaseXMLParser
	{

		protected var _onComplete:Function;
			public function set onComplete($v:Function):void { _onComplete = $v; }
		
		public function DynamicLoader()
		{
		}
		public function create($xml:XML):void
		{
			for each (var o:XML in $xml.loadGroups.group)
			{
				Assets.addGroup(parseGroup(o, BasicData.mainURL.substr(0, BasicData.mainURL.length-1)));
			}
			beginLoad();
		}
		protected function parseGroup($g:XML, $url:String):LoadGroupData
		{
			var group:LoadGroupData = new LoadGroupData();
			group.id = $g.@id;
			var isEmptyNode:Boolean = false;
			trace ($g.group.url);
			if ($g.@url[0] == null)
			{
				group.url = $url;
			}
			else
			{
				group.url = $url +"/" +$g.@url;
			}
			var o:XML;
			for each (o in $g.group)
			{
				group.addGroup(parseGroup(o, group.url)); 
			}
			for each (o in $g.asset)
			{
				group.addAsset(parseAsset(o, group.url)); 
			}
			return group;
		}
		protected function parseAsset($g:XML, $url:String):LoadAssetData
		{
			var asset:LoadAssetData = new LoadAssetData();
			asset.id = $g.@id;
			asset.url = $url +"/" +$g.@url;
			asset.cached = parseBoolean($g.@cached);
			
			switch($g.@type.toString())
			{
				case "image":
					asset.type=AssetType.Image;
					break;
				case "map":
					asset.type=AssetType.Map;
					break;
				case "swf":
					asset.type=AssetType.SWF;
					break;
			}
			asset.loadedData = null;
			
			return asset;
		}
		public function beginLoad():void
		{
			Assets.load();
			Assets.addEventListener(Event.COMPLETE, onFinishLoad);
		}
		public function onFinishLoad($evt:Event):void
		{
			Assets.removeEventListener(Event.COMPLETE, onFinishLoad);
			dispatchEvent(new Event(Event.COMPLETE));
			if (_onComplete!=null)
			{
				_onComplete();
				_onComplete = null;
			}
		}
	}
}