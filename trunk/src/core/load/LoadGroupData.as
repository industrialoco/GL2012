package core.load
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class LoadGroupData extends EventDispatcher
	{
		public var id:String;
		public var url:String;
		public var loaded:Boolean = false;
		
		protected var _list:Array;
			public function get list():Array { return _list; }
			
		protected var _byId:Dictionary;
		
		protected var _currLoadIdx:int = 0;
		
		protected var _onCompleteLoad:Function;
			public function set onCompleteLoad($v:Function):void { _onCompleteLoad = $v; }
		
		public function LoadGroupData()
		{
			_list = [];
			_byId = new Dictionary();
		}
		public function addAsset($v:LoadAssetData):void
		{
			_list.push($v);
			_byId[$v.id]=$v;
		}
		public function addGroup($v:LoadGroupData):void
		{
			_list.push($v);
			_byId[$v.id]=$v;
		}
		public function getAssetById($id:String):LoadAssetData
		{
			if (_byId[$id] && _byId[$id] is LoadAssetData)
				return _byId[$id];
			else
				return null;
		}
		public function getGroupById($id:String):LoadGroupData		
		{
			if (_byId[$id] && _byId[$id] is LoadGroupData)
				return _byId[$id];
			else
				return null;
		}
		public function getAssetsByType($type:int):Array
		{
			var assets:Array = new Array();
			
			for (var i:int = 0; i < _list.length; i++) 
			{
				if ((_list[i] as LoadAssetData).type == $type)
				{
					assets.push(_list[i]);
				}
			}
			return assets;
		}
		public function load():void
		{
			// todo: ver como hacer load secuencial
			loadNext();
		}
		protected function loadNext():void
		{
			if (_currLoadIdx == _list.length)
			{
				loaded = true;
				if (_onCompleteLoad!=null)
				{
					_onCompleteLoad();
					_onCompleteLoad = null;
				}
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			var a:*
			if (_list[_currLoadIdx] is LoadAssetData)
			{
				a = _list[_currLoadIdx];
			}
			else
			{
				a = _list[_currLoadIdx];
			}
			_currLoadIdx++;
			//a.onCompleteLoad = loadNext;
			a.addEventListener(Event.COMPLETE, onCompleteLoad);
			a.load();
			function onCompleteLoad($evt:Event):void
			{
				$evt.target.removeEventListener(Event.COMPLETE, onCompleteLoad);
				loadNext();
			}
		}
	}
}