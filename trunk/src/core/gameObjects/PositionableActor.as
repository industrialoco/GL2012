package core.gameObjects
{
	import core.collisions.GameRect;
	import core.mem.Mem;
	
	import flash.geom.Point;
	
	public class PositionableActor extends GameGroup
	{
		protected var _interpolated:Boolean = true;
		
		protected var _hitarea:GameRect;
		
		public function get left():int { return _hitarea.x + _pos.x; }
		public function get right():int { return _hitarea.x + _hitarea.width + _pos.x; }
		public function get top():int { return _hitarea.y + _pos.y; }
		public function get bottom():int { return _hitarea.y + _hitarea.height + _pos.y; }
		
		public function get lastleft():int { return _hitarea.x + _lastPos.x; }
		public function get lastright():int { return _hitarea.x + _hitarea.width + _lastPos.x; }
		public function get lasttop():int { return _hitarea.y + _lastPos.y; }
		public function get lastbottom():int { return _hitarea.y + _hitarea.height + _lastPos.y; }
		
		public function get width():int { return _hitarea.width; }
		public function get height():int { return _hitarea.height; }
		
		protected var _pos:Point;
			public function get posx():int { return _pos.x; }
			public function get posy():int { return _pos.y; }
		
		protected var _lastPos:Point;
			public function get lastPosx():int { return _lastPos.x; }
			public function get lastPosy():int { return _lastPos.y; }
			
		protected var _vel:Point;
			public function get velx():int { return _vel.x; }
			public function get vely():int { return _vel.y; }
		
			
		protected var _angle:int;
			public function get angle():int { return _angle; }
			
		protected var _anglevel:int;
			public function get anglevel():int { return _anglevel; }
		
		public function PositionableActor($initParams:InstantiationParams=null)
		{
			_lastPos = Mem.point.get() as Point;
			_pos = Mem.point.get() as Point;
			_vel = Mem.point.get() as Point;
			_hitarea = Mem.gamerect.get() as GameRect;
			super($initParams);
		}
		public override function initialize():void
		{
			super.initialize();
			_pos.x=0;
			_pos.y=0;
			_lastPos.x = 0;
			_lastPos.y = 0;
			_vel.x=0;
			_vel.y=0;
		}

		protected override function postUpdate():void
		{
			super.postUpdate();

		}
		public function setPos($x:int, $y:int):void
		{
			_lastPos.x = $x;
			_lastPos.y = $y;
			_pos.x = $x;
			_pos.y = $y;
		}
		public function setVel($x:int, $y:int):void
		{
			_vel.x = $x;
			_vel.y = $y;
		}
		protected override function preUpdate():void
		{
			_lastPos.x = _pos.x;
			_lastPos.y = _pos.y;
			super.preUpdate();
		}
		public function setAngle($a:int):void
		{
			_angle = $a;
		}
		protected override function updating($step:uint):void
		{
			super.updating($step);
			_pos.x += _vel.x;
			_pos.y += _vel.y;
			_angle += _anglevel;
			if (_angle > 180)
				_angle = _angle - 360;
		}
		protected override function disposing():void
		{
			 Mem.point.put(_lastPos);
			 Mem.point.put(_pos);
			 Mem.point.put(_vel);
			_vel = null;
			_lastPos=null;
			_pos = null;
			Mem.gamerect.put(_hitarea);
			super.disposing();
		}
	}
}