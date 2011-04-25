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
	
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	public class TilemapComponent extends EntityComponent
	{
		private var _tilemapUrl:String;
		private var _tileResource:XMLResource;
		private var _tileInfos:Array=new Array();
		private var _layers:Array=new Array();
		private var _sheets:Dictionary=new Dictionary();
		
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
			setTimeout(checkLoaded,100);
		}
		private function checkLoaded():void
		{
			for (var s:* in _sheets)
			{
				Logger.print(this,sprintf("GID: %s -> Loaded %d frames from %s",
							s,_sheets[s].frameCount,_sheets[s].imageFilename));
			}
		}
		private function onMapFailed(r:XMLResource):void
		{
			Logger.error(this,"onMapFailed","Couldn't load map " + _tilemapUrl);
		}
	}
}
