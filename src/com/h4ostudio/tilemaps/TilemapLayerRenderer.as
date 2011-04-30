package com.h4ostudio.tilemaps
{
	import com.pblabs.rendering2D.BitmapRenderer;
	import com.pblabs.engine.debug.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TilemapLayerRenderer extends BitmapRenderer
	{
		private var _tiles:Array;
		private var _layer:TilemapLayer;
		private var frameCache:BitmapData;
		
		protected var _borkBitmap:BitmapData = new BitmapData(32, 32, true, 0x77FF00FF);
		
		public function set tileBank(value:Array):void
		{
			_tiles=value;
		}
		
		public function set tilemapLayer(value:TilemapLayer):void
		{
			_layer=value;
		}
		
		public function get tilemapLayer():TilemapLayer
		{
			return _layer;
		}
		
		public override function onFrame(elapsed:Number):void
		{
			if (!frameCache || 
				frameCache.width  != scene.sceneViewBounds.width ||
				frameCache.height != scene.sceneViewBounds.height)
			{
				frameCache = new BitmapData(scene.sceneViewBounds.width, scene.sceneViewBounds.height, true, 0x00000000);
			}
			
			bitmapData = frameCache;
			
			var copyPoint:Point = new Point();
			
			var screenPosition:Point = scene.sceneViewBounds.topLeft;
			
			super.onFrame(elapsed);
			position = screenPosition.clone();
			updateTransform();
			
			var startX:int = (screenPosition.x / _layer.tileSize.x) - 1;
			var startY:int = (screenPosition.y / _layer.tileSize.y) - 1;
			var endX:int   = ((screenPosition.x + scene.sceneView.width) / _layer.tileSize.x) + 3;
			var endY:int   = ((screenPosition.y + scene.sceneView.height) / _layer.tileSize.y) + 3;
			
			startX = Math.max(0, startX);
			startY = Math.max(0, startY);
			endX = Math.min(_layer.width,  endX);
			endY = Math.min(_layer.height, endY);
			
			// Only need this once.
			var tileRect:Rectangle = new Rectangle(0,0, _layer.tileSize.x, _layer.tileSize.y);
			
			// Clear the bitmap!
			frameCache.lock();
			frameCache.fillRect(frameCache.rect, 0x00000000);
			
			// Now, draw all our tiles.
			for(var curX:int = startX; curX<endX; curX++)
			{
				for(var curY:int = startY; curY<endY; curY++)
				{
					var tileType:int = _layer.getTile(curX, curY);
										
					// Get position of the tile.
					copyPoint.x = curX * _layer.tileSize.x;
					copyPoint.y = curY * _layer.tileSize.y;
					
					// Transform to screen space...
					var p:Point = scene.transformWorldToScene(copyPoint);
					
					// And offset it to be relative to our bit_layer.
					copyPoint.x = p.x - _position.x;
					copyPoint.y = p.y - _position.y;
					
					if (_tiles[tileType])
						frameCache.copyPixels(_tiles[tileType], tileRect, copyPoint);
				}
			}
			
			frameCache.unlock();
			position=scene.transformScreenToScene(new Point(0,0));
					
		}
	}
}
