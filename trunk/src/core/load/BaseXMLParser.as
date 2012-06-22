package core.load
{
	import flash.events.EventDispatcher;

	public class BaseXMLParser extends EventDispatcher
	{
		public function BaseXMLParser()
		{
		}
		public function parseBoolean($v:String):Boolean
		{
			if ($v.toLowerCase() == "true")
				return true;
			else
				return false;
		}
	}
}