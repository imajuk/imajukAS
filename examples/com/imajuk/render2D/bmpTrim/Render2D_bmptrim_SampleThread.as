package com.imajuk.render2D.bmpTrim
{
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.Render2DCamrera;
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




    /**     * @author shinyamaharu     */    public class Render2D_bmptrim_SampleThread extends Thread     {
        private var timeline : Sprite;
        private var resource : BitmapData;
                public function Render2D_bmptrim_SampleThread(timeline:Sprite)
        {
            super();
            this.timeline = timeline;        }        override protected function run() : void        {        	next(loadResource);
        }

        private function loadResource() : void
        {
        	//load wall texuture
            var a : IAssetLocation = new AssetLocation();
            a.add(new URLRequest("exterme.jpg"), function(b : Bitmap):void
            {
            	resource = b.bitmapData;
            });
                   
            var preloader : PreLoader = new PreLoader();
            var loading : Thread = new PreLoaderThread(preloader, a);
            loading.start();
            loading.join();
            
        	next(initRender2D);
        }

        private function initRender2D() : void
        {
            //create Render2D
            var render2D:Render2D = new Render2D(709, 500);
            
            //camera
            var camera:Render2DCamrera = render2D.camera; 
//            camera.x = 500;

        	//this is a world
            var world:Render2DWorld = render2D.createWorld(resource.width, resource.height);
            world.createBGFromBMPD(resource);
            
            
            //render
            render2D.render().start();

            //debug
            var debug:DisplayObject = render2D.createDebugger(400);
            debug.x = 800;
            debug.y = 30;
            
            
            timeline.addChild(render2D);
            timeline.addChild(debug);
            
                    	new MoveCameraThread(camera).start();
        }        override protected function finalize() : void        {        }    }}