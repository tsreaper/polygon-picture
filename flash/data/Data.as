package data
{
	import flash.display.BitmapData;
	
	public class Data
	{
		public static const WIDTH:int = 100;
		public static const HEIGHT:int = 100;
		
		public static const STAGE_WIDTH:int = 550;
		public static const STAGE_HEIGHT:int = 400;
		
		public static const MAX_EDGE:int = 20;
		public static const MIN_EDGE:int = 3;
		public static const MAX_GENOME:int = 300;
		public static const MIN_GENOME:int = 1;
		
		public static var EDGE_NUM:int;
		public static var GENOME_SIZE:int;
		public static var RAND_STYLE:int;
		
		public static var avatar:BitmapData;
		
		private static var bellDistributions:Object = new Object();
		private static var bellOffsets:Object = new Object();
		
		private static function bellPrecompute(range:int, spread:Number, resolution:Number):Object
		{
			var accumulator:Number = 0;
			var step:Number = 1 / resolution;
			var index:int = 0;
			
			bellOffsets[range] = new Object();
			bellDistributions[range] = new Object();
			for (var x:int = -range-1; x <= range+1; x++)
			{
				bellOffsets[range][x] = index;
				accumulator = step + Math.exp(-x*x/2/spread/spread);
				while (accumulator >= step)
				{
					if (x != 0) bellDistributions[range][index++] = x;
					accumulator -= step;
				}
			}
			return bellDistributions[range];
		}
		
		public static function randBell(range:int, center:int):int
		{
			var dist:Object = bellDistributions[range];
			if (!dist)
			{
				dist = bellPrecompute(range, range/6, 40);
			}
			var off:Object = bellOffsets[range];
			return center + dist[off[-center]+Math.floor((off[range-center+1]-off[-center])*Math.random())];
		}

	}
}