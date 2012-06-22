package core.newstatics
{
	import flash.utils.getTimer;

	public class TimeRangeValue
	{
		protected static var _initialMs:int;
		protected static var _finalMs:int;
		protected static var _now:uint;
		
		protected static var _timeBetween:Number;
		
		private static var currentTimeBetween:Number; 
		private static var v:Number;
		public function TimeRangeValue()
		{
		}
		public static function setTimes($i:int, $f:int):void
		{
			_initialMs = $i;
			_finalMs = $f;
			_timeBetween = _finalMs - _initialMs;
		}
		public static function now(_initialValue:Number, _finalValue:Number):Number
		{
			_now = getTimer();
			v = (((_now - _initialMs) * (_finalValue - _initialValue)) / _timeBetween)+_initialValue;
			return Math.round(v);
		}
	}
}