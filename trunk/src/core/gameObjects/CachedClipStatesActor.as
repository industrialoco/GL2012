package core.gameObjects
{
	
	
	public class CachedClipStatesActor extends CachedClipActor
	{
		protected var _currentState:ActorState;
	//	protected var _animLeft:ActorState;
		
		public function CachedClipStatesActor($initParams:CCInstantiationParams)
		{
			super($initParams);
			
			//_animLeft = new ActorState(_data, "", _cachedClip.animation);
		}
		protected function setCurrentState($v:ActorState):void
		{
			_currentState = $v;
			_currentState.init();
		}
		protected override function updating($step:uint):void
		{
			if (_currentState)
				_currentState.update($step);
			super.updating($step);
			
		}
	}
}