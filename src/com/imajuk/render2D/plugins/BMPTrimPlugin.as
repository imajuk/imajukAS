package com.imajuk.render2D.plugins
{
    import com.imajuk.render2D.IRenderPlugin;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.logics.BMPTrimLogic;
    import com.imajuk.render2D.render_internal;

    import flash.display.BitmapData;
    import flash.geom.Matrix;


    /**
     * @author imajuk
     */
    public class BMPTrimPlugin implements IRenderPlugin
    {
        private var resource : BitmapData;

        public function BMPTrimPlugin(resource : BitmapData)
        {
            this.resource = resource;
        }

        public function initialize(render2D:Render2D) : void
        {
            render2D.render_internal::bmpTrimLogic = new BMPTrimLogic(resource);
            render2D.render_internal::bmpTrimLogic.initialize(render2D, null);
        }

        public function drawDebugResource(b : BitmapData, m : Matrix) : void
        {
        	b.draw(resource, m);
        }
    }
}
