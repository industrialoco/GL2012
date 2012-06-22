package core.updater
{
	import core.collisions.ColliderStatic;
	import core.gameObjects.GameGroup;
	import core.newstatics.BasicData;
	import core.newstatics.TimeRangeValue;
	
	import de.polygonal.ds.pooling.DynamicObjectPool;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class UpdaterByTime extends GameGroup
	{
		protected var _maxFrameSkip:int;
		
		protected var _logicFPS:int;
		protected function get TICKS_PER_SECOND():int { return _logicFPS; }
		
		protected var _msByFrame:int;
		protected function get SKIP_TICKS():int { return _msByFrame; }
		
		protected var _currentTime:int;
			public function get currentTime():int { return _currentTime; }
		
		protected var _logicupdateTime:int;

		protected var _delayedExecutions:Vector.<DelayedExecution>;
		protected var _dePool:DynamicObjectPool;
		
		public function UpdaterByTime($logicFPS:int=25, $maxFrameSkip:int = 5)
		{
			super(null);
			
			_delayedExecutions= new Vector.<DelayedExecution>();
			_dePool = new DynamicObjectPool(DelayedExecution);
			
			_logicFPS = $logicFPS;
			_msByFrame = 1000 / $logicFPS;
			_maxFrameSkip = $maxFrameSkip;
			BasicData.stage.addEventListener(Event.ENTER_FRAME, updateStep,false, 255);
			
		
			_logicupdateTime = getTimer();
		}

		private function updateStep(event:Event):void
		{
		//	event.stopImmediatePropagation();
		//	event.stopPropagation();

			_currentTime = getTimer(); 
			//Tick.getFtime();
			while (_logicupdateTime<=_currentTime )
			{
				_logicupdateTime+=_msByFrame;
				_step++;
				update(_step);
				checkDelayed();
				ColliderStatic.update();
				TimeRangeValue.setTimes( _logicupdateTime - _msByFrame, _logicupdateTime);
				BasicData.stateManager.checkStateChanges();
			}
			render();
		}
		
		private var delayedExecution:DelayedExecution;
		
		public function waitSteps($steps:int, $func:Function, $params:*=null):void
		{
			delayedExecution = _dePool.get() as DelayedExecution;
			delayedExecution.step = _step + $steps;
			delayedExecution.callback = $func;
			delayedExecution.params = $params;
			
			_delayedExecutions.push(delayedExecution);
			delayedExecution=null;
			_delayedExecutions.sort(sortFunc);
		}
		private function sortFunc($a:DelayedExecution, $b:DelayedExecution):Number 
		{
			if ($a.step < $b.step)
				return 1;
			else
				return -1;
		}
		
		protected function checkDelayed():void
		{
			var l:int = _delayedExecutions.length-1;
			
			while (_delayedExecutions.length>0 && _delayedExecutions[l].step<=_step)
			{
				delayedExecution = _delayedExecutions[l];
				if (delayedExecution.params!= null)
					delayedExecution.callback(delayedExecution.params);
				else
					delayedExecution.callback();
				
				_dePool.put(delayedExecution);
				delayedExecution = null;
				
				_delayedExecutions.length--;
				l--;
			}
		}
	}
}