package core.gameStates
{
	import core.newstatics.BasicData;
	

	public class PauseableGameState extends GameState
	{
		protected var _pauseOn:Boolean = false;
		protected function get pauseKey():int { return 80; }
		
		public function PauseableGameState()
		{
			super();
		}
		
		protected override function updating($step:uint):void
		{
			super.updating($step);
			if (BasicData.keyboard.justPressed(pauseKey))
			{
				if (!_pauseOn)
				{
					//disableUpdate
					trace ("PAUSED ");
					disableUpdate();
					updateActive=true;
				}
				else
				{
					//disableUpdate
					trace ("UNPAUSED ");
					enableUpdate();
				}
				_pauseOn = !_pauseOn;
			}
		}
	}
}