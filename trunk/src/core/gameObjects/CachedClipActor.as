package core.gameObjects
{
	import core.blitting.BListPool;
	import core.blitting.cachedGFX.CachedClip;
	import core.mem.Mem;
	import core.newstatics.TimeRangeValue;
	import core.quadtree.QuadTreeNode;
	
	import flash.geom.Rectangle;
	
	public class CachedClipActor extends PositionableActor implements IFocuseable
	{
		public var node:QuadTreeNode;
		public function get collisionGroup():String { return null; }
		
		protected var _collisionIterations:int = 1;
		
		protected var _cachedClipBeforePause:int;
		protected var _cachedClip:CachedClip;
			public function get cachedClip():CachedClip { return _cachedClip; }
		
		private var _changedPos:Boolean = false;
		private var _changedAngle:Boolean = false;
		
		protected var _container:BListPool;
		
		public function CachedClipActor($initParams:CCInstantiationParams)
		{
			_container = $initParams.container;
			
			super($initParams);
		}
		public override function initialize():void
		{
			super.initialize();
			_cachedClip = _container.create(true);//new CachedClip(animation);
		}

		protected override function rendering():void
		{
			if (!_cachedClip)
				return;
			
			if (updateActive)
			{
				if (_interpolated)
				{
					_cachedClip.x = getGraphicX();
					_cachedClip.y = getGraphicY();
				}
				else
				{
					_cachedClip.x = _pos.x;
					_cachedClip.y = _pos.y;
				}
			}
			super.rendering()
		}

		public function getGraphicX():Number
		{
			return TimeRangeValue.now(_lastPos.x, _pos.x);
		}
		public function getGraphicY():Number
		{
			return TimeRangeValue.now(_lastPos.y, _pos.y);
		}
		public override function setPos($x:int, $y:int):void
		{
			super.setPos($x, $y);
			if (_cachedClip)
			{
				_cachedClip.x = $x;
				_cachedClip.y = $y;
			}
		}
		public override function setAngle($a:int):void
		{
			super.setAngle($a);
			if (_cachedClip)
				_cachedClip.rotation = $a;
		}
		protected override function disposing():void
		{
			if (_cachedClip)
				_container.remove(_cachedClip);
			
			Mem.rect.put(r1);
			Mem.rect.put(r2);
			collideobj = null;
			currentNode = null;

			super.disposing();
			
		}
		public override function disableUpdate():void
		{
			super.disableUpdate();
			if (_cachedClip)
				_cachedClip.pause();
		}

		public override function enableUpdate():void
		{
			super.enableUpdate();
			if (_cachedClip)
				_cachedClip.unpause();
		}
		override public function toRecycle():void
		{
			if (_cachedClip)
			{
				_container.dispose(_cachedClip);
				_cachedClip = null;
			}
			super.toRecycle();
		}

		private var collideobj:CachedClipActor;
		private var currentNode:QuadTreeNode = node;
		private var tmpIdx2:int;
		private var tmpIdx:int;

		public override function setVel($x:int, $y:int):void
		{
			super.setVel($x, $y);

			_collisionIterations = int(Math.max((_vel.x ^ (_vel.x >> 31)) - (_vel.x >> 31), (_vel.y ^ (_vel.y >> 31)) - (_vel.y >> 31)) / Math.min(width, height));
			//(value ^ (value >> 31)) – (value >> 31);
		}
		private var _collidingObjs:Vector.<CachedClipActor>;
/*		private function abs($num:Number):Number
		{
			return ($num ^ ($num >> 31)) - ($num >> 31);
		}*/
		public function checkCollision($group:String=null):void 
		{
			var initposx:Number = _pos.x;
			var initposy:Number = _pos.y;
			
			_pos.x -= _vel.x;
			_pos.y -= _vel.y;
			
			for (tmpIdx2 = 0; tmpIdx2 < _collisionIterations; tmpIdx2++)
			{
				_pos.x += int(_vel.x/_collisionIterations);
				_pos.y += int(_vel.y/_collisionIterations);
				
				currentNode = node;
				while(currentNode)
				{
					if ($group!= null)
						_collidingObjs = currentNode.objsByGroup[$group];
					else
						_collidingObjs = currentNode.objects;
					if (_collidingObjs)
					{
						for (tmpIdx = _collidingObjs.length-1; tmpIdx >=0 ; tmpIdx--) 
						{
							collideobj = _collidingObjs[tmpIdx];
							if(this!=collideobj)
							{
								if(this.overlaps(collideobj)) 
								{
									var max:Number = Math.max((_vel.x ^ (_vel.x >> 31)) - (_vel.x >> 31),(_vel.y ^ (_vel.y >> 31)) - (_vel.y >> 31));
									var velxfrac:Number = (_vel.x/max);
									var velyfrac:Number = (_vel.y/max);
									_pos.x = initposx;
									_pos.y = initposy;
									_pos.x -= _vel.x*2;
									_pos.y -= _vel.y*2;

									if (_vel.x>0)
									{
										while(int(right)!=int(collideobj.left) && _pos.x <= initposx) 
										{
											_pos.x+=velxfrac;
										}
									}
									else if (_vel.x<0)
									{
										while(int(left)!=int(collideobj.right) && _pos.x >= initposx) 
										{
											_pos.x+=velxfrac;
										}
									}
									
									if (_vel.y>0)
									{
										while(int(bottom)!=int(collideobj.top) && _pos.y <= initposy) 
										{
											_pos.y+=velyfrac;
										}
									}
									
									else if (_vel.y<0)
									{
										while(int(top)!=int(collideobj.bottom) && _pos.y >= initposy) 
										{
											_pos.y+=velyfrac;
										}
									}
									
									collided(collideobj, _pos.x, _pos.y);
									tmpIdx = 0;
									tmpIdx2 = 0;
									collideobj = null;
									currentNode = null;
									_pos.x = initposx;
									_pos.y = initposy;
									return;
	
								}
							}
						}
					}
					currentNode = currentNode._parent;
				}
			}
			
			_pos.x = initposx;
			_pos.y = initposy;
			
			tmpIdx = 0;
			tmpIdx2=0;
			collideobj = null;
			currentNode = null;
		}
		protected function collided($obj:CachedClipActor, $px:int, $py:int):void
		{
			
		}
		protected var r1:Rectangle = Mem.rect.get() as Rectangle;
		protected var r2:Rectangle = Mem.rect.get() as Rectangle;

		public function overlaps($obj:CachedClipActor):Boolean
		{
			if((left <= $obj.left && $obj.left <= right)
				|| (left <= $obj.right && $obj.right <= right)){

				if($obj.top <= top && top <= $obj.bottom){
					return true;
				}                       
				if($obj.top <= bottom && bottom <= $obj.bottom){
					return true;
				}       
			}
		
			if(    (top <= $obj.top && $obj.top <= bottom) 
				|| (top <= $obj.bottom && $obj.bottom <= bottom) ){
				
				if($obj.left <= left && left <= $obj.right){
					return true;
				}
				if($obj.left <= right && right <= $obj.right)
				{
					return true;
				}
			}
			if(contains($obj) || $obj.contains(this)){
				return true;
			}
			
			return false;
		}
		public function contains($obj:CachedClipActor):Boolean
		{
			if((left <= $obj.left && top <= $obj.top)
				&&($obj.right <= right)
				&&($obj.bottom <= bottom)){
				return true;
			}
			
			return false;
		}
	}
}