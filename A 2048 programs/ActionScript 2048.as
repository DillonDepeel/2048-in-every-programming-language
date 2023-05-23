package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;


	public class Main2048 extends MovieClip
	{
		private var myMask:stageMask=new stageMask();
		private var startBtn:startButton=new startButton();
		private var overBtn:overSign=new overSign();
		private var restartBtn:restartButton=new restartButton();
		private var twinkle1:picTwinkle=new picTwinkle();
		private var frameArr:Array=[];
		private var emptyArr:Array = [];
		private var score:uint=0;
		private var highScore:uint=0;
		private var scoreText:TextField = new TextField();
		private var highScoreText:TextField = new TextField();
		private var canRefresh:Boolean = false;
		private var format1:TextFormat=new TextFormat();

		public function Main2048()
		{
			setArrays();
			addPics();
			ready();
		}
		
		public function setArrays():void
		{
			frameArr=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
			emptyArr=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
		}

		//添加16个pics，每一个都stop在第一帧。
		public function addPics():void
		{
			for (var i:int=0; i<=3; i++)
			{
				for (var j:int=0; j<=3; j++)
				{
					var thisPic:pics=new pics();
					this.addChild(thisPic);
					thisPic.stop();
					thisPic.x = j * 100 + 50;
					thisPic.y = i * 100 + 100;
					//trace("add successful.");
				}
			}
			format1.bold=true;
			format1.color=0xFF0000;
			format1.size=20;
			
			this.addChild(scoreText);
			scoreText.x=50;
			scoreText.y=40;
			scoreText.autoSize="left";
			scoreText.setTextFormat(format1);
			
			this.addChild(highScoreText);
			highScoreText.x=250;
			highScoreText.y=40;
			highScoreText.autoSize="left";
			highScoreText.setTextFormat(format1);
		}

		//准备阶段
		public function ready():void
		{
			this.addChild(myMask);
			this.addChild(startBtn);
			//trace("add over");
			startBtn.addEventListener(MouseEvent.CLICK,getStart);
		}

		//开始游戏，清除mask和startBtn,随机产生2个数字
		public function getStart(evt:MouseEvent):void
		{
			startBtn.removeEventListener(MouseEvent.CLICK,getStart);
			this.removeChild(myMask);
			this.removeChild(startBtn);
			product();
			product();
			stage.addEventListener(KeyboardEvent.KEY_UP,makeMove);
		}

		//选择上下左右
		public function makeMove(e:KeyboardEvent):void
		{
			//trace("there is makeMove")
			var i:int;
			var j:int;
			var tempArr:Array = [];
			canRefresh = false;
			switch (e.keyCode)
			{
				case 37:
					{
						//trace("keyCode 37");
						trace(frameArr);
						for(i=0;i<=12;i+=4)
						{
							tempArr=[];
							for(j=0;j<=3;j++)
							{
								tempArr.push(i+j);
							}
							moveIt(tempArr);
							combineIt(tempArr);
							moveIt(tempArr);
						}
						if (canRefresh == false && emptyArr.length == 0)
						{
							gameOver();
						}
						else if (canRefresh == true)
						{
							Refresh();
							product();
							trace(frameArr);
							
						}
						break;
					}
					

				case 38 :
					{
						for(i=0;i<=3;i++)
						{
							tempArr=[];
							for(j=0;j<=12;j+=4)
							{
								tempArr.push(i+j);
							}
							moveIt(tempArr);
							combineIt(tempArr);
							moveIt(tempArr);
						}
						if (canRefresh == false && emptyArr.length == 0)
						{
							gameOver();
						}
						else if (canRefresh == true)
						{
							Refresh();
							product();
							trace(frameArr);
							
						}
						break;
					}
					

				case 39 :
					{
						for(i=0;i<=12;i+=4)
						{
							tempArr=[];
							for(j=3;j>=0;j--)
							{
								tempArr.push(i+j);
							}
							moveIt(tempArr);
							combineIt(tempArr);
							moveIt(tempArr);
						}
						if (canRefresh == false && emptyArr.length == 0)
						{
							gameOver();
						}
						else if (canRefresh == true)
						{
							Refresh();
							product();
							trace(frameArr);
							
						}
						break;
					}
					

				case 40 :
					{
						for(i=0;i<=3;i++)
						{
							tempArr=[];
							for(j=12;j>=0;j-=4)
							{
								tempArr.push(i+j);
							}
							moveIt(tempArr);
							combineIt(tempArr);
							moveIt(tempArr);
						}
						if (canRefresh == false && emptyArr.length == 0)
						{
							gameOver();
						}
						else if (canRefresh == true)
						{
							Refresh();
							product();
							trace(frameArr);
							
						}
						break;
					}
					
			}
			
		}
		
		//上下左右移动
		public function moveIt(arr:Array):void
		{
			//var tempArray:Array=new Array();
//			tempArray=arr;
			
			for(var i:int=2;i>=0;i--)
			{
				for(var j:int=0;j<=i;j++)
				{
					if(frameArr[arr[j]]==1&&frameArr[arr[j+1]]!=1)
					{
						//var x:int;
//						var y:int;
//						x=arr[j];
//						y=arr[j+1];
//						frameArr[x]=frameArr[y];
//						frameArr[y]=1;
						frameArr[arr[j]]=frameArr[arr[j+1]];
						frameArr[arr[j + 1]] = 1;
						canRefresh = true;
					}
				}
			}
		}
		
		//相同的合并
		public function combineIt(arr:Array):void
		{
			for(var j:int=0;j<=2;j++)
			{
				if(frameArr[arr[j]]==1)
				continue;
				else if(frameArr[arr[j]]==frameArr[arr[j+1]])
				{
					score+=Math.pow(2,frameArr[arr[j]]);
					if(score>highScore)
					{
						highScore=score;
					}
					trace("arr[j]="+frameArr[arr[j]]);
					frameArr[arr[j]]+=1;
					frameArr[arr[j + 1]] = 1;
					canRefresh = true;
				}
			}
		}
		

		//图片刷新
		public function Refresh():void
		{
			emptyArr=[];
			for (var i:int=0; i<=15; i++)
			{
				(this.getChildAt(i + 1) as MovieClip).gotoAndStop(frameArr[i]);
				if(frameArr[i]==1)
				{
					emptyArr.push(i);
				}
			}
			scoreText.text="当前分数："+score.toString();
			scoreText.setTextFormat(format1);
			highScoreText.text="最高分："+highScore.toString();
			highScoreText.setTextFormat(format1);
		}

		//随机产生一个“2”或者“4”;
		public function product():void
		{
			if(emptyArr.length==0)
			{
				gameOver();
			}
			else
			{
				var i:int = Math.floor(Math.random() * emptyArr.length);
				var picNum = emptyArr[i];
				var frameNum:int = Math.ceil(Math.random() * 2) + 1;

				//(this.getChildAt(picNum) as MovieClip).gotoAndStop(frameNum);

				frameArr[picNum] = frameNum;
				emptyArr.splice(i,1);
				
				
				this.addChild(twinkle1);
				twinkle1.x=this.getChildAt(picNum + 1).x;
				twinkle1.y=this.getChildAt(picNum + 1).y;
				
				Refresh();
				/*
				(this.getChildAt(i + 1) as MovieClip).gotoAndPlay(15);*/
			}

			var len:int = emptyArr.length;
			trace(len,i,picNum,frameNum);

			/*(this.getChildAt(3)as MovieClip).gotoAndStop(4);*/
		}
		
		//Game Over
		public function gameOver():void
		{
			this.addChild(myMask);
			this.addChild(overBtn);
			this.addChild(restartBtn);
			restartBtn.addEventListener(MouseEvent.CLICK,restart);
		}
		
		//游戏重新开始
		public function restart(evt:MouseEvent):void
		{
			startBtn.removeEventListener(MouseEvent.CLICK,restart);
			this.removeChild(myMask);
			this.removeChild(overBtn);
			this.removeChild(restartBtn);
			setArrays();
			score=0;
			product();
			product();
			stage.addEventListener(KeyboardEvent.KEY_UP,makeMove);
		}
	}

}
