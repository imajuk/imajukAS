package com.imajuk.ropes
{
    import com.imajuk.ropes.effects.Effect;
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.shapes.IRopeShape;

    import org.libspark.thread.Thread;

    import flash.display.Shape;



    /**
     * @author shinyamaharu
     */
    public class RopeThread extends Thread
    {
        private var shapes : Vector.<IRopeShape>;
        private var drawLayer : Shape;
        private var effect : Effect;
        private var renderer : Vector.<RopeRenderer>;

        public function RopeThread(shapes : Vector.<IRopeShape>, drawLayer : Shape, renderer:Vector.<RopeRenderer> = null, effect : Effect = null)
        {
            super();

            this.renderer  = renderer;
            this.shapes    = shapes;
            this.drawLayer = drawLayer;
            this.effect    = effect;
        }

        override protected function run() : void
        {
            if (isInterrupted) return;
            
            const   hasEffect : Boolean = effect != null,
                  hasRenderer : Boolean = renderer != null;
                  
            var   i : int,
                 cp : ControlPoint,
                cps : Array;
                
            if (hasRenderer)
                drawLayer.graphics.clear();
                
            for each(var shape : IRopeShape in shapes) 
            {
                cps = shape.getControlPoints();
                cp = cps[0];
                
                //=================================
                // Effect
                //=================================
                //------------------------
                // exec start up task of effect
                //------------------------
                if (hasEffect) effect.execLoopStartTask();
                while (cp)
                {
                    //------------------------
                    // refresh control point
                    //------------------------
                    cp.update(shape.getPointOnControlPointsLocus(cp.pointQuery));
                    //------------------------
                    // apply effects to control points
                    //------------------------
                    if (hasEffect) effect.exec(cp, shape);
                    //------------------------
                    // calc anchor points position
                    //------------------------
                    cp.ap.calc();
                    cp = cp.next;
                }
                //------------------------
                // exec finalize task of effect
                //------------------------
                if (hasEffect) effect.execLoopEndTask();
                
                //=================================
                // rendering
                //=================================
                if (hasRenderer)
                    RopeRenderer(renderer[i++]).render(shape, drawLayer);
                
            }
            
                
            next(run);
        }

        override protected function finalize() : void
        {
        }
    }
}
