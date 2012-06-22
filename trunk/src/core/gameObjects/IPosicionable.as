package core.gameObjects
{
	public interface IPosicionable
	{

		function get posx():int;
		function get posy():int;
		
		function get velx():int;
		function get vely():int;
		
		function get lastPosx():int;
		function get lastPosy():int;
		
		function get angle():int;
		function get anglevel():int
	}
}