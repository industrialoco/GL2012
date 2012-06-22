package core.gameObjects
{
	import core.blitting.cachedGFX.CachedClip;
	import core.blitting.cachedGFX.CachedLibrary;

	public class ActorState
	{
		protected var _name:String;
		protected var _while:Function = doNothing;
		protected var _cclip:CachedClip;
		
		public function ActorState( $name:String, $cclip:CachedClip, $while:Function=null)
		{
			_name = $name;
			_cclip = $cclip;
			if ($while != null)
				_while = $while;
		}
		public function init():void
		{
			_cclip.animation = CachedLibrary.animations[_name];
			_cclip.gotoAndPlay(1);
		}
		public function update($step:uint):void
		{
			if (_cclip.currentFrame < _cclip.animation.framesArray.length-1)
			{
				_while();
			}
			else if (_cclip.currentFrame >= _cclip.animation.framesArray.length-1)
			{
				frameLoopEnd($step);
			}
		}
		protected function frameLoopEnd($step:uint):void
		{
			_cclip.gotoAndPlay(1);
		}
		protected function doNothing():void {};
	}
}