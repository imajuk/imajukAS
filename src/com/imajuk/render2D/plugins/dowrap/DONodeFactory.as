package com.imajuk.render2D.plugins.dowrap
{
    import com.imajuk.data.LinkList;
    import com.imajuk.data.LinkListNode;
    import com.imajuk.render2D.INodeFactory;
    import com.imajuk.render2D.Render2D;

    import flash.display.BitmapData;
    import flash.geom.Matrix;

    /**
     * @author imajuk
     */
    public class DONodeFactory implements INodeFactory
    {
        private var nodes : LinkList;

        public function DONodeFactory(nodes : LinkList)
        {
            this.nodes = nodes;
        }

        public function create(render2D : Render2D) : LinkList
        {
        	//ノードの座標を設定しRender2Dに追加
            var n:LinkListNode = nodes.first;
            while(n)
            {
            	var node:DONode = n.data;
                node.x = node.worldX;
                node.y = node.worldY;
                render2D.addChild(node);
                n = n.next;
            }

            return nodes;
        }

        public function drawDebugResource(b : BitmapData, m : Matrix) : void
        {
            var n:LinkListNode = nodes.first;
            while(n)
            {
                var node:DONode = n.data;
                m.tx = node.worldX * m.a;
                m.ty = node.worldY * m.d;
                b.draw(node, m);
                n = n.next;
            }
        }
    }
}
