package com.h4ostudio.components
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.engine.core.InputMap;
	import com.pblabs.engine.debug.Logger;
	
	import flash.geom.Point;
	
	public class ShipControllerComponent extends TickedComponent
	{
		public var positionReference:PropertyReference;
		public var movementRate:Point;
		
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
			
			var pos:Point=owner.getProperty(positionReference) as Point;
			
			pos.x+=movementRate.x*directionX*tickRate;
			pos.y+=movementRate.y*directionY*tickRate;
			
			owner.setProperty(positionReference,pos);
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
