package core.input
{
	public class AxisData
	{
		protected var _keyMin:int;
			public function get keyMin():int { return _keyMin; }
		protected var _keyMax:int;
			public function get keyMax():int { return _keyMax; }
		protected var _action:Function;
			public function get action():Function { return _action; }
		protected var _valueMin:Number;
			public function get valueMin():Number { return _valueMin; }
		protected var _valueMax:Number;
			public function get valueMax():Number { return _valueMax; }

		public var lastState:int;
			
		public static const NONEPRESSED:int=0;
		public static const MINPRESSED:int=1;
		public static const MAXPRESSED:int=2;
		
		public function AxisData($keyMin:int, $keyMax:int, $action:Function, $valueMin:Number, $valueMax:Number)
		{
			_keyMin 		 = $keyMin;
			_keyMax			 = $keyMax;
			_action			 = $action;
			_valueMin		 = $valueMin;
			_valueMax		 = $valueMax;
			
			lastState = NONEPRESSED;
		}
	}
}