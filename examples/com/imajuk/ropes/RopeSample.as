package com.imajuk.ropes
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.debug.PerformanceChecker;
    import com.imajuk.threads.ThreadUtil;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;


    /**
     * @author shinyamaharu
     */
    public class RopeSample extends DocumentClass 
    {
        public function RopeSample()
        {
            super(StageQuality.HIGH, StageAlign.TOP_LEFT);

            ThreadUtil.initAsEnterFrame();

            PerformanceChecker.instance.initialize(this);
        }

        override protected function start() : void
        {
        	var spr:Sprite = addChild(new Sprite()) as Sprite;
            var guideLayer : Sprite = spr.addChild(new Sprite()) as Sprite;
            var drawLayer : Shape = spr.addChild(new Shape()) as Shape;
            
            guideLayer.visible = false;
            
            new RopeSampleThread(
                guideLayer, 
                drawLayer
            ).start();
            
        };
    }
}
