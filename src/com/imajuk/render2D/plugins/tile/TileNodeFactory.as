package com.imajuk.render2D.plugins.tile
{
    import com.imajuk.data.LinkList;
    import com.imajuk.data.LinkListNode;
    import com.imajuk.render2D.INodeFactory;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.Render2DWorld;

    import flash.display.BitmapData;
    import flash.display.IBitmapDrawable;
    import flash.geom.Matrix;

    /**
     * @author imajuk
     */
    public class TileNodeFactory implements INodeFactory
    {
        private var nodeClass : Class;
        protected var _nodeWidth : int;
        protected var _nodeHeight : int;
        protected var cols : int;
        protected var rows : int;
        private var targets : LinkList;

        public function TileNodeFactory(nodeClass : Class, nodeWidth : int, nodeHeight : int)
        {
            this.nodeClass = nodeClass;
            this._nodeWidth = nodeWidth;
            this._nodeHeight = nodeHeight;
        }

        public function create(render2D : Render2D) : LinkList
        {
            var world : Render2DWorld = render2D.world;

            // decides cols and rows of tile
            cols = Math.ceil(world.worldWidth / _nodeWidth);
            rows = Math.ceil(world.worldHeight / _nodeHeight);

            // creates Nodes
            targets = createTileNodes(cols, rows);

            // place nodes in a world
            var ln : LinkListNode = targets.first;
            while (ln)
            {
                render2D.addChild(ln.data);
                ln = ln.next;
            }
            
            return targets;
        }

        private function createTileNodes(cols : int, rows : int) : LinkList
        {
            var gw : int = _nodeWidth;
            var gh : int = _nodeHeight;
            var nw : int = _nodeWidth;
            var nh : int = _nodeHeight;

            var nodes : LinkList = new LinkList();
            var c : int, r : int;
            while (r < rows)
            {
                while (c < cols)
                {
                    var node : AbstractNode = new nodeClass(gw * c, gh * r, nw, nh, c, r);
                    node.x = gw * c;
                    node.y = gh * r;
                    nodes.push(node);
                    c++;
                }
                c = 0;
                r++;
            }
            return nodes;
        }
        
        public function drawDebugResource(b : BitmapData, m : Matrix) : void
        {
            var n:LinkListNode = targets.first;
            while(n)
            {
                var node:IBitmapDrawable = n.data;
                b.draw(node, m);
                n = n.next;
            }
        }
    }
}
