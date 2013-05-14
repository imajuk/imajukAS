package com.imajuk.render2D.utils
{
    import com.imajuk.utils.DisplayObjectUtil;
    import com.imajuk.render2D.Render2DCamrera;
    import com.imajuk.utils.MathUtil;

    import org.libspark.thread.Thread;

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;


    /**
     * @author shinyamaharu
     */
    public class Render2DDebugerThread extends Thread
    {
        private var cameraLayer : Shape;
        private var camera : Render2DCamrera;
        private var scale : Number;

        public function Render2DDebugerThread(timeline : Sprite, camera:Render2DCamrera, scale:Number)
        {
            super();

            this.camera = camera;
            this.scale = scale;

            //カメラレクトアングル
            cameraLayer = timeline.addChild(new Shape()) as Shape;
            var g : Graphics = cameraLayer.graphics;
            g.clear();
            g.lineStyle(1, 0x00FF00);
            g.drawRect(0, 0, camera.width, camera.height);
            g.endFill();

        	transformSamera();
        }

        override protected function run() : void
        {
        	if (isInterrupted) return;
        	
        	transformSamera();
            
            next(run);
        }

        private function transformSamera() : void
        {
            var s:Number = (1 / camera.scale) * scale;
            
            cameraLayer.x = camera.x * scale;
            cameraLayer.y = camera.y * scale;
            cameraLayer.scaleX = cameraLayer.scaleY = s;
            cameraLayer.rotation = MathUtil.radiansToDegrees(-camera.rad);
        }

        override protected function finalize() : void
        {
        	DisplayObjectUtil.removeChild(cameraLayer);
        }
    }
}
