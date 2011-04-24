package com.h4ostudio.tilemaps
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.resource.ResourceManager;
	import com.pblabs.engine.resource.XMLResource;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.debug.Logger;
	
	import flash.utils.Dictionary;
	
	public class TilemapComponent extends EntityComponent
	{
		private var _tilemapUrl:String;
		private var _tileResource:XMLResource;
		private var _tileInfos:Dictionary;
		private var _layers:Vector.<TilemapLayer>;
		
		public function get tilemapUrl():String
		{
			return _tilemapUrl;
		}
		
		public function set tilemapUrl(s:String):void
		{
			_tilemapUrl=s;
			PBE.resourceManager.load(s,XMLResource,onMapLoaded,onMapFailed);
		}
		
		public function get tileInfos():Dictionary
		{
			return _tileInfos;
		}
		
		public function getLayer(index:int):TilemapLayer
		{
			if(index<_layers.length)
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
			Logger.print(this,r.XMLData.@version);
		}
		
		private function onMapFailed(r:XMLResource):void
		{
			Logger.error(this,"onMapFailed","Couldn't load map " + _tilemapUrl);
		}
	}
}
