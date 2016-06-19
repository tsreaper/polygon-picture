package graph
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import data.Data;
	
	public class Graph extends Sprite
	{
		private var backup:Polygon;
		private var backupId:int;
		
		private var picture:Sprite = new Sprite();
		private var fitText:TextField = new TextField();
		private var textFormat:TextFormat = new TextFormat(null, 14, null, true);
		
		public var bmp:Bitmap = new Bitmap(new BitmapData(Data.WIDTH, Data.HEIGHT));
		public var genome:Array = [];
		public var unfitness:int;
		
		public function Graph()
		{
			initGraph();
		}
		
		private function initGraph():void
		{
			fitText.autoSize = TextFieldAutoSize.LEFT;
			fitText.selectable = false;
			addChild(bmp);
			addChild(fitText);
		}
		
		private function drawPicture():void
		{
			var i, j:int;
			
			picture.graphics.clear();
			picture.graphics.beginFill(0xffffff);
			picture.graphics.drawRect(0, 0, Data.WIDTH, Data.HEIGHT);
			picture.graphics.endFill();
			for (i=0;i<Data.GENOME_SIZE;i++)
			{
				picture.graphics.beginFill(genome[i].red * 0x010000 + genome[i].green * 0x0100 + genome[i].blue, genome[i].alpha);
				picture.graphics.moveTo(genome[i].x[0], genome[i].y[0]);
				for (j=1;j<Data.EDGE_NUM;j++)
				{
					picture.graphics.lineTo(genome[i].x[j], genome[i].y[j]);
				}
				picture.graphics.endFill();
			}
			bmp.bitmapData.draw(picture);
		}
		
		public function drawFitness():void
		{
			fitText.text = ((1-unfitness/(Data.WIDTH*Data.HEIGHT*255*3))*100).toFixed(2) + "%";
			fitText.setTextFormat(textFormat);
			fitText.x = (Data.WIDTH - fitText.width)/2;
			fitText.y = Data.HEIGHT;
		}
		
		public function changeGenome():Array
		{
			var r:Number;
			
			r = Math.random()*2;
			backupId = Math.floor(Math.random()*Data.GENOME_SIZE);
			backup = genome[backupId].clone();
			if (r < 0.25)
			{
				genome[backupId].red = Math.floor(Math.random()*256);
			}
			else if(r < 0.5)
			{
				genome[backupId].green = Math.floor(Math.random()*256);
			}
			else if(r < 0.75)
			{
				genome[backupId].blue = Math.floor(Math.random()*256);
			}
			else if(r < 1)
			{
				genome[backupId].alpha = Math.random();
			}
			else if(r < 1.5)
			{
				genome[backupId].x[Math.floor(Math.random()*Data.EDGE_NUM)] = Math.floor(Math.random()*Data.WIDTH);
			}
			else
			{
				genome[backupId].y[Math.floor(Math.random()*Data.EDGE_NUM)] = Math.floor(Math.random()*Data.WIDTH);
			}
			return [backupId, genome[backupId]];
		}
		
		public function changeGenomeGaussian():Array
		{
			var r:Number;
			var posId:int;
			
			r = Math.random()*2;
			backupId = Math.floor(Math.random()*Data.GENOME_SIZE);
			posId = Math.floor(Math.random()*Data.EDGE_NUM);
			backup = genome[backupId].clone();
			if (r < 0.25)
			{
				genome[backupId].red = Data.randBell(255, genome[backupId].red);
			}
			else if(r < 0.5)
			{
				genome[backupId].green = Data.randBell(255, genome[backupId].green);
			}
			else if(r < 0.75)
			{
				genome[backupId].blue = Data.randBell(255, genome[backupId].blue);
			}
			else if(r < 1)
			{
				genome[backupId].alpha = 0.00392156 * Data.randBell(255, genome[backupId].alpha*255);
			}
			else if(r < 1.5)
			{
				genome[backupId].x[posId] = Data.randBell(Data.WIDTH, genome[backupId].x[posId]);
			}
			else
			{
				genome[backupId].y[posId] = Data.randBell(Data.HEIGHT, genome[backupId].y[posId]);
			}
			return [backupId, genome[backupId]];
		}
		
		public function undoChange():void
		{
			genome[backupId] = backup;
		}
		
		public function calcFitness():void
		{
			var i, j:int;
			var stdColor, stdRed, stdGreen, stdBlue:int;
			var myColor, myRed, myGreen, myBlue:int;
			
			drawPicture();
			
			unfitness = 0;
			
			for (i=0;i<Data.HEIGHT;i++)
			{
				for (j=0;j<Data.WIDTH;j++)
				{
					stdColor = Data.avatar.getPixel(j, i);
					stdRed = stdColor>>16; stdGreen = (stdColor>>8)%256; stdBlue = stdColor%256;
					myColor = bmp.bitmapData.getPixel(j, i);
					myRed = myColor>>16; myGreen = (myColor>>8)%256; myBlue = myColor%256;
					unfitness += Math.abs(stdRed-myRed)+Math.abs(stdGreen-myGreen)+Math.abs(stdBlue-myBlue);
				}
			}
			
			drawFitness();
		}
		
	}
}
