package 
{
	import com.pblabs.engine.resource.*;
	
	public class EmbedResource extends ResourceBundle
	{
	
		[Embed(source="../assets/xml/levelDescriptions.xml",mimeType="application/octet-stream")]
		public var __ASSETS_XML_LEVELDESCRIPTIONS_XML:Class;		
			
		[Embed(source="../assets/xml/levels/level1.pbelevel",mimeType="application/octet-stream")]
		public var __ASSETS_XML_LEVELS_LEVEL1_PBELEVEL:Class;		
			
		[Embed(source="../assets/img/Ship.png")]
		public var __ASSETS_IMG_SHIP_PNG:Class;		
			
	}
}
