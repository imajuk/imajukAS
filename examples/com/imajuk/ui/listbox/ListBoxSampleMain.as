package com.imajuk.ui.listbox 
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.logs.Logger;
    import flash.display.StageQuality;
    import org.libspark.thread.EnterFrameThreadExecutor;
    import org.libspark.thread.Thread;




    /**
     * 階層をもつComboboxのサンプル
     * @author shinyamaharu
     */
    public class ListBoxSampleMain extends DocumentClass 
    {
        public function ListBoxSampleMain()
        {
            super(StageQuality.HIGH);
            Thread.initialize(new EnterFrameThreadExecutor());
        }
        
        override protected function start() : void
        {
        	Logger.ignore(Logger.DEBUG);//        	Logger.filter(Logger.NO_FILTER);
            Logger.info(0, "start");
            
            new ListboxFactoryThread().start();
        };
    }
}
