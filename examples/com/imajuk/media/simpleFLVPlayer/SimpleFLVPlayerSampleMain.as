package com.imajuk.media.simpleFLVPlayer
{
    import com.imajuk.constructions.DocumentClass;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import org.libspark.thread.EnterFrameThreadExecutor;
    import org.libspark.thread.Thread;



    public class SimpleFLVPlayerSampleMain extends DocumentClass
    {
        public function SimpleFLVPlayerSampleMain()
        {
    		super(StageQuality.HIGH, StageAlign.TOP_LEFT);
            
            trace("/***********************");
            trace(" * VIDEO TEST");
            
        }
        
        override protected function start():void
        {
            Thread.initialize(new EnterFrameThreadExecutor());
            
            new SimpleFLVPlayerSampleMainThread(addChild(new Sprite()) as Sprite).start();
            
//            PerformanceChecker.instance.initialize(this);
        }
    }
}