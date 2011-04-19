package com.h4ostudio.components
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.rendering2D.IMobileSpatialObject2D;
	import com.pblabs.rendering2D.IScene2D;
	import com.pblabs.engine.core.InputMap;
	import com.pblabs.engine.debug.Logger;
	
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
			
				pos.x+=movementRate.x*directionX*tickRate;
				pos.y+=movementRate.y*directionY*tickRate;
								
				
				if (extents.right>world.right)
						pos.x+=world.right-extents.right;
				if (extents.left<world.left)
						pos.x+=world.left-extents.left;
				if (extents.top<world.top)
						pos.y+=world.top-extents.top;
				if (extents.bottom>world.bottom)
						pos.y+=world.bottom-extents.bottom;
				
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
