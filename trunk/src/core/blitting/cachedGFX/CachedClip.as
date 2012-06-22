package  core.blitting.cachedGFX
{
	import core.blitting.BListBase;
	
	import flash.geom.ColorTransform;
	
	public class CachedClip 
	{
		private static var _COUNTER:int = 0 ;
		
		
		public var id	: int ;
		
		public var next : CachedClip ;
		public var prev : CachedClip ;
		public var parentList : BListBase ;
		
		public var x		: Number = 0;
		public var y 		: Number = 0;

		// Ignored if rendering methode of the BlittingLayer is copyPixels()
		public var rotation : Number = 0;
		public var scaleX 	: Number = 1;
		public var scaleY 	: Number = 1;
		public var blendMode : String = null ;
		
		// setting a color transform will force the rendering of the CachedClip with the draw() method !
		// don't forget to nullify the ColorTransform when you're done with it !
		public var colorTransform : ColorTransform = null ;
		
		public var currentFrame : int ;
		public var totalFrames 	: int ;
		public var isPlaying 	: Boolean = true ;
		
		public var pingPongMode 	: Boolean = false ;
		public var isPlayingForward : Boolean = true ;
		
		public var visible		: Boolean = true;
		
		private var _animation : CachedAnimation;
		public var frame : CachedFrame;
		
		public function get left():int { return x - framePivotX; }
		public function get right():int { return x + frameWidth - framePivotX; }
		public function get top():int { return y - framePivotY; }
		public function get bottom():int { return y + frameHeight - framePivotY; }
		
		private var framePivotX:int;
		private var framePivotY:int;
		private var frameWidth:int;
		private var frameHeight:int;
		
		
		protected var _paused:Boolean = false;

		public function set animation ( $animation : CachedAnimation ) : void
		{
			if ( $animation )
			{
				_animation = $animation;
				currentFrame = 1;
				totalFrames = _animation.framesArray.length;
				frame = _animation.framesArray[currentFrame-1];
				framePivotX = frame.pivotX;
				framePivotY = frame.pivotY;
				frameWidth = frame.width;
				frameHeight = frame.height;
			}
		}	
		
		public function get animation () : CachedAnimation { return _animation ; }
		
		protected var _state:int;
		
		/**
		 * The equivalent of a MovieClip for our blitting renderer
		 * @param $animation You can set the animation now or later with the animation setter
		 */
		public function CachedClip( $animation : CachedAnimation ) : void
		{
			id = ++_COUNTER ;
			parentList = null ;
			animation = $animation ;
		}
		
	
		
		public function reset ( $animation : CachedAnimation = null ) : void
		{
			x = 0;
			y = 0;
			rotation = 0;
			scaleX = 1;
			scaleY = 1;
			colorTransform = null ;
			blendMode = null ;
			if ( $animation )
			{
				_animation = $animation;
				currentFrame = 1;
				totalFrames = _animation.framesArray.length;
				frame = _animation.framesArray[currentFrame-1];
				framePivotX = frame.pivotX;
				framePivotY = frame.pivotY;
				frameWidth = frame.width;
				frameHeight = frame.height;
			}
		}
		
		/**
		 * Manage the progression of the playhead
		 */
		public function update () : void
		{
			if (_paused)
				return;
			if (!_animation)
				return;
			if ( isPlaying )
			{
				if ( isPlayingForward )
				{
					currentFrame ++ ;
					if ( currentFrame > totalFrames )
					{
						if ( !pingPongMode )
						{
							currentFrame = 1;
						}else{
							currentFrame = totalFrames - 1 ;
							isPlayingForward = false ;
						}
					}
				}
				else
				{
					currentFrame -- ;
					if ( currentFrame < 1 )
					{
						if ( !pingPongMode )
						{
							currentFrame = totalFrames ;
						}else {
							currentFrame = 2 ;
							isPlayingForward = true ;
						}
					}
				}
					
				frame = _animation.framesArray[currentFrame - 1];
				framePivotX = frame.pivotX;
				framePivotY = frame.pivotY;
				frameWidth = frame.width;
				frameHeight = frame.height;
			}
		}
		
		public function stop () : void
		{
			isPlaying = false;
		}
		
		public function play () : void
		{
			isPlaying = true;
		}
		
		public function gotoAndPlay ( frameNum : int ) : void
		{
			if ( frameNum <= totalFrames )
			{
				isPlaying = true;
				currentFrame = frameNum ;
				frame = _animation.framesArray[currentFrame - 1];
				framePivotX = frame.pivotX;
				framePivotY = frame.pivotY;
				frameWidth = frame.width;
				frameHeight = frame.height;
			}			
		}
		
		public function gotoAndStop ( frameNum : int ) : void
		{
			if ( frameNum <= totalFrames )
			{
				isPlaying = false;
				currentFrame = frameNum ;
				frame = _animation.framesArray[currentFrame - 1];
				framePivotX = frame.pivotX;
				framePivotY = frame.pivotY;
				frameWidth = frame.width;
				frameHeight = frame.height;
			}			
		}
		
		public function clear () : void
		{
			next = null ;
			prev = null ;
			parentList = null ;
			colorTransform = null ;
			_animation = null ;
			frame = null ;
		}
		public function pause():void
		{
			_paused = true;
		}
		public function unpause():void
		{
			_paused = false;
		}
	}
	
}