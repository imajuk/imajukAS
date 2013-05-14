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
    [SWF(backgroundColor="#000000", frameRate="60", width="900", height="480")]
    public class SoundSpectrumSample extends DocumentClass
    {
        public function SoundSpectrumSample()
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

            new SoundSpectrumThread(
                guideLayer, 
                drawLayer
            ).start();
            
        };
    }
}
