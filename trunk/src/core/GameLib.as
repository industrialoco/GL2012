package core
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.sociodox.theminer.TheMiner;
	
	import core.collisions.GameRect;
	import core.gameStates.GameStateManager;
	import core.input.KeyboardAccess;
	import core.load.DynamicLoader;
	import core.mem.Mem;
	import core.newstatics.BasicData;
	import core.newstatics.Render;
	import core.updater.UpdaterByTime;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	public class GameLib extends Sprite
	{
		protected var _initTimer:Timer;
		protected var _fps:int;
		
		public static var updater:UpdaterByTime;
		
		public function GameLib($fps:int)
		{
			//-------------------------------------------------------------------------------------------------------------------------
			//	TODO LIST:
			//
			// - 
			//-------------------------------------------------------------------------------------------------------------------------
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			_fps = $fps;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			BasicData.stage = this.stage;
			BasicData.width = this.stage.stageWidth;
			BasicData.height = this.stage.stageHeight;
			BasicData.mainURL = this.loaderInfo.url.substring(0, this.loaderInfo.url.lastIndexOf("/")+1);
			BasicData.dynamicLoader = new DynamicLoader();
			
			BasicData.gameArea = Mem.gamerect.get() as GameRect;
			BasicData.gameArea.width = BasicData.width;
			BasicData.gameArea.height = BasicData.height;
			
			this.mouseChildren=false;
		}
		private function onAddedToStage($e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (Capabilities.isDebugger)
			{
				this.addChild(new TheMiner());
			}
			createUpdater();
			
			createRenderer();

			createKeyboardInput();
			
			createStateManager();
			
			LoaderMax.activate([ImageLoader]); //only necessary once - allows XMLLoader to recognize ImageLoader nodes inside the XML
			var loader:XMLLoader = new XMLLoader(BasicData.mainURL + "configuration.xml", {name:"configuration", onComplete:onCompleteLoadConfiguration}); 
			loader.load();
				
		}
		protected function createUpdater():void
		{
			updater = new UpdaterByTime(_fps, 1);
		}

		protected function createRenderer():void
		{
			Render.addDefaultLayers();
		}
		protected function createKeyboardInput():void
		{
			BasicData.keyboard = new KeyboardAccess();
			updater.add(BasicData.keyboard);			
		}
		protected function createStateManager():void
		{
			BasicData.stateManager = new GameStateManager();
		}
		
		protected function onCompleteLoadConfiguration($evt:LoaderEvent):void
		{
			var xml:XML = LoaderMax.getContent("configuration");
			proccessConfiguration(xml);
			xml = null;
			
			
		}
		protected function proccessConfiguration($data:XML):void
		{
			BasicData.dynamicLoader.create($data);
			BasicData.dynamicLoader.addEventListener(Event.COMPLETE, loadDependentInitialization);
			initGame();
		}
		protected function loadDependentInitialization($evt:Event):void
		{
			BasicData.dynamicLoader.removeEventListener(Event.COMPLETE, loadDependentInitialization);
			// inicializa las cosas que dependen del procesado de la configuracion
		}
		protected function initGame():void
		{
			
		}
	}
}