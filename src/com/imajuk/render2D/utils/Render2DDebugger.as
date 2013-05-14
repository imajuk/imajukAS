package com.imajuk.render2D.utils
{
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.Render2DCamrera;
    import com.imajuk.render2D.render_internal;
    import com.imajuk.utils.StageReference;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix;

    /**
     * @author imajuk
     */
    public class Render2DDebugger extends Sprite
    {
        private var size : int;
        private var render2DDebug : Render2DDebugerThread;
        private var camera : Render2DCamrera;
        private var resource : BitmapData;
        private var resourceScale : Number;
        private var render2D : Render2D;
        private var canvas : Bitmap;
        private var viewScale : Number;

        public function Render2DDebugger(size : int = 400)
        {
            this.size = size;
        }

        public function initialize(render2D:Render2D) : Render2DDebugger
        {
            this.render2D = render2D;
//            this.camera = render2D.camera;
            this.canvas = addChild(new Bitmap(null, PixelSnapping.NEVER, true)) as Bitmap;
            
            refresh();

            return this;
        }

        public function refresh() : void
        {
        	if (!render2D.world)
        	   return;
        	   
            this.resource = render2D.world.render_internal::debugResource;
            if (!resource)
                return;

            //デバッグビューの縮尺
            this.viewScale = size / render2D.world.worldWidth;
            //resourceの縮尺
            this.resourceScale = viewScale * (render2D.world.worldWidth / resource.width);
        	
        	//ビューのキャンバス
            var bmp : BitmapData = new BitmapData(resource.width * resourceScale, resource.height * resourceScale, true, 0);
            bmp.draw(resource, new Matrix(resourceScale, 0, 0, resourceScale, 0, 0), null, null, null, true);
        	if (canvas.bitmapData)
        	   canvas.bitmapData.dispose();
            canvas.bitmapData = bmp;
            
            //ワールド境界
            graphics.clear();
            graphics.lineStyle(1, 0xCCCCCC);
            graphics.drawRect(0, 0, bmp.width, bmp.height);

            StageReference.stage.removeEventListener(Event.RENDER, renderHandler);
            StageReference.stage.addEventListener(Event.RENDER, renderHandler, false, 2);
        }

        private function renderHandler(event : Event) : void
        {
            StageReference.stage.removeEventListener(Event.RENDER, renderHandler);

            if (render2DDebug)
                render2DDebug.interrupt();
            
            camera = render2D.camera; 
            render2DDebug = new Render2DDebugerThread(this, camera, viewScale);
            render2DDebug.start();
        }
    }
}
