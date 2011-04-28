package com.h4ostudio.tilemaps
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.rendering2D.IScene2D;

	import flash.geom.Rectangle;
	import flash.geom.Point;
		
	public class TilemapLayer
	{
		private var _data:Array;
		private var _encoding:String;
		private var _tilewidth:int;
		private var _tileheight:int;
		private var _width:int;
		private var _height:int;
		
		public function TilemapLayer(tilewidth:int,tileheight:int,width:int,height:int,data:XML,encoding:String):void
		{
			_tilewidth=tilewidth;
			_tileheight=tileheight;
			_width=width;
			_height=height;
			
			_data=new Array(width);
			_encoding=encoding;
			for (var a:int=0;a<width;a++)
			{
				_data[a]=new Array(height);
			}
			decode(data);
		}
		
		private function decode(data:XML):void
		{
			switch(_encoding)
			{
				case "csv":
				{
					decodeCSV(data);
					break;
				}
				case "base64":
				{
					throw new Error("Not implemented");
					break;
				}
				default:
				{
					throw new Error("WTF???");
				}
			}
		}
		
		private function decodeCSV(data:XML):void
		{
			var d:Array=data.toString().split('\n');
			for (var y:int=0;y<d.length;y++)
			{
				var row:Array=d[y].split(',');
				for (var x:int=0;x<row.length-1;x++)
				{
					_data[x][y]=int(row[x]);
				}
			}
		}
		
		public function queryVisibleTiles(scene:IScene2D):Array
		{
			var pos:Point=scene.sceneViewBounds.topLeft;
			var result:Array=new Array();
			var resultX:int=0;						
			var resultY:int=0;						
			for (var y:int=Math.floor(pos.y/_tileheight);y<Math.floor((pos.y+scene.sceneViewBounds.height)/_tileheight)+1;y++)
			{
				for (var x:int=Math.floor(pos.x/_tilewidth);x<Math.floor((pos.x+scene.sceneViewBounds.width)/_tilewidth)+1;x++)
				{
					if (_data[x][y])
						result[resultX][resultY]=_data[x][y];
					resultX++;
				}
				resultY++;
			}
			return result;
		}
	}
}
