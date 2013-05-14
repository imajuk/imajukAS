package com.imajuk.site
{
    import com.imajuk.threads.ThreadUtil;

    /**
     * injectし忘れのケース
     * @author shinyamaharu
     */
    public class DummyState3 extends StateThread
    {
    	public var view : DummyVew;
    	
        override protected function initialize() : void
        {
            if (isInterrupted) return;

            // =================================
            // ビューを配置
            // =================================
            addTemporaryView(view);


            ThreadUtil.infinityLoop();
        }
    }
}
