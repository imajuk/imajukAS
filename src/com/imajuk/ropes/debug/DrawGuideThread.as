package com.imajuk.ropes.debug
{
    import com.imajuk.ropes.shapes.IRopeShape;
    import com.imajuk.utils.GraphicsUtil;

    import org.libspark.thread.Thread;

    import flash.display.Sprite;




    /**
     * @author shinyamaharu
     */
    public class DrawGuideThread extends Thread
    {
        private var guideLayer : Sprite;
        private var ropeShape : IRopeShape;

        public function DrawGuideThread(guideLayer : Sprite, shape : IRopeShape)
        {
            super();
            this.guideLayer = guideLayer;
            this.ropeShape = shape;
        }

        override protected function run() : void
        {
            guideLayer.graphics.clear();
            GraphicsUtil.drawSegments(guideLayer.graphics, ropeShape.getSegments(), 0, 0xFF3c3e95);
            guideLayer.graphics.endFill();

            next(run);
        }

        override protected function finalize() : void
        {
        }
    }
}
