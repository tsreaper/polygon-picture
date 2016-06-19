package graph
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class Dashboard extends Sprite
	{
		private var xText:Array = [];
		private var yText:Array = [];
		private var textFormat:TextFormat = new TextFormat(null, 11);
		
		private var picture:Sprite = new Sprite();
		private var min:Number;
		
		public function Dashboard()
		{
			initBackground();
		}
		
		private function initBackground():void
		{
			var i:int;
			this.graphics.lineStyle(2, 0x0099cc);
			this.graphics.lineTo(200, 0);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, -150);
			this.graphics.lineStyle(1, 0x0099cc);
			for(i=1;i<=8;i++)
			{
				this.graphics.moveTo(0, -i*18.75);
				this.graphics.lineTo(200, -i*18.75);
			}
			for(i=1;i<=10;i++)
			{
				this.graphics.moveTo(i*20, 0);
				this.graphics.lineTo(i*20, -150);
			}
			for(i=0;i<=4;i++)
			{
				var ytxt:TextField = new TextField();
				ytxt.autoSize = TextFieldAutoSize.RIGHT;
				ytxt.selectable = false;
				ytxt.text = (i*25).toFixed(1)+"%";
				ytxt.setTextFormat(textFormat);
				ytxt.width = ytxt.textWidth;
				ytxt.height = ytxt.textHeight;
				ytxt.x = -5-ytxt.textWidth;
				ytxt.y = -i*37.5-ytxt.textHeight/2;
				addChild(ytxt);
				yText.push(ytxt);
			}
			for(i=0;i<=5;i++)
			{
				var xtxt:TextField = new TextField();
				xtxt.autoSize = TextFieldAutoSize.CENTER;
				xtxt.selectable = false;
				xtxt.text = (i*2000).toString();
				xtxt.setTextFormat(textFormat);
				xtxt.width = xtxt.textWidth;
				xtxt.height = xtxt.textHeight;
				xtxt.x = i*40-xtxt.textWidth/2;
				xtxt.y = 3;
				addChild(xtxt);
				xText.push(xtxt);
			}
			
			addChild(picture);
		}
		
		public function drawPoint(x0:int, y0:Number):void
		{
			var i:int;
			if(x0%10000 == 1)
			{
				min = y0 - 0.5;
				picture.graphics.clear();
				picture.graphics.lineStyle(2);
				picture.graphics.moveTo(0, -150*(y0-min)/(100-min));
				
				for(i=0;i<=4;i++)
				{
					yText[i].text = (min+i*(100-min)/4).toFixed(1)+"%";
					yText[i].setTextFormat(textFormat);
					yText[i].width = yText[i].textWidth;
					yText[i].x = -5-yText[i].textWidth;
				}
				
				for(i=0;i<=5;i++)
				{
					xText[i].text = (x0-1+i*2000).toString();
					xText[i].setTextFormat(textFormat);
					xText[i].width = xText[i].textWidth;
					xText[i].x = i*40-xText[i].textWidth/2;
				}
			}
			x0 %= 10000;
			picture.graphics.lineTo(x0*0.02, -150*(y0-min)/(100-min));
		}
	}
}