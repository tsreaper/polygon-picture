package graph
{
	import flash.display.Sprite;
	
	public class Meter extends Sprite
	{
		private var cnt:Array;
		private var tot:int;
		
		public function Meter()
		{
			initGraph();
			initStats();
		}
		
		private function initGraph():void
		{
			var i:int;
			for (i=0;i<=15;i++)
			{
				this.graphics.beginFill(0x100000*i+0x1008*15);
				this.graphics.drawRect(0, 150*i/32, 30, 150/32);
				this.graphics.endFill();
			}
			for (i=16;i<=31;i++)
			{
				this.graphics.beginFill(0x100000*15+0x1008*(31-i));
				this.graphics.drawRect(0, 150*i/32, 30, 150/32);
				this.graphics.endFill();
			}
		}
		
		public function initStats():void
		{
			var i:int;
			cnt = [];
			for (i=0;i<=31;i++)
			{
				cnt.push(0);
			}
			tot = 0;
		}
		
		public function addVal(val:Number):void
		{
			var i:int;
			var sum:int = 0;
			if (val >= 0.05)
			{
				val = 0.0499;
			}
			else if(val < -0.05)
			{
				val = -0.05;
			}
			cnt[Math.floor(32*(val+0.05)/0.1)]++;
			tot++;
			this.graphics.clear();
			for (i=0;i<=15;i++)
			{
				this.graphics.beginFill(0x100000*i+0x1008*15);
				this.graphics.drawRect(0, 150*sum/tot, 30, 150*cnt[i]/tot);
				this.graphics.endFill();
				sum += cnt[i];
			}
			for (i=16;i<=31;i++)
			{
				this.graphics.beginFill(0x100000*15+0x1008*(31-i));
				this.graphics.drawRect(0, 150*sum/tot, 30, 150*cnt[i]/tot);
				this.graphics.endFill();
				sum += cnt[i];
			}
		}
	}
}