package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.getDefinitionByName; 
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import fl.events.SliderEvent;
	import graph.Polygon;
	import graph.Graph;
	import graph.Dashboard;
	import graph.Meter;
	import data.Data;
	
	public class PolPicture extends MovieClip
	{
		private var generation:int;
		private var startTime:int;
		private var lastTime:int;
		
		private var bestGraph:Graph = new Graph();
		private var nowGraph:Graph = new Graph();
		
		private var dashboard:Dashboard = new Dashboard();
		private var meter:Meter = new Meter();
		private var originalBmp:Bitmap = new Bitmap();
		private var timer:Timer = new Timer(0);
		private var textFormat:TextFormat = new TextFormat();
		
		public function PolPicture()
		{
			initStage();
		}
		
		private function initGenome():void
		{
			var i, j, k:int;
			var input:Array;
			
			nowGraph.genome = [];
			bestGraph.genome = [];
			
			input = bestText.text.split(" ", bestText.text.length);
			if (input.length >= 2)
			{
				input[0] = int(input[0]); input[1] = int(input[1]);
				if (input[0] < Data.MIN_EDGE)
				{
					input[0] = Data.MIN_EDGE;
				}
				else if(input[0] > Data.MAX_EDGE)
				{
					input[0] = Data.MAX_EDGE;
				}
				if (input[1] < Data.MIN_GENOME)
				{
					input[1] = Data.MIN_GENOME;
				}
				else if(input[1] > Data.MAX_GENOME)
				{
					input[1] = Data.MAX_GENOME;
				}
				Data.GENOME_SIZE = input[1];
				Data.EDGE_NUM = input[0];
				numSlider.value = Data.GENOME_SIZE;
				edgeSlider.value = Data.EDGE_NUM;
				numText.text = Data.GENOME_SIZE.toString();
				edgeText.text = Data.EDGE_NUM.toString();
			}
			if (input.length-2 == (4+Data.EDGE_NUM*2)*Data.GENOME_SIZE)
			{
				for (i=0,j=2;i<Data.GENOME_SIZE;i++,j+=4+Data.EDGE_NUM*2)
				{
					for (k=0;k<3;k++)
					{
						input[j+k] = int(input[j+k]);
						if (input[j+k] < 0)
						{
							input[j+k] = 0;
						}
						else if (input[j+k] > 255)
						{
							input[j+k] = 255;
						}
					}
					input[j+3] = Number(input[j+3]);
					if (input[j+3] < 0)
					{
						input[j+3] = 0;
					}
					else if (input[j+3] > 1)
					{
						input[j+3] = 1;
					}
					for(k=0;k<Data.EDGE_NUM;k++)
					{
						input[j+4+k*2] = int(input[j+4+k*2]); input[j+4+k*2+1] = int(input[j+4+k*2+1]);
						if (input[j+4+k*2] < 0)
						{
							input[j+4+k*2] = 0;
						}
						else if (input[j+4+k*2] >= Data.WIDTH)
						{
							input[j+4+k*2] = Data.WIDTH - 1;
						}
						if (input[j+4+k*2+1] < 0)
						{
							input[j+4+k*2+1] = 0;
						}
						else if (input[j+4+k*2+1] >= Data.HEIGHT)
						{
							input[j+4+k*2+1] = Data.HEIGHT;
						}
					}
				}
			}
			else
			{
				input = [Data.EDGE_NUM, Data.GENOME_SIZE];
				for (i=0;i<Data.GENOME_SIZE;i++)
				{
					input.push(Math.floor(Math.random()*256), Math.floor(Math.random()*256),
							   Math.floor(Math.random()*256), 0);
					for (j=0;j<Data.EDGE_NUM;j++)
					{
						input.push(Math.floor(Math.random()*Data.WIDTH), Math.floor(Math.random()*Data.HEIGHT));
					}
				}
			}
			
			for (i=0,j=2;i<Data.GENOME_SIZE;i++,j+=4+Data.EDGE_NUM*2)
			{
				var _x:Array = [];
				var _y:Array = [];
				for(k=0;k<Data.EDGE_NUM;k++)
				{
					_x.push(input[j+4+k*2]);
					_y.push(input[j+4+k*2+1]);
				}
				nowGraph.genome.push(new Polygon(_x, _y, input[j], input[j+1], input[j+2], input[j+3]));
				bestGraph.genome.push(nowGraph.genome[i].clone());
			}
			bestGraph.calcFitness();
		}
		
		private function printGene():void
		{
			var i, j:int;
			var str:Array = [];
			str.push(Data.EDGE_NUM, Data.GENOME_SIZE);
			for (i=0;i<Data.GENOME_SIZE;i++)
			{
				str.push(bestGraph.genome[i].red, bestGraph.genome[i].green, bestGraph.genome[i].blue, bestGraph.genome[i].alpha);
				for (j=0;j<Data.EDGE_NUM;j++)
				{
					str.push(bestGraph.genome[i].x[j], bestGraph.genome[i].y[j]);
				}
			}
			bestText.text = str.join(" ");
		}
		
		private function initStage():void
		{
			Data.avatar = new Avatar();
			originalBmp.bitmapData = Data.avatar;
			
			originalBmp.x = (Data.STAGE_WIDTH/3 - Data.WIDTH)/2;
			originalBmp.y = 30;
			bestGraph.x = originalBmp.x + Data.STAGE_WIDTH/3;
			bestGraph.y = 30;
			nowGraph.x = bestGraph.x + Data.STAGE_WIDTH/3;
			nowGraph.y = 30;
			
			addChild(originalBmp);
			addChild(bestGraph);
			addChild(nowGraph);
			
			dashboard.x = 240;
			dashboard.y = 377;
			addChild(dashboard);
			
			meter.x = 480;
			meter.y = dashboard.y - meter.height;
			addChild(meter);
			
			textFormat.size = 14;
			textFormat.align = "center";
			ctrlBtn.setStyle("textFormat", textFormat);
			picComboBox.textField.setStyle("textFormat", textFormat);
			picComboBox.setStyle("textFormat", textFormat);
			picComboBox.dropdown.setRendererStyle("textFormat", textFormat);
			picComboBox.setStyle("disabledTextFormat", textFormat);
			gaussianRadio.setStyle("textFormat", textFormat);
			gaussianRadio.setStyle("disabledTextFormat", textFormat);
			normalRadio.setStyle("textFormat", textFormat);
			normalRadio.setStyle("disabledTextFormat", textFormat);
			
			picComboBox.addEventListener(Event.CHANGE, onPicChange);
			numSlider.maximum = Data.MAX_GENOME;
			numSlider.minimum = Data.MIN_GENOME;
			numSlider.addEventListener(SliderEvent.CHANGE, onNumSliderChange);
			edgeSlider.maximum = Data.MAX_EDGE;
			edgeSlider.maximum = Data.MIN_EDGE;
			edgeSlider.addEventListener(SliderEvent.CHANGE, onEdgeSliderChange);
			numText.restrict = "0-9";
			numText.addEventListener(FocusEvent.FOCUS_OUT, onNumTextChange);
			edgeText.restrict = "0-9";
			edgeText.addEventListener(FocusEvent.FOCUS_OUT, onEdgeTextChange);
			
			ctrlBtn.addEventListener(MouseEvent.CLICK, onCtrlClick);
		}
		
		private function changeBeginStage():void
		{
			Data.GENOME_SIZE = numSlider.value;
			Data.EDGE_NUM = edgeSlider.value;
			if (gaussianRadio.selected)
			{
				Data.RAND_STYLE = 0;
			}
			else
			{
				Data.RAND_STYLE = 1;
			}
			
			picComboBox.enabled = false;
			numSlider.enabled = false;
			edgeSlider.enabled = false;
			numText.selectable = false;
			edgeText.selectable = false;
			gaussianRadio.enabled = false;
			normalRadio.enabled = false;
			ctrlBtn.label = "停止";
			meter.initStats();
			
			picComboBox.removeEventListener(Event.CHANGE, onPicChange);
			numSlider.removeEventListener(SliderEvent.CHANGE, onNumSliderChange);
			edgeSlider.removeEventListener(SliderEvent.CHANGE, onEdgeSliderChange);
			numText.removeEventListener(FocusEvent.FOCUS_OUT, onNumTextChange);
			edgeText.removeEventListener(FocusEvent.FOCUS_OUT, onEdgeTextChange);
			
			startTime = lastTime = getTimer();
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function changeStopStage():void
		{
			picComboBox.enabled = true;
			numSlider.enabled = true;
			edgeSlider.enabled = true;
			numText.selectable = true;
			edgeText.selectable = true;
			gaussianRadio.enabled = true;
			normalRadio.enabled = true;
			ctrlBtn.label = "开始";
			
			printGene();
			
			picComboBox.addEventListener(Event.CHANGE, onPicChange);
			numSlider.addEventListener(SliderEvent.CHANGE, onNumSliderChange);
			edgeSlider.addEventListener(SliderEvent.CHANGE, onEdgeSliderChange);
			numText.addEventListener(FocusEvent.FOCUS_OUT, onNumTextChange);
			edgeText.addEventListener(FocusEvent.FOCUS_OUT, onEdgeTextChange);
			
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer.stop();
		}
		
		private function changeStats():void
		{
			var nowTime:int;
			
			dashboard.drawPoint(generation, (1-bestGraph.unfitness/(Data.WIDTH*Data.HEIGHT*255*3))*100);
			genText.text = "突变数："+generation.toString();
			nowTime = getTimer();
			if (generation%50 == 0)
			{
				spdText.text = "速度："+(50000/(nowTime-lastTime)).toFixed(1)+"/s";
				lastTime = nowTime;
			}
			nowTime -= startTime;
			if (nowTime < 60000)
			{
				timeText.text = "时间："+Math.floor(((nowTime)/1000)).toString()+"s";
			}
			else if(nowTime < 3600000)
			{
				timeText.text = "时间："+Math.floor(((nowTime)/60000)).toString()+"m"+Math.floor(((nowTime)%60000/1000)).toString()+"s";
			}
			else
			{
				timeText.text = "时间："+Math.floor(((nowTime)/3600000)).toString()+"h"+Math.floor(((nowTime)%3600000/60000)).toString()+"m"+Math.floor(((nowTime)%60000/1000)).toString()+"s";
			}
		}
		
		private function onTimer(e:TimerEvent):void
		{
			var changeArr:Array;
			
			generation++;
			changeArr = Data.RAND_STYLE ? nowGraph.changeGenome() : nowGraph.changeGenomeGaussian();
			nowGraph.calcFitness();
			meter.addVal((nowGraph.unfitness-bestGraph.unfitness)/(Data.WIDTH*Data.HEIGHT*255*3)*100);
			if (nowGraph.unfitness < bestGraph.unfitness)
			{
				bestGraph.genome[changeArr[0]] = changeArr[1].clone();
				bestGraph.unfitness = nowGraph.unfitness;
				bestGraph.bmp.bitmapData = nowGraph.bmp.bitmapData.clone();
				bestGraph.drawFitness();
			}
			else
			{
				nowGraph.undoChange();
			}
			
			changeStats();
		}
		
		private function onPicChange(e:Event):void
		{
			Data.avatar = new (getDefinitionByName(picComboBox.value) as Class)();
			originalBmp.bitmapData = Data.avatar;
		}
		
		private function onNumSliderChange(e:SliderEvent):void
		{
			numText.text = e.value.toString();
			Data.GENOME_SIZE = e.value;
		}
		
		private function onEdgeSliderChange(e:SliderEvent):void
		{
			edgeText.text = e.value.toString();
			Data.EDGE_NUM = e.value;
		}
		
		private function onNumTextChange(e:FocusEvent):void
		{
			if (int(numText.text) < Data.MIN_GENOME)
			{
				numText.text = Data.MIN_GENOME.toString();
			}
			else if (int(numText.text) > Data.MAX_GENOME)
			{
				numText.text = Data.MAX_GENOME.toString();
			}
			numSlider.value = Data.GENOME_SIZE = int(numText.text);
		}
		
		private function onEdgeTextChange(e:FocusEvent):void
		{
			if (int(edgeText.text) < Data.MIN_EDGE)
			{
				edgeText.text = Data.MIN_EDGE.toString();
			}
			else if(int(edgeText.text) > Data.MAX_EDGE)
			{
				edgeText.text = Data.MAX_EDGE.toString();
			}
			edgeSlider.value = Data.EDGE_NUM = int(edgeText.text);
		}
		
		private function onCtrlClick(e:MouseEvent):void
		{
			if (ctrlBtn.label == "开始")
			{
				generation = 0;
				changeBeginStage();
				initGenome();
			}
			else
			{
				changeStopStage();
			}
		}
	}
	
}
