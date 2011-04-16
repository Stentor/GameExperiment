package
{
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.animation.FrameAnimator;
    import com.pblabs.engine.PBE;
    import com.pblabs.engine.core.LevelManager;
    import com.pblabs.engine.resource.Resource;
    import com.pblabs.rendering2D.BasicSpatialManager2D;
    import com.pblabs.rendering2D.DisplayObjectScene;
    import com.pblabs.rendering2D.BitmapDataScene;
    import com.pblabs.rendering2D.SimpleSpatialComponent;
    import com.pblabs.rendering2D.SpriteSheetRenderer;
    import com.pblabs.rendering2D.spritesheet.CellCountDivider;
    import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
    import com.pblabs.rendering2D.ui.SceneView;
    
    import com.pblabs.engine.debug.UIAppender;
    
	import flash.display.Sprite;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0x000000")]
	public class GameExperiment extends Sprite
	{
		public function GameExperiment()
		{
			// Make sure all the types our XML will use are registered.
            PBE.registerType(com.pblabs.rendering2D.DisplayObjectScene);
            PBE.registerType(com.pblabs.rendering2D.BitmapDataScene);
            PBE.registerType(com.pblabs.rendering2D.SpriteSheetRenderer);
            PBE.registerType(com.pblabs.rendering2D.spritesheet.SpriteSheetComponent);
            PBE.registerType(com.pblabs.rendering2D.SimpleSpatialComponent);
            PBE.registerType(com.pblabs.rendering2D.BasicSpatialManager2D);
            PBE.registerType(com.pblabs.rendering2D.spritesheet.CellCountDivider);
            PBE.registerType(com.pblabs.rendering2D.ui.SceneView);
            PBE.registerType(com.pblabs.animation.AnimatorComponent);
            PBE.registerType(com.pblabs.animation.FrameAnimator);
        
            // Initialize the engine!
            PBE.startup(this);
            
            // Load resources.
            PBE.addResources(new EmbedResource());

            // Set up the scene view.
            var sv:SceneView = new SceneView();
            sv.name = "MainView";
            sv.x = 0;
            sv.y = 0;
            sv.width = 800;
            sv.height = 600;
            addChild(sv);
						
            // Load the descriptions, and start up level 1.
            LevelManager.instance.load("../assets/xml/levelDescriptions.xml", 1);
		}
	}
}
