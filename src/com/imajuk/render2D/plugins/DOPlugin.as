package com.imajuk.render2D.plugins
{
    import com.imajuk.data.LinkList;
    import com.imajuk.render2D.INodeFactory;
    import com.imajuk.render2D.IRenderPlugin;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.plugins.dowrap.DONodeFactory;
    import com.imajuk.render2D.render_internal;

    import flash.display.BitmapData;
    import flash.geom.Matrix;


    /**
     * @author imajuk
     */
    public class DOPlugin implements IRenderPlugin
    {
        private var factory : INodeFactory;

        public function DOPlugin(nodes : LinkList)
        {
            factory = new DONodeFactory(nodes);
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
