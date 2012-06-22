package core.input
{
	public class ButtonData
	{
		public var key:int;
		public var actionPressed:Function;
		public var actionReleased:Function;
		public var actionWhile:Function;
		
		public function ButtonData($key:int, $actionPressed:Function, $actionReleased:Function, $actionWhile:Function=null)
		{
			key = $key;
			actionPressed = $actionPressed;
			actionReleased = $actionReleased;
			actionWhile = $actionWhile;
		}
	}
}