package core.input
{
	import core.gameObjects.GameBasic;
	import core.newstatics.BasicData;
	
	public class GamePad extends GameBasic
	{
		protected var _buttons:Vector.<ButtonData>;
		
		protected var key:*;
		
		protected var _axis:Vector.<AxisData>;
		private var _curAxis:AxisData;
		private var _curButton:ButtonData;
		
		public function GamePad()
		{
			super(null);
			_buttons = new Vector.<ButtonData>();
			_axis = new Vector.<AxisData>();
		}
		protected override function updating($step:uint):void
		{
			super.updating($step);
			var i:int = 0;
			var l:int = _buttons.length;
			for (i = 0; i < l; i++) 
			{
				_curButton = _buttons[i];
				if (_curButton.actionPressed != null && BasicData.keyboard.justPressed(_curButton.key))
				{
					_curButton.actionPressed();
				}
				else if (_curButton.actionReleased != null && BasicData.keyboard.justReleased(_curButton.key))
				{
					_curButton.actionReleased();
				}
				else if (_curButton.actionWhile != null && _curButton.actionWhile != doNothing && BasicData.keyboard.isKeyPressed(_curButton.key))
				{
					_curButton.actionWhile();
				}
			}
			
			for (i = 0; i < _axis.length; i++) 
			{
				_curAxis = _axis[i];
				if (BasicData.keyboard.isKeyPressed(_curAxis.keyMin) && !BasicData.keyboard.isKeyPressed(_curAxis.keyMax))
				{
					if (_curAxis.lastState != AxisData.MINPRESSED)
					{
						_curAxis.lastState = AxisData.MINPRESSED;
						_curAxis.action(_curAxis.valueMin);
					}
				}
				else if (!BasicData.keyboard.isKeyPressed(_curAxis.keyMin) && BasicData.keyboard.isKeyPressed(_curAxis.keyMax))
				{
					if (_curAxis.lastState != AxisData.MAXPRESSED)
					{
						_curAxis.lastState = AxisData.MAXPRESSED;
						_curAxis.action(_curAxis.valueMax);
					}
				}
				else if (!BasicData.keyboard.isKeyPressed(_curAxis.keyMin) && !BasicData.keyboard.isKeyPressed(_curAxis.keyMax))
				{
					if (_curAxis.lastState != AxisData.NONEPRESSED)
					{
						_curAxis.lastState = AxisData.NONEPRESSED;
						_curAxis.action(0);
					}
				}
				else if (_curAxis.lastState != AxisData.NONEPRESSED)
				{
					_curAxis.lastState = AxisData.NONEPRESSED;
					_curAxis.action(0);
				}
			}
			
		}
		public function createButton($key:int, $press:Function, $release:Function, $while:Function=null):void
		{
			if ($while == null)
				$while = doNothing;
			_buttons.push(new ButtonData($key, $press, $release, $while));
		}
		public function createAxis($keyMin:int, $keyMax:int, $function:Function, $valueMin:Number, $valueMax:Number):void
		{
			_axis.push(new AxisData($keyMin, $keyMax, $function, $valueMin, $valueMax));
		}
		public function removeAxis($key:int):void
		{
			for (var i:int = 0; i < _axis.length; i++) 
			{
				if (_axis[i].keyMax == $key || _axis[i].keyMin == $key)
				{
					_axis.splice(i,1);
					return;
				}
			}
		}
		public function removeButton($key:int):void
		{
			for (var i:int = 0; i < _buttons.length; i++) 
			{
				if (_buttons[i].key == $key)
				{
					_buttons.splice(i,1);
					return;
				}
			}
		}
		protected function doNothing():void
		{
			
		}
		protected override function disposing():void
		{
			_buttons=null;
			_axis = null;
			super.disposing();
		}
	}
}