package core.gameStates
{
	public class GameStateDefinition
	{
		public var type:Class;
		public var id:String;
		public var waitmode:int;
		public function GameStateDefinition($type:Class, $id:String, $waitmode:int, $args:* = null)
		{
			type = $type;
			id = $id;
			waitmode = $waitmode;
		}
	}
}