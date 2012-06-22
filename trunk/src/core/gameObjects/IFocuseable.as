package core.gameObjects
{
	import core.blitting.cachedGFX.CachedClip;
	

	public interface IFocuseable extends IPosicionable
	{
		function get cachedClip():CachedClip;
		function getGraphicX():Number;
		function getGraphicY():Number;
		
	}
}