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
        private var models : Vector.<IRopeShape>;
        private var drawLayer : Shape;
        private var effect : Effect;
        private var renderer : Vector.<RopeRenderer>;

        public function RopeThread(models : Vector.<IRopeShape>, drawLayer : Shape, renderer:Vector.<RopeRenderer> = null, effect : Effect = null)
        {
            super();

            this.renderer = renderer;
            this.models = models;
            this.drawLayer = drawLayer;
            this.effect = effect;
        }

        override protected function run() : void
        {
            if (isInterrupted) return;
            
            const   hasEffect : Boolean = effect != null,
                  hasRenderer : Boolean = renderer != null;
                  
            var   i : int,
                 cp : ControlPoint,
                cps : Array;
                
            drawLayer.graphics.clear();
                
            for each(var model : IRopeShape in models) 
            {
                cps = model.getControlPoints();
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
                    // apply effects to control points
                    //------------------------
                    if (hasEffect) effect.exec(cp, model);
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
                    RopeRenderer(renderer[i++]).render(model, drawLayer);
                
            }
            
                
            next(run);
        }

        override protected function finalize() : void
        {
        }
    }
}
