package core.gameStates
{
	import core.GameLib;
	import core.load.GameStateWaitModes;
	import core.load.LoadGroupData;
	import core.mem.Mem;
	import core.newstatics.Assets;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class GameStateManager
	{
		protected var _state:GameState;
			public function get state():GameState { return _state; }
		protected var _stateDefinitions:Dictionary;
		
		protected var _nextState:String = null;
		
		public function GameStateManager()
		{
			_stateDefinitions = Mem.dict.get() as Dictionary;
		}
		public function registerState($class:Class, $id:String, $waitmode:int):void
		{
			var statedef:GameStateDefinition = new GameStateDefinition($class, $id, $waitmode);
			_stateDefinitions[$id] = statedef;
		}
		public function loadState($id:String):void
		{
			if (_nextState!= null)
			{
				throw new Error ("hay un estado en cola");
			}
			_nextState = $id;
			if (!_state)
			{
				loadStateNow();
			}
		}
		public function checkStateChanges():void
		{
			if (_nextState!=null)
			{
				loadStateNow();
			}
		}
		private function loadStateNow():void
		{
			var statedef:GameStateDefinition = _stateDefinitions[_nextState];
			var group:LoadGroupData = Assets.getGroup(_nextState);
			_nextState=null;
			if (group && !group.loaded)
			{
				// si hay un grupo de carga con ese nombre y no termino de cargar
				switch (statedef.waitmode)
				{
					case GameStateWaitModes.DENIED:
						trace ("DENIED");
						return;
						break;
					case GameStateWaitModes.IGNORE:
						trace ("IGNORE");
						disposeOldState();
						proccessNewState(statedef);
						break;
					case GameStateWaitModes.WAIT:
						//group.onCompleteLoad = disposeOldAndLoadNew;
						group.addEventListener(Event.COMPLETE, disposeOldAndLoadNew);
				}
			}
			else
			{
				disposeOldState();
				proccessNewState(statedef);
			}
			function disposeOldAndLoadNew($evt:Event):void
			{
				$evt.target.removeEventListener(Event.COMPLETE, disposeOldAndLoadNew);
				trace ("group "+group.id +" completed load. loading gamestate.");
				disposeOldState();
				proccessNewState(statedef);
			}
		}
		protected function disposeOldState():void
		{
			// borra estado anterior
			if (_state)
				_state.dispose();
		}
		protected function proccessNewState($statedef:GameStateDefinition):void
		{
			// crea el nuevo estado
			var c:Class = $statedef.type;
			_state = new c();
			GameLib.updater.add(_state);
		}
	}
}