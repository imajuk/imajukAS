package com.imajuk.ropes
{
    import flash.display.Shape;
    import com.imajuk.ropes.models.APoint;
    import com.imajuk.ropes.shapes.IRopeShape;

    import flash.display.Graphics;
    import flash.display.GraphicsEndFill;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsPathCommand;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.IGraphicsFill;
    import flash.display.IGraphicsStroke;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.geom.Point;


    /**
     * @author imajuk
     */
    public class RopeRenderer
    {
        private static const DEFAULT_FILL : IGraphicsFill = new GraphicsSolidFill(0x6DB815);
        private static const DEFAULT_STROKE : GraphicsStroke = new GraphicsStroke(2, false, LineScaleMode.NONE, "none", "round", 3, DEFAULT_FILL);
        
        private var stroke : IGraphicsStroke;
        
        public function RopeRenderer(stroke : IGraphicsStroke = null)
        {
            this.stroke = stroke || RopeRenderer.DEFAULT_STROKE;
        }

        public function render(ropeShape : IRopeShape, drawLayer : Shape) : void
        {
            if (!ropeShape.isInitialized)
                return;

            const     g : Graphics        = drawLayer.graphics,
                  begin : APoint          = ropeShape.getAnchorPoints()[0],
                    cmd : Vector.<int>    = Vector.<int>([GraphicsPathCommand.MOVE_TO]),
                   data : Vector.<Number> = Vector.<Number>([begin.x, begin.y]),
                   path : GraphicsPath    = new GraphicsPath(cmd, data),
                      v : Vector.<IGraphicsData> = Vector.<IGraphicsData>([stroke, path]);

            var ap : APoint = begin;
            while (ap)
            {
                var ctrl : Point = ap.control;
                var nx : APoint = ap.next;

                if (ctrl && nx)
                {
                    cmd.push(GraphicsPathCommand.CURVE_TO);
                    data.push(ctrl.x, ctrl.y, nx.x, nx.y);
                }

                ap = ap.next;
            }

            if (ropeShape.closed)
            {
                // 閉じる
                cmd.push(GraphicsPathCommand.CURVE_TO);
                data.push(ropeShape.getControlPoints()[0].x, ropeShape.getControlPoints()[0].y, begin.x, begin.y);
            }

            v.push(new GraphicsEndFill());

            g.drawGraphicsData(v);
        }

        public function clear(drawLayer : Sprite) : void
        {
            drawLayer.graphics.clear();
        }
    }
}
