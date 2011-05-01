package 
{
	import com.pblabs.engine.resource.*;
	
	public class EmbedResource extends ResourceBundle
	{
	
		[Embed(source="../assets/img/map_helper.png")]
		public var __ASSETS_IMG_MAP_HELPER_PNG:Class;		
			
		[Embed(source="../assets/img/Ship.png")]
		public var __ASSETS_IMG_SHIP_PNG:Class;		
			
		[Embed(source="../assets/img/tileset.png")]
		public var __ASSETS_IMG_TILESET_PNG:Class;		
			
		[Embed(source="../assets/xml/levelDescriptions.xml",mimeType="application/octet-stream")]
		public var __ASSETS_XML_LEVELDESCRIPTIONS_XML:Class;		
			
		[Embed(source="../assets/xml/levels/level1.pbelevel",mimeType="application/octet-stream")]
		public var __ASSETS_XML_LEVELS_LEVEL1_PBELEVEL:Class;		
			
		[Embed(source="../assets/maps/test.tmx",mimeType="application/octet-stream")]
		public var __ASSETS_MAPS_TEST_TMX:Class;		
			
		[Embed(source="../assets/music/track1.mp3")]
		public var __ASSETS_MUSIC_TRACK1_MP3:Class;		
			
	}
}
