package com.imajuk.ropes
{
    import flash.display.Shape;
    import com.imajuk.ropes.shapes.IRopeShape;
    import com.imajuk.ropes.debug.DrawGuideThread;
    import com.imajuk.ropes.debug.UIPointThread;
    import com.imajuk.ropes.effects.Circuit;
    import com.imajuk.ropes.effects.Effect;
    import com.imajuk.ropes.effects.Unlace;
    import com.imajuk.ropes.models.Model;
    import com.imajuk.ropes.shapes.RopeShape;
    import com.imajuk.ropes.shapes.RopeShapeUtils;
    import com.imajuk.ropes.shapes.RopeShapes;
    import com.imajuk.threads.ThreadUtil;
    import flash.display.GraphicsStroke;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import org.libspark.thread.Thread;




    /**
     * @author shinyamaharu
     */
    public class ClosedRopeThread extends Thread
    {
        private var drawLayer : Shape;
        private var model : Model;
        private var effect : Effect;
        private var guide : MovieClip;
        private var guideLayer : Sprite;
        private var circuit : Circuit;
        private var stroke : GraphicsStroke;
        private var circuitSpeed : Number;
        private var min : Number;
        private var max : Number;
        private var amount : int;
        private var drawing : RopeThread;
        private var closedPath : Boolean;

        public function ClosedRopeThread(amount : int, drawLayer : Shape, guide : MovieClip, guideLayer : Sprite = null, stroke : GraphicsStroke = null, closedPath : Boolean = true, circuitSpeed : Number = .0005, mix : Number = 2, max : Number = 4)
        {
            super();

            this.amount = amount;
            this.stroke = stroke;
            this.guideLayer = guideLayer;
            this.guide = guide;
            this.model = new Model(new RopeShape());
            this.closedPath = closedPath;
            this.drawLayer = drawLayer;
            this.circuitSpeed = circuitSpeed;
            this.min = mix;
            this.max = max;
        }

        override protected function run() : void
        {
            var shapeA : RopeShape = RopeShapeUtils.createShapeFromMC(guide, 20, "cursor", "JAPAN", closedPath);
            // var shapeA : RopeShape = RopeShapeUtils.createShape(guide, "cursor", "JAPAN", model.closed);
            var shapes : RopeShapes = new RopeShapes();
            shapes.add(shapeA);
            model.initialize(shapes, amount, closedPath);

            circuit = new Circuit(model.shape, circuitSpeed);
            effect = new Effect(circuit, new Unlace(model, min, max, .05, 5));

            drawing = new RopeThread(Vector.<IRopeShape>([model]), drawLayer, Vector.<RopeRenderer>([new RopeRenderer(stroke)]), effect);
            drawing.start();

            // debug
            if (guideLayer)
            {
                new DrawGuideThread(guideLayer, model.shape).start();
                new UIPointThread(model, guideLayer).start();
            }

            next(loop);
        }

        private function loop() : void
        {
            ThreadUtil.infinityLoop();
        }

        override protected function finalize() : void
        {
            ThreadUtil.interrupt(drawing);
            drawLayer.graphics.clear();
        }
    }
}
