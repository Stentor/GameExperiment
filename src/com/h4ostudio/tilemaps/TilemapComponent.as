package com.h4ostudio.tilemaps
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.sprintf;
	import com.pblabs.engine.resource.ResourceManager;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.XMLResource;
	import com.pblabs.engine.resource.Resource;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import com.pblabs.rendering2D.spritesheet.FixedSizeDivider;
	import com.pblabs.rendering2D.IScene2D;
	
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class TilemapComponent extends EntityComponent
	{
		private var _tilemapUrl:String;
		private var _tileResource:XMLResource;
		private var _tileInfos:Array=new Array();
		private var _layers:Array=new Array();
		private var _sheets:Object=new Object();
		private var _tiles:Array=new Array();
		private var _tileSize:Point;
		
		public var scene:IScene2D;
		public var lockScene:Boolean=false;
		
		public function get tilemapUrl():String
		{
			return _tilemapUrl;
		}
		
		public function set tilemapUrl(s:String):void
		{
			_tilemapUrl=s;
			PBE.resourceManager.load(s,XMLResource,onMapLoaded,onError);
		}
		
		public function getTileInfo(index:int):TileProperty
		{
			if (_tileInfos[index])
				return _tileInfos[index];
			return null;
		}
		
		public function getLayer(index:int):TilemapLayer
		{
			if(_layers[index])
				return _layers[index];
			return null;
		}
		
		public function numLayers():int
		{
			return _layers.length;
		}
		
		private function onMapLoaded(r:XMLResource):void
		{
			_tileResource=r;
			_tileSize=new Point(r.XMLData.@tilewidth,r.XMLData.@tileheight);
			
			if (scene && lockScene)
			{
				scene.trackLimitRectangle=new Rectangle(0,0,
							r.XMLData.@width*r.XMLData.@tilewidth,
							r.XMLData.@height*r.XMLData.@tileheight);
			}
			for each (var t:XML in r.XMLData.tileset)
			{
				_sheets[t.image.@source]=t.@firstgid;
				PBE.resourceManager.load(t.image.@source,ImageResource,onTilesetLoaded,onError);	
			}
			for each (var l:XML in r.XMLData.layer)
			{
				if (l.@visible!=0)
				{
					Logger.print(this,sprintf("Adding Layer %s",l.@name));
					var layer:TilemapLayer=new TilemapLayer(r.XMLData.@tilewidth,r.XMLData.@tilewidth,
									l.@width,l.@height,l.data[0],l.data.@encoding);
					_layers.push(layer);
					var render:TilemapLayerRenderer=new TilemapLayerRenderer();
					render.tileBank=_tiles;
					render.tilemapLayer=layer;
					if (l.@opacity>0)
						render.alpha=l.@opacity;
					render.layerIndex=l..property.(@name=="layerIndex").@value;
					if (l..property.(@name=="parallaxFactorX").@value>0)
						render.parallaxFactorX=l..property.(@name=="parallaxFactorX").@value;
					if (l..property.(@name=="parallaxFactorY").@value>0)
						render.parallaxFactorY=l..property.(@name=="parallaxFactorY").@value;
					render.scene=scene;
					owner.addComponent(render,sprintf("Render%s",l.@name));
				}
				else
				{
					Logger.print(this,sprintf("Layer %s is not visible, skipping",l.@name));
				}
			}
		}
		
		private function onTilesetLoaded(r:ImageResource):void
		{
			var gid:int=_sheets[r.filename];
			split(r.image.bitmapData,_tileSize,gid);
		}
		
		private function split(img:BitmapData,tileSize:Point,gid:int):void
		{
			var count:int=0;
			for (var y:int=0;y<Math.floor(img.height/tileSize.y);y++)
			{
				for (var x:int=0;x<Math.floor(img.width/tileSize.x);x++)
				{
					var tmp:BitmapData=new BitmapData(tileSize.x,tileSize.y);
					var destRect:Rectangle=new Rectangle(x*tileSize.x,y*tileSize.y,tileSize.x,tileSize.y);
					tmp.copyPixels(img,destRect,new Point(0,0));
					_tiles[Math.floor(img.width/tileSize.x)*y+x+gid]=tmp;
					count++;
				}
			}
			Logger.print(this,sprintf("Gid : %d has %d tiles",gid,count));
		}
		
		private function onError(r:Resource):void
		{
			Logger.error(this,"onError",sprintf("Couldn't load %s !!",r.filename));
		}
	}
}
