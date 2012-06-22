package core.updater
{
	public class DelayedExecution
	{
		public var step:int;
		public var callback:Function;
		public var params:*;
		public function DelayedExecution($step:int=0, $callback:Function=null, $params:* = null)
		{
			step = $step;
			callback = $callback;
			params = $params;
		}
	}
}