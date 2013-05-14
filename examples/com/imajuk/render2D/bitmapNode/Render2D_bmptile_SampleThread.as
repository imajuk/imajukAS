package com.imajuk.render2D.bitmapNode
{
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.Render2DWorld;
    import com.imajuk.service.AssetLocation;
    import com.imajuk.service.IAssetLocation;
    import com.imajuk.service.PreLoader;
    import com.imajuk.service.PreLoaderThread;

    import org.libspark.thread.Thread;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.net.URLRequest;


    /**     * @author shinyamaharu     */
    public class Render2D_bmptile_SampleThread extends Thread
    {
        private var timeline : Sprite;
        private var wallBMP : BitmapData;

        public function Render2D_bmptile_SampleThread(timeline : Sprite)
        {
            super();
            this.timeline = timeline;
        }

        override protected function run() : void
        {
            //load resource
            trace("loading wall resource...");
            
            //load wall texuture
            var a : IAssetLocation = new AssetLocation();
            
            a.add(new URLRequest("wall.swf"), function(d : DisplayObject):void
            {
                AppDomainRegistry.getInstance().resisterAppDomain(d);
                
                //ロードしたswfからビットマップを生成
                var b : Bitmap = AssetFactory.create("$WallTexture") as Bitmap;
                //BitmapDataを取り出す
                wallBMP = Bitmap(b).bitmapData;
            });
                   
            var preloader : PreLoader = new PreLoader();
            var loading : Thread = new PreLoaderThread(preloader, a);
            loading.start();
            loading.join();
            
            next(startRender);
        }

        private function startRender() : void
        {
            //create Render2D
            var render2D:Render2D = new Render2D();
            
            //this is a world
            var world:Render2DWorld = render2D.createWorld(1506, 980);
            world.addTilesFromBMPD(wallBMP, 120, 98);

            //start rendering
            render2D.render().start();

            //debug
            var debug:DisplayObject = render2D.createDebugger(400);
            debug.x = 600;
            debug.y = 30;
            
            timeline.addChild(render2D);
            timeline.addChild(debug);
            
            new MoveWallThread(render2D, world).start();
        }

        override protected function finalize() : void
        {
        }
    }
}