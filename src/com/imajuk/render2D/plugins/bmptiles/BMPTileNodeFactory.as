package com.imajuk.render2D.plugins.bmptiles
{
    import com.imajuk.data.LinkList;
    import com.imajuk.data.LinkListNode;
    import com.imajuk.render2D.INodeFactory;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.plugins.tile.TileNodeFactory;

    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;


    /**
     * @author imajuk
     */
    public class BMPTileNodeFactory extends TileNodeFactory implements INodeFactory
    {
        private var resource : BitmapData;

        public function BMPTileNodeFactory(nodeClass : Class, nodeWidth : int, nodeHeight : int, resource : BitmapData)
        {
            super(nodeClass, nodeWidth, nodeHeight);
            
            this.resource = resource;
        }
        
        override public function create(render2D:Render2D):LinkList
        {
        	var targets:LinkList = super.create(render2D);
        	
        	var tileW : int = _nodeWidth;
            var tileH : int = _nodeHeight;
            var c : int, r : int;
            var tile : BitmapData = new BitmapData(_nodeWidth, _nodeHeight);
            var p : Point = new Point();
            var ln : LinkListNode = targets.clone().first;
            var node : BmpNode;
            while (r < rows)
            {
                while (c < cols)
                {
                    node = BmpNode(ln.data);
                    tile = new BitmapData(tileW, tileH);
                    tile.copyPixels(resource, new Rectangle(node.x, node.y, tileW, tileH), p);
                    node.setCanvas(tile);
                    
                    ln = ln.next;
                    c++;
                }
                c = 0;
                r++;
            }
            
            trace("tile was created : " + cols + "x" + rows, cols*rows + " pieces", "(" + tileW + " px x " + tileH + " px)", resource.rect);
            
            return targets;
        }
    }
}
