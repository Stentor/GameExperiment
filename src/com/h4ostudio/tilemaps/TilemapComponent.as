package com.h4ostudio.tilemaps
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.sprintf;
	import com.pblabs.engine.resource.ResourceManager;
	import com.pblabs.engine.resource.XMLResource;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import com.pblabs.rendering2D.spritesheet.FixedSizeDivider;
	import com.pblabs.rendering2D.IScene2D;
	
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import flash.geom.Rectangle;
	
	public class TilemapComponent extends EntityComponent
	{
		private var _tilemapUrl:String;
		private var _tileResource:XMLResource;
		private var _tileInfos:Array=new Array();
		private var _layers:Array=new Array();
		private var _sheets:Dictionary=new Dictionary();
		
		public var scene:IScene2D;
		
		public function get tilemapUrl():String
		{
			return _tilemapUrl;
		}
		
		public function set tilemapUrl(s:String):void
		{
			_tilemapUrl=s;
			PBE.resourceManager.load(s,XMLResource,onMapLoaded,onMapFailed);
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
			if (scene)
			{
				scene.trackLimitRectangle=new Rectangle(0,0,
							r.XMLData.@width*r.XMLData.@tilewidth,
							r.XMLData.@height*r.XMLData.@tileheight);
			}
			for each (var t:XML in r.XMLData.tileset)
			{
				var sheet:SpriteSheetComponent=new SpriteSheetComponent();
				sheet.imageFilename=t.image.@source;
				var divider:FixedSizeDivider=new FixedSizeDivider();
				divider.height=t.@tileheight;
				divider.width=t.@tilewidth;
				sheet.divider=divider;
				owner.addComponent(sheet,t.@name);
				_sheets[t.@firstgid]=sheet;				
			}
			for each (var l:XML in r.XMLData.layer)
			{
				if (l.@visible!=0)
				{
					Logger.print(this,sprintf("Adding Layer %s",l.@name));
					var layer:TilemapLayer=new TilemapLayer(r.XMLData.@tilewidth,r.XMLData.@tilewidth,
									l.@width,l.@height,l.data[0],l.data.@encoding);
					_layers.push(layer);
				}
				else
				{
					Logger.print(this,sprintf("Layer %s is not visible, skipping",l.@name));
				}
			}
			setTimeout(checkLoaded,100);
		}
		
		private function checkLoaded():void
		{
			for (var s:* in _sheets)
			{
				Logger.print(this,sprintf("GID: %d -> Loaded %d frames from %s",
							s,_sheets[s].frameCount,_sheets[s].imageFilename));
			}
		}
		
		private function onMapFailed(r:XMLResource):void
		{
			Logger.error(this,"onMapFailed","Couldn't load map " + _tilemapUrl);
		}
	}
}
