package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.setTimeout;


	public class CustomPreloader extends Sprite
	{
		private var _mc:H4oPreloader;
		private var _stopFrame:int=20;
		
		
		public function CustomPreloader()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_mc=new H4oPreloader();
			trace(_mc.totalFrames);
			_mc.x=400;
			_mc.y=300;
			addChild(_mc);
			_mc.stop();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void
		{
			var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
			if (_mc.currentFrame<_stopFrame)
			{
				_mc.nextFrame();
				return;
			}
			var frameToGo:int=Math.round((_mc.totalFrames-_stopFrame)*percent);
			if (_mc.currentFrame<frameToGo+_stopFrame)
				_mc.nextFrame();
			
			if (_mc.currentFrame==_mc.totalFrames)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				init();
			}
			
		}

		private function init():void
		{
			removeChild(_mc);
			var mainClass:GameExperiment=new GameExperiment();
			addChild(mainClass);			
		}
	}
}

