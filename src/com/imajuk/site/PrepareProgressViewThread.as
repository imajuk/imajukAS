package com.imajuk.site
{
    import com.imajuk.logs.Logger;
    import com.imajuk.service.ProgressInfo;
    import com.imajuk.threads.InvorkerThread;
    import com.imajuk.threads.ThreadUtil;
    import org.libspark.thread.Thread;


    /**
     * @author shinyamaharu
     */
    internal class PrepareProgressViewThread extends Thread
    {
        private var progressViewInfo : ProgressInfo;
        private var instanceResistrar : InstanceRegistory;

        public function PrepareProgressViewThread(progressViewInfo : ProgressInfo)
        {
            super();
            this.progressViewInfo = progressViewInfo;
            this.instanceResistrar = InstanceRegistory.getInstance();
        }

        override protected function run() : void
        {
            // resisterProgressView()によってプログレスビューが定義されていれば...
            // プログレスビューとして定義されたクラスの参照を試みる
            try
            {
                progressViewInfo.progressView = getView(progressViewInfo.progressViewRef);
            }
            catch(e : Error)
            {
                Logger.info(0, "loading progress display is required by state, but the display is still not instantiated.\nit'll be done after loading asset, the asset is loading now...");
//                Logger.info(0, "プログレスビューがまだ生成されていません.アセットをロードしてプログレスビューを生成します.");
                next(loadProgressViewAsset);
            }
        }

        private function loadProgressViewAsset() : void
        {
        	if (isInterrupted) return;
            interrupted(function() : void {t.interrupt();});
            
            //プログレスアセットのロードのみのレシピ
            var recipe : XML = 
                <root>
                    {instanceResistrar.getReceipt(progressViewInfo.progressViewRef.encode())}
                </root>;
                
            var t : Thread = 
                ThreadUtil.serial([
                    new ApplicationAssetLoader().getConstructionTaskFromRecipe(recipe), 
                    new InvorkerThread(
                        function() : void
                        {
                            progressViewInfo.progressView = getView(progressViewInfo.progressViewRef);
                        }
                    )
                ]);
            t.start();
            t.join();
            
            next(inject);
        }

        private function inject() : void
        {
            if (isInterrupted) return;
            progressViewInfo.progressView = getView(progressViewInfo.progressViewRef);
        }
        

        override protected function finalize() : void
        {
        }

        // --------------------------------------------------------------------------
        //
        // private
        //
        // --------------------------------------------------------------------------
        /**
         * @private
         */
        private function getView(ref : Reference) : *
        {
            return instanceResistrar.getAsset(ref);
        }
    }
}
