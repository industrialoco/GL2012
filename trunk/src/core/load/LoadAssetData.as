package core.load
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	
	import core.blitting.cachedGFX.CachedAnimation;
	import core.blitting.cachedGFX.CachedLibrary;
	import core.newstatics.TileMapsData;
	import core.tile.data.TileMapGroupData;
	import core.tile.parser.TileMapDataParser;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class LoadAssetData extends EventDispatcher
	{
		public var id:String;
		public var url:String;
		public var type:int;
		public var loaded:Boolean = false;
		public var loadedData:*;
		public var cached:Boolean;
		
		//protected var cachedClip:CachedClip;
		protected var animation:CachedAnimation;
		
		protected var tileMapDatas:Vector.<TileMapGroupData>;
		
		protected var _onCompleteLoad:Function;
			public function set onCompleteLoad($v:Function):void { _onCompleteLoad = $v; }
		
		public function LoadAssetData()
		{
		}
		public function load():void
		{
			switch (type)
			{
				case AssetType.Image:
					loadImage();
					break;
				case AssetType.Map:
					loadMap();
					break;
				case AssetType.SWF:
					loadSWF();
					break;
			}
		}
		protected function loadMap():void
		{
			// TODO
			var loader:XMLLoader = new XMLLoader(url, {onComplete:onComplete});
			loader.load()
			function onComplete(event:LoaderEvent):void
			{
				trace ("loaded " + url);
				loadedData = loader.content;
				parseLevel(loadedData);
				loaded = true;
				// TODO: add support for multiple groups
				TileMapsData.addTileMapGroupDatas(tileMapDatas);
				
				if (_onCompleteLoad!=null)
				{
					_onCompleteLoad();
					_onCompleteLoad = null;
				}
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
		}
		protected function loadImage():void
		{
			var loader:ImageLoader = new ImageLoader(url, {onComplete:onComplete});
			loader.load()
			function onComplete(event:LoaderEvent):void
			{
				trace ("loaded " + url);
				loadedData = loader.rawContent;

				if (cached)
				{
					var mclip:MovieClip = new MovieClip();
					mclip.addChild(loadedData);
					loadedData.x = -(loadedData.width/2);
					loadedData.y = -(loadedData.height/2);
					
					// That's how you access a CachedAnimation from the CachedLibrary
					CachedLibrary.addAnimation( mclip, id ) ;
					// -----------------
				}
				loaded = true;
				if (_onCompleteLoad!=null)
				{
					_onCompleteLoad();
					_onCompleteLoad = null;
				}
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
		}
		protected function loadSWF():void
		{
			var loader:SWFLoader = new SWFLoader(url, {onComplete:onComplete});
			loader.load()
			function onComplete(event:LoaderEvent):void
			{
				trace ("loaded " + url);
				loadedData = loader.rawContent.loaderInfo.applicationDomain;
				
				loaded = true;
				if (_onCompleteLoad!=null)
				{
					_onCompleteLoad();
					_onCompleteLoad = null;
				}
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
		}
		public function getMCInstance(className:String, $strict:Boolean=false):MovieClip
		{
			if (type!= AssetType.SWF)
				return null;
			
			var cls:Class = loadedData.getDefinition(className) as Class;
			if (cls)
			{
				var instMC:MovieClip = new cls();
				return instMC;
			}
			else if (!cls && $strict)
			{
				throw new Error("asset not found");
			}
			else if (!cls && !$strict)
			{
				return null;
			}
			return null;
		}
		public function createCachedAnimation(className:String, $strict:Boolean=false):void
		{
			if (type!= AssetType.SWF)
				return;
			
			var cls:Class = loadedData.getDefinition(className) as Class;
			if (cls)
			{
				var instMC:MovieClip = new cls();
				// hacer animation
				CachedLibrary.addAnimations( instMC, className ) ;
				instMC = null;
			}
			else if (!cls && $strict)
			{
				throw new Error("asset not found");
			}
			else if (!cls && !$strict)
			{
				return;
			}
			return;
		}
		public function getNewSprite($strict:Boolean=true):Sprite
		{
			if (!loaded )
			{
				if ($strict)
					throw new Error ("asset "+id+" not loaded.");
				return null;
			}
			var spr:Sprite = new Sprite();
			var holder:Bitmap;
			holder = new Bitmap(Bitmap(loadedData).bitmapData);
			spr.addChild(holder);
			return spr;
		}
		public function getBitmapData($strict:Boolean=true):BitmapData
		{
			return Bitmap(loadedData).bitmapData;
		}
		protected function parseLevel($data:XML):void
		{
			var parser:TileMapDataParser = new TileMapDataParser();
			tileMapDatas = parser.parseTileMapData($data);
		}
	}
}