package com.imajuk.render2D.plugins
{
    import com.imajuk.render2D.INodeFactory;
    import com.imajuk.render2D.IRenderPlugin;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.plugins.bmptiles.BMPTileNodeFactory;
    import com.imajuk.render2D.plugins.bmptiles.BmpNode;
    import com.imajuk.render2D.render_internal;

    import flash.display.BitmapData;
    import flash.geom.Matrix;



    /**
     * @author imajuk
     */
    public class BMPTilePlugin implements IRenderPlugin
    {
        private var factory : INodeFactory;

        public function BMPTilePlugin(resource : BitmapData, nodeWidth : uint, nodeHeight : uint)
        {
            factory = new BMPTileNodeFactory(BmpNode, nodeWidth, nodeHeight, resource);
        }

        public function initialize(render2D : Render2D) : void
        {
            render2D.render_internal::layoutNodeLogic.initialize(render2D, factory);
        }

        public function drawDebugResource(b : BitmapData, m : Matrix) : void
        {
        	factory.drawDebugResource(b, m);
        }
    }
}
