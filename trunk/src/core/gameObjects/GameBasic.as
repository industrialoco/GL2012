package core.gameObjects
{	
	import flash.events.EventDispatcher;

	/**
	 * This is a useful "generic" Flixel object.
	 * Both <code>FlxObject</code> and <code>FlxGroup</code> extend this class,
	 * as do the plugins.  Has no size, position or graphical data.
	 * 
	 * @author	Adam Atomic
	 */
	public class GameBasic extends EventDispatcher
	{
		public var initParams:InstantiationParams;
		
		protected var _step:uint = 0;
		/**
		 * IDs seem like they could be pretty useful, huh?
		 * They're not actually used for anything yet though.
		 */
		public function get ID():String { return ""; }
		/**
		 * Controls whether <code>update()</code> is automatically called by FlxState/FlxGroup.
		 */
		public var updateActive:Boolean;
		/**
		 * Controls whether <code>draw()</code> is automatically called by FlxState/FlxGroup.
		 */
		public var renderActive:Boolean;
		/**
		 * Useful state for many game objects - "dead" (!alive) vs alive.
		 * <code>kill()</code> and <code>revive()</code> both flip this switch (along with exists, but you can override that).
		 */
		public var forRecycle:Boolean;
		public var recycled:Boolean;

		/**
		 * Instantiate the basic flixel object.
		 */

		public var disposed:Boolean = false;
		
		public function GameBasic($initParams:InstantiationParams=null)
		{
			updateActive = true;
			renderActive = true;
			forRecycle = false;
			recycled = false;
			initParams = $initParams;
			initialize();
		}

		public function initialize():void
		{
			
		}
		public final function dispose():void 
		{
			disposing();
		}
		protected function disposing():void
		{
			disposed = true;
		}
		protected function preUpdate():void
		{

		}
		public final function update($step:uint):void
		{
			preUpdate();
			updating($step);
			postUpdate();	
		}
		protected function postUpdate():void
		{
			
		}
		protected function updating($step:uint):void
		{
			
		}
		public final function render():void
		{
			preRender();
			rendering();
			postRender();
		/**
		 * Override this function to control how the object is drawn.
		 * Overriding <code>draw()</code> is rarely necessary, but can be very useful.
		 */
		}
		protected function preRender():void
		{
			
		}
		protected function rendering():void
		{
			
		}
		protected function postRender():void
		{
			
		}
		
		/**
		 * Handy function for "killing" game objects.
		 * Default behavior is to flag them as nonexistent AND dead.
		 * However, if you want the "corpse" to remain in the game,
		 * like to animate an effect or whatever, you should override this,
		 * setting only alive to false, and leaving exists true.
		 */
		public function toRecycle():void
		{
			forRecycle = true;
			updateActive = false;
			renderActive = false;
		}
		/**
		 * Handy function for bringing game objects "back to life". Just sets alive and exists back to true.
		 * In practice, this function is most often called by <code>FlxObject.reset()</code>.
		 */
		public function revive():void
		{
			recycled = false;
			forRecycle = false;
			updateActive = true;
			renderActive = true;
			initialize();
		}
		public function disableUpdate():void
		{
			updateActive=false;
		}
		public function enableUpdate():void
		{
			updateActive=true;
		}
	}
}
