package com.imajuk.ui.buttons 
{
    import com.imajuk.logs.Logger;
    import com.imajuk.constructions.DocumentClass;
    import flash.display.StageQuality;
    import org.libspark.thread.EnterFrameThreadExecutor;
    import org.libspark.thread.Thread;



    /**
     * @author shinyamaharu
     */
    public class ButtonSampleMain2 extends DocumentClass 
    {
        public function ButtonSampleMain2()
        {
            super(StageQuality.HIGH);
            
            Thread.initialize(new EnterFrameThreadExecutor());
            
            Logger.release("ButtonSampleMain");
        }

        override protected function start() : void
        {
        	new ButtonSampleMainThread2(this).start();
        };
    }
}
