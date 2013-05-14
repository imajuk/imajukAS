package com.imajuk.ui.accodiaon 
{
    import com.imajuk.constructions.DocumentClass;
    import flash.display.StageQuality;
    import org.libspark.thread.EnterFrameThreadExecutor;
    import org.libspark.thread.Thread;



    /**
     * 階層をもつComboboxのサンプル
     * @author shinyamaharu
     */
    public class AccordionSampleMain extends DocumentClass 
    {
        public function AccordionSampleMain()
        {
            super(StageQuality.HIGH);
            Thread.initialize(new EnterFrameThreadExecutor());
        }
        
        override protected function start() : void
        {
            trace("\n\n/********* start ");
            
            new AccordionFactoryThread().start();
        };
    }
}
