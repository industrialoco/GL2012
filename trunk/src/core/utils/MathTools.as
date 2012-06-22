package core.utils
{
	public class MathTools
	{
		public function MathTools()
		{
			
		}
		public static function random($min:int, $max:int):int
		{
			return (Math.random() * ( $max - $min)) + $min; 
		}
	}
}