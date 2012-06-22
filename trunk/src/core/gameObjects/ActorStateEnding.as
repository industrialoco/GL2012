package core.gameObjects
{
	import core.blitting.cachedGFX.CachedClip;
	
	public class ActorStateEnding extends ActorState
	{
		protected var _onEnd:Function = doNothing;
		protected var _lengthOverride:int;		// expressed in animation frames
		protected var _framesDisplayed:int;
		public function ActorStateEnding($name:String, $cclip:CachedClip, $while:Function=null, $onEnd:Function=null, $lengthOverride:int = -1)
		{
			super($name, $cclip, $while);
			if ($onEnd != null)
				_onEnd = $onEnd;
			_lengthOverride = $lengthOverride;
		}
		public override function init():void
		{
			super.init();
			_framesDisplayed = 0; 
		}
		public override function update($step:uint):void
		{
			super.update($step);
			if (_lengthOverride!= -1 && _framesDisplayed >= _lengthOverride)
			{
				// llego a limite de loopear
				frameLoopEnd($step);
			}
			_framesDisplayed++;
			
		}
		protected override function frameLoopEnd($step:uint):void
		{
			if (_lengthOverride!= -1 && _framesDisplayed < _lengthOverride)
			{
				_cclip.gotoAndPlay(1);
				return;
			}
			_cclip.stop();
			_onEnd();
		}
	}
}