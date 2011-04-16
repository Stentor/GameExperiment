package 
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;


	public class CustomPreloader extends MovieClip
	{
		public function CustomPreloader()
		{
			stop();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void
		{
			graphics.clear();
			if(framesLoaded == totalFrames)
			{	
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				nextFrame();
				init();
			}
			else
			{
				var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
				graphics.beginFill(0xffffff);
				graphics.drawRect(0, stage.stageHeight / 2 - 10,
				stage.stageWidth * percent, 20);
				graphics.endFill();
			}
		}

		private function init():void
		{
			var mainClass:GameExperiment=new GameExperiment();
			addChild(mainClass);			
		}
	}
}

