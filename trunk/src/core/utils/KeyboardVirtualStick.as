package core.utils 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class KeyboardVirtualStick 
	{		
		protected var _stage : Sprite;
		
		private var _Xaxis : Number = 0;
		private var _Yaxis : Number = 0;
		public function get Xaxis () : Number	{ return _Xaxis; }
		public function get Yaxis () : Number	{ return _Yaxis; }
				
		private var _upKeyCode		: int ;
		private var _downKeyCode 	: int ;
		private var _leftKeyCode 	: int ;
		private var _rightKeyCode 	: int ;
		
		private var _altUpKeyCode		: int ;
		private var _altDownKeyCode 	: int ;
		private var _altLeftKeyCode 	: int ;
		private var _altRightKeyCode 	: int ;
		
		public function defineKeys ( $upKeyCode : int, $downKeyCode : int, $leftKeyCode : int, $rightKeyCode : int,  $altUpKeyCode : int, $altDownKeyCode : int, $altLeftKeyCode : int, $altRightKeyCode : int ) : void
		{
			_upKeyCode 		= $upKeyCode;
			_downKeyCode 	= $downKeyCode;
			_leftKeyCode 	= $leftKeyCode;
			_rightKeyCode	= $rightKeyCode;
			
			_altUpKeyCode 		= $altUpKeyCode;
			_altDownKeyCode 	= $altDownKeyCode;
			_altLeftKeyCode 	= $altLeftKeyCode;
			_altRightKeyCode	= $altRightKeyCode;
		}
		
		protected var _keyStates : Object = new Object ();
		
		private var _timer : Timer;

		protected var _enabled : Boolean = true;
		public function set enabled ( value : Boolean ):void { 
			_enabled 	= value;
			_Xaxis 		= 0;
			_Yaxis		= 0;
			if ( value ) 
				_timer.start();
			else
				_timer.stop();
		}
		
		private var _speed : Number ;
		
		// CONSTRUCTEUR
		public function KeyboardVirtualStick(	$stage : Sprite, 
												$speed : Number = 0.25, 
												$upKeyCode : int = 38, 
												$downKeyCode : int = 40, 
												$leftKeyCode : int = 37, 
												$rightKeyCode : int = 39, 
												$altUpKeyCode : int = 90, 
												$altDownKeyCode : int = 83, 
												$altLeftKeyCode : int = 81, 
												$altRightKeyCode : int = 68) : void
		{
			defineKeys ( $upKeyCode, $downKeyCode, $leftKeyCode, $rightKeyCode, $altUpKeyCode, $altDownKeyCode, $altLeftKeyCode, $altRightKeyCode );
			_speed = $speed;
			
			_stage = $stage;
			
			_stage.stage.addEventListener ( KeyboardEvent.KEY_DOWN, onKeyPressedHandler );
			_stage.stage.addEventListener ( KeyboardEvent.KEY_UP, onKeyReleasedHandler );
			
			_stage.stage.addEventListener ( Event.DEACTIVATE, onLoseFocus );
			
			
			_timer = new Timer ( 50, 0 )
			_timer.addEventListener ( TimerEvent.TIMER, onTimerTick );
			_timer.start();
		}
		
		protected function onLoseFocus ( evt : Event ) : void
		{
			for ( var key:* in _keyStates )
			{
				_keyStates[key] = false ;
			}	
		}
		
		protected function onGainFocus ( evt : MouseEvent ) : void
		{
			_enabled = true ;
			_stage.stage.removeEventListener ( MouseEvent.MOUSE_MOVE, onGainFocus );
		}
		
		protected function onKeyPressedHandler ( evt : KeyboardEvent ) : void
		{
			var keyCode : int = evt.keyCode ;
			
			if ( !_enabled ) return ;
			
			_keyStates[keyCode] = true ;
			
			if ( keyCode == _leftKeyCode || keyCode == _altLeftKeyCode  )
			{
				_keyStates[_altRightKeyCode]= false ;
				_keyStates[_rightKeyCode] 	= false ;
			}
			else if	( keyCode == _rightKeyCode || keyCode == _altRightKeyCode  )
			{
				_keyStates[_leftKeyCode] 	= false ;
				_keyStates[_altLeftKeyCode] = false ;
				
			}
			else if ( keyCode == _upKeyCode || keyCode == _altUpKeyCode  )
			{
				_keyStates[_downKeyCode] 	= false ;
				_keyStates[_altDownKeyCode] = false ;
			}
			else if ( keyCode == _downKeyCode || keyCode == _altDownKeyCode  )
			{
				_keyStates[_upKeyCode] 	= false ;
				_keyStates[_altUpKeyCode] = false ;
			}
		}
		
		protected function onKeyReleasedHandler ( evt : KeyboardEvent ) : void
		{
			if ( !_enabled ) return ;
			_keyStates[evt.keyCode] = false ;
		}
		
		private function onTimerTick ( evt : TimerEvent ):void
		{
			eval_Xaxis ();
			eval_Yaxis();
		}
		
		private function eval_Xaxis ():void
		{
			// on pousse le stick vers la gauche
			if ( _keyStates[_leftKeyCode] || _keyStates[_altLeftKeyCode] )
			{
				if ( _Xaxis > 0 )
					_Xaxis -= _speed * 2;
				else
					_Xaxis -= _speed;
				_Xaxis = _Xaxis < -1 ? -1 : _Xaxis ;
				return ;
			}
			
			// on pousse le stick vers la droite
			if ( _keyStates[_rightKeyCode] || _keyStates[_altRightKeyCode] )
			{
				if ( _Xaxis >= 0 )
					_Xaxis += _speed;
				else
					_Xaxis += _speed * 2;
				_Xaxis = _Xaxis > 1 ? 1 : _Xaxis;
				return ;
			}
			
			// on ne pousse pas le stick horizontalement
			_Xaxis *= 0.5
			if ( _Xaxis > 0 )
				if ( _Xaxis < _speed )
					_Xaxis = 0;
			if ( _Xaxis < 0 )
				if ( _Xaxis > -_speed )
					_Xaxis = 0;
			
		}
		
		private function eval_Yaxis ():void
		{
			// on pousse le stick vers la haut
			if ( _keyStates[_upKeyCode] || _keyStates[_altUpKeyCode] )
			{
				if ( _Yaxis > 0 )
					_Yaxis -= _speed * 2;
				else
					_Yaxis -= _speed;
				_Yaxis = _Yaxis < -1 ? -1 : _Yaxis;
				return ;
			}
			
			// on pousse le stick vers la bas
			if ( _keyStates[_downKeyCode] || _keyStates[_altDownKeyCode] )
			{
				if ( _Yaxis >= 0 )
					_Yaxis += _speed;
				else
					_Yaxis += _speed * 2;
				_Yaxis = _Yaxis > 1 ? 1 : _Yaxis;
				return ;
			}
			
			// on ne pousse pas le stick verticalement
			_Yaxis *= 0.5
			if ( _Yaxis > 0 )
				if ( _Yaxis < _speed )
					_Yaxis = 0;
			if ( _Yaxis < 0 )
				if ( _Yaxis > -_speed )
					_Yaxis = 0;
		}
		
		
	}
	
}