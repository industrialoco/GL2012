package core.newstatics
{
	import core.load.LoadAssetData;
	import core.load.LoadGroupData;
	import core.mem.Mem;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class Assets
	{
		protected static var _list:Array = Mem.array.get() as Array;
		protected static var _byId:Dictionary = new Dictionary();
		
		protected static var _currLoadIdx:int = 0;
		
		protected static var dispatcher:EventDispatcher = new EventDispatcher();
		
		
		public static var loaded:Boolean = false;
		
		protected static var _onCompleteLoad:Function;
			public static function set onCompleteLoad($v:Function):void { _onCompleteLoad = $v; }
			
		public function Assets()
		{
		}
		public static function addGroup($v:LoadGroupData):void
		{
			_list.push($v);
			_byId[$v.id] = $v;
		}
		public static function getGroupById($id:String):LoadGroupData
		{
			return _byId[$id];
		}
		public static function getAssetById($id:String):LoadAssetData
		{
			var o:LoadAssetData;
			for (var i:int = 0; i < _list.length; i++) 
			{
				if (_list[i] is LoadGroupData)
				{
					o = getAssetInGroup(_list[i], $id);
				}
				if (o)
					return o;
			}
			return null;
		}
		protected static function getAssetInGroup($g:LoadGroupData, $id:String):LoadAssetData
		{
			var o:* = $g.getAssetById($id);
			if (o)
			{
				return o;
			}
			
			for (var i:int = 0; i < $g.list.length; i++) 
			{
				if ($g.list[i] is LoadGroupData)
				{
					o = getAssetInGroup($g.list[i], $id);
				}
				if (o)
					return o;
			}
			
			return null;
		}
		public static function load():void
		{
			// todo: ver como hacer load secuencial
			loadNext();
		}
		protected static function loadNext():void
		{
			if (_currLoadIdx == _list.length)
			{
				loaded = true;
				if (_onCompleteLoad != null)
				{
					_onCompleteLoad();
					_onCompleteLoad = null;
				}
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			var a:LoadGroupData = _list[_currLoadIdx];
			//a.onCompleteLoad = loadNext;
			a.addEventListener(Event.COMPLETE, onCompleteLoad);
			a.load();
			_currLoadIdx++;
			function onCompleteLoad($evt:Event):void
			{
				$evt.target.removeEventListener(Event.COMPLETE, onCompleteLoad);
				loadNext();
			}
		}
		public static function getGroup($id:String):LoadGroupData
		{
			return _byId[$id];
		}

		private static var tmpAssetsArray:Array = Mem.array.get() as Array;
		public static function getAssetsByType($type:int):Array
		{
			tmpAssetsArray.length = 0;
			
			var g:LoadGroupData;
			
			for (var i:int = 0; i < _list.length; i++) 
			{
				g = (_list[i] as LoadGroupData);
				tmpAssetsArray = tmpAssetsArray.concat(g.getAssetsByType($type));
			}
			return tmpAssetsArray;
		}
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		public static function dispatchEvent(event:Event):Boolean {
			return dispatcher.dispatchEvent(event);
		}
		public static function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}

	}
}