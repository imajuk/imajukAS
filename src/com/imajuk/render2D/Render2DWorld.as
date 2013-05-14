package com.imajuk.render2D
{
    import com.imajuk.data.LinkList;
    import com.imajuk.render2D.plugins.BMPTilePlugin;
    import com.imajuk.render2D.plugins.BMPTrimPlugin;
    import com.imajuk.render2D.plugins.DOPlugin;
    import com.imajuk.render2D.plugins.TilePlugin;

    import flash.display.BitmapData;
    import flash.geom.Matrix;

    /**
     * @author imajuk
     */
    public class Render2DWorld
    {
        public var worldWidth : uint;
        public var worldHeight : uint;
        
        render_internal var layoutableNodes : LinkList = new LinkList();
        
        render_internal function get debugResource() : BitmapData
        {
            var w : int = worldWidth;
            var h : int = worldHeight;
            var s : Number = 1;
        	//max 3000px
            if (w > 3000)
            {
                s = 3000 / w;
                w = 3000;
            }
        	var b:BitmapData = new BitmapData(w, h, true, 0);
            plugins.forEach(function(plugin:IRenderPlugin, ...param) : void
            {
            	plugin.drawDebugResource(b,new Matrix(s, 0, 0, s) );
            });
            return b;
        }

        private var plugins : Array = [];
        private var render2D : Render2D;
        

        public function Render2DWorld(render2D:Render2D, worldWidth : uint, worldHeight : uint)
        {
            this.render2D = render2D;
            this.worldWidth = worldWidth;
            this.worldHeight = worldHeight;
        }

        /**
         * @param nodes AbstractNodeを要素にもつLinkList
         */
        public function addDONodes(nodes : LinkList) : void
        {
        	var plugin:IRenderPlugin = new DOPlugin(nodes); 
        	plugin.initialize(render2D);
        	plugins.push(plugin);
        }

        public function fillWorldWith(nodeClass : Class, nodeWidth : int, nodeHeight : int) : void
        {
        	var plugin:IRenderPlugin = new TilePlugin(nodeClass, nodeWidth, nodeHeight); 
        	plugin.initialize(render2D);
        	plugins.push(plugin);
        }
        
        public function addTilesFromBMPD(resource : BitmapData, nodeWidth : uint, nodeHeight : uint) : void
        {
        	var plugin:IRenderPlugin = new BMPTilePlugin(resource, nodeWidth, nodeHeight); 
        	plugin.initialize(render2D);
        	plugins.push(plugin);
        }
        
        public function createBGFromBMPD(resource : BitmapData) : void
        {
        	var plugin:IRenderPlugin = new BMPTrimPlugin(resource); 
        	plugin.initialize(render2D);
        	plugins.push(plugin);
        }
    }
}
