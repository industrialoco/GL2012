package core.newstatics
{
	import core.collisions.ColliderStatic;
	import core.collisions.GameRect;
	import core.gameStates.GameStateManager;
	import core.input.KeyboardAccess;
	import core.load.DynamicLoader;
	
	import flash.display.Stage;

	public class BasicData
	{
		public static var width:int;
		public static var height:int;
		public static var mainURL:String;
		public static var keyboard:KeyboardAccess;
		public static var stage:Stage;
		public static var stateManager:GameStateManager;
		public static var dynamicLoader:DynamicLoader;
		public static var gameArea:GameRect;
		
		public function BasicData()
		{
		}
		public static function setGameArea($w:int, $h:int):void
		{
			gameArea.width=$w;
			gameArea.height=$h;
			ColliderStatic.renewQT();
		}
	}
}