package core.input
{
	import core.gameObjects.GameGroup;
	import core.mem.Mem;
	import core.newstatics.BasicData;
	
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	public class KeyboardAccess extends GameGroup
	{
		protected var _curStep:uint;
		
		public var _currentStepKeys:Array;	// las teclas a consultar desde afuera
		
		protected var _nextStepKeys:Array;		// las teclas que se van a activar el prox step. las que no estan aca, se desactivan
		protected var _pastStepKeys:Array;		// las teclas que se van a activar el prox step. las que no estan aca, se desactivan
		protected var _keysToOff:Array;		// las teclas a apagar
		
		protected var _currentKeys:Dictionary;		// estado ACTUAL de las teclas
		
		public function KeyboardAccess()
		{
			super(null);
			
			_currentStepKeys = Mem.array.get() as Array;
			_pastStepKeys = Mem.array.get() as Array;
			_nextStepKeys = Mem.array.get() as Array;
			_keysToOff = Mem.array.get() as Array;
			
			_currentKeys = Mem.dict.get() as Dictionary;
			
			BasicData.stage.addEventListener(KeyboardEvent.KEY_DOWN, keydown);
			BasicData.stage.addEventListener(KeyboardEvent.KEY_UP, keyup);
		}
		protected function keydown($evt:KeyboardEvent):void
		{
			_currentKeys[$evt.keyCode] = true;
			if (_nextStepKeys.indexOf($evt.keyCode)==-1)
				_nextStepKeys.push($evt.keyCode);
		}
		protected function keyup($evt:KeyboardEvent):void
		{
			_currentKeys[$evt.keyCode] = false;
			if (_keysToOff.indexOf($evt.keyCode)==-1)
				_keysToOff.push($evt.keyCode);
		}
		protected override function updating($step:uint):void
		{
			//log()
			
			super.updating($step);
			_curStep = $step;
			updateKeys();
			
		}
		protected function updateKeys():void
		{
			var tmp:int=0;
			
			_pastStepKeys.length= 0;
			Mem.array.put(_pastStepKeys);
			_pastStepKeys = null;
			_pastStepKeys = _currentStepKeys;
			
			_currentStepKeys = null;
			_currentStepKeys = Mem.array.get() as Array;
			_currentStepKeys.length=0;
			concat(_currentStepKeys, _nextStepKeys);
			
			for (var j:int = _keysToOff.length-1; j >=0 ; j--) 
			{
				tmp = _nextStepKeys.indexOf(_keysToOff[j])
				if (tmp!=-1)
				{
					_nextStepKeys[tmp] = null;
				}
			}
			_keysToOff.length = 0;
		}
		protected function concat($a:Array, $b:Array):void
		{
			$a.push.apply(this, $b);
		}
		public function isKeyPressed($k:int):Boolean
		{
			return _currentStepKeys.indexOf($k)!=-1;
		}
		public function justPressed($k:int):Boolean
		{
			return _currentStepKeys.indexOf($k)!=-1 && _pastStepKeys.indexOf($k) == -1;
		}
		public function justReleased($k:int):Boolean
		{
			return _currentStepKeys.indexOf($k)==-1 && _pastStepKeys.indexOf($k) != -1;
		}
		
		protected function log():void
		{
			var pressed:String = "";
			for (var i:int = 0; i < _currentStepKeys.length; i++) 
			{
				pressed = pressed.concat(_currentStepKeys[i], " " );
			}
			var nexts:String = "";
			for (i = 0; i < _nextStepKeys.length; i++) 
			{
				nexts = nexts.concat(_nextStepKeys[i], " " );
			}
			var tooff:String = "";
			for (i = 0; i < _keysToOff.length; i++) 
			{
				tooff = tooff.concat(_keysToOff[i], " " );
			}
			
			trace ( "step: " + _curStep + " pressed: " + pressed + " nexts: " + nexts + " tooff: " + tooff);
		}
		protected override function disposing():void
		{
			BasicData.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keydown);
			BasicData.stage.removeEventListener(KeyboardEvent.KEY_UP, keyup);
			super.disposing();
			
		}
	}
}