package com.imajuk.render2D.logics
{
    import com.imajuk.data.LinkListNode;
    import com.imajuk.render2D.INodeFactory;
    import com.imajuk.render2D.IRenderLogic;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.Render2DCamrera;
    import com.imajuk.render2D.plugins.tile.AbstractNode;
    import com.imajuk.render2D.render_internal;

    /**
     * @author imajuk
     */
    public class NodeLayoutLogic implements IRenderLogic
    {
        private var previousX : Number;
        private var previousY : Number;
        private var previousScale : Number;
        private var previousRad : Number;
        private var render2D : Render2D;


        public function initialize(render2D : Render2D, factory : INodeFactory) : void
        {
            this.render2D = render2D;
            render2D.world.render_internal::layoutableNodes = 
                render2D.world.render_internal::layoutableNodes.concat(factory.create(render2D));
        }

        public function render() : void
        {
        	if (!render2D)
               return;
               
            var camera:Render2DCamrera = render2D.camera;
        	var pi:Number = Math.PI;
            var vx : Number = camera.x;
            var vy : Number = camera.y;
            var s : Number = camera.scale;
            var rad : Number = camera.rad;
            var sw : int = camera.width;
            var sh : int = camera.height;
            // スケーリングは微妙な隙間を埋めるため少し拡大する
            //TODO ↑の処理はタイリングの時だけにする
            var s2:Number = s;
//            var s2:Number = (s == 1) ? s : (s > 1) ? s * 1.005 : s * 1.015;


            var ns : Boolean = s != previousScale;
            var nr : Boolean = rad != previousRad;

            //前回からカメラに変化がなければレンダリングしない
            //TODO ノード自身が移動する場合は毎回レンダリングする必要がある
            if (vx == previousX && vy == previousY && !ns && !nr)
                return;

            var cos : Number = Math.cos(-rad);
            var sin : Number = Math.sin(-rad);


            var ln : LinkListNode = render2D.world.render_internal::layoutableNodes.first;
            while (ln)
            {
                var n : AbstractNode = ln.data as AbstractNode;

                var dx : Number = (n.worldX - vx) * s;
                var dy : Number = (n.worldY - vy) * s;
                
                var tx : Number = dx * cos - dy * sin;
                var ty : Number = dx * sin + dy * cos;

                var dg : Number = n.size;
                
                if (tx < -dg || tx - dg > sw || ty < -dg || ty - dg > sh)
                {
                    n.visible = false;
                }
                else
                {
                    n.visible = true;
                    n.x = tx;
                    n.y = ty;
                }

                if (ns) n.scaleX = n.scaleY = s2;
                if (nr) n.rotation = -rad / pi * 180;

                ln = ln.next;
            }

            previousX = camera.x;
            previousY = camera.y;
            previousScale = camera.scale;
            previousRad = camera.rad;
        }
    }
}
