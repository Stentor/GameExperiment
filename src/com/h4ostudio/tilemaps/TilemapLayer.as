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
		private var _tiles:Array;
		
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
				for (var x:int=0;x<row.length;x++)
				{
					if (row[x])
						_data[x][y]=int(row[x]);
				}
			}
		}
		public function get tileSize():Point
		{
			return new Point(_tilewidth,_tileheight);
		}
		public function get width():int
		{
			return _width;
		}
		public function get height():int
		{
			return _height;
		}
		public function getTile(x:int,y:int):int
		{
			if (_data[x][y])
				return _data[x][y];
			else 
				return 0;
		}
	}
}
