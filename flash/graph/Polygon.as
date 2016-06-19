package graph
{
	
	public class Polygon
	{
		public var x:Array;
		public var y:Array;
		public var red, green, blue:int;
		public var alpha:Number;
		
		public function Polygon(_x:Array, _y:Array, _red:int, _green:int, _blue:int, _alpha:Number)
		{
			x = _x.concat(); y = _y.concat();
			red = _red; green = _green; blue = _blue;
			alpha = _alpha;
		}
		
		public function clone():Polygon
		{
			return new Polygon(x, y, red, green, blue, alpha);
		}
	}
	
}
