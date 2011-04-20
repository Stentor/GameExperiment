package com.h4ostudio.components
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.rendering2D.IMobileSpatialObject2D;
	import com.pblabs.rendering2D.IScene2D;
	import com.pblabs.engine.core.InputMap;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.PBUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ShipControllerComponent extends TickedComponent
	{
		public var movementRate:Point;
		
		public var scene:IScene2D;
		public var spatial:IMobileSpatialObject2D;
		
		private var _inputMap:InputMap;
		private var _left:Number=0;
		private var _right:Number=0;
		private var _up:Number=0;
		private var _down:Number=0;
		
		public function get input():InputMap
		{
			return _inputMap;
        }
    
		public function set input(value:InputMap):void
		{
			_inputMap = value;
       
			if (_inputMap != null)
			{
				_inputMap.mapActionToHandler("GoLeft", onLeft);
				_inputMap.mapActionToHandler("GoRight", onRight);
				_inputMap.mapActionToHandler("GoUp", onUp);
				_inputMap.mapActionToHandler("GoDown", onDown);
			}
		}
		public override function onTick(tickRate:Number):void
		{
			var directionX:Number = _right - _left;
			var directionY:Number = _down - _up;
			if(spatial)
			{
				var pos:Point=spatial.position;
				var extents:Rectangle=spatial.worldExtents;
				var world:Rectangle=scene.trackLimitRectangle;
				
				if(directionX!=0 || directionY!=0)
					spatial.rotation=90+PBUtil.getDegreesFromRadians(Math.atan2(directionY,directionX));
			
				pos.x+=movementRate.x*directionX*tickRate;
				pos.y+=movementRate.y*directionY*tickRate;
								
				pos.x=PBUtil.clamp(pos.x,world.left+extents.width/2,world.right-extents.width/2);
				pos.y=PBUtil.clamp(pos.y,world.top+extents.height/2,world.bottom-extents.height/2);
				
				
				spatial.position=pos;
			}
			else
				Logger.print(this,"no spatial");
		}
		
		private function onLeft(value:Number):void
		{
			_left=value;
		}
		private function onRight(value:Number):void
		{
			_right=value;
		}
		private function onUp(value:Number):void
		{
			_up=value;
		}
		private function onDown(value:Number):void
		{
			_down=value;
		}
		
	}
}
