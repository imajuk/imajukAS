package com.imajuk.ropes
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.debug.PerformanceChecker;
    import com.imajuk.ropes.effects.Effect;
    import com.imajuk.threads.ThreadUtil;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;




    /**
     * @author shinyamaharu
     */
    public class RopeMixSample extends DocumentClass
    {
        public function RopeMixSample()
        {
            super(StageQuality.HIGH, StageAlign.TOP_LEFT);

            ThreadUtil.initAsEnterFrame();

            PerformanceChecker.instance.initialize(this);
        }

        override protected function start() : void
        {
            var guideLayer : Sprite = addChild(new Sprite()) as Sprite;
            var drawLayer  : Shape  = addChild(new Shape()) as Shape;
            
            
            guideLayer.visible = false;

            var effect:Effect = new Effect();

            new RopeMixSampleThread(
                guideLayer, 
                drawLayer, 
                effect
            ).start();
            
        };
    }
}
