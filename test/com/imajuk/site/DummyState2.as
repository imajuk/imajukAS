package com.imajuk.site
{
    import com.imajuk.threads.ThreadUtil;

    /**
     * レシピに登録してないViewをインジェクトしようとしたケース
     * @author shinyamaharu
     */
    public class DummyState2 extends StateThread
    {
        [inject]
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
