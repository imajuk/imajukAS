package com.imajuk.service
{
    import com.imajuk.interfaces.IProgess;
    import com.imajuk.interfaces.IProgressView;
    import com.imajuk.site.Reference;

    import org.libspark.thread.Monitor;
    /**
     * 進捗に関連するオブジェクトを格納します
     * 進捗を開始するThreadはProgressFactory.create()にこのオブジェクトを渡す事で取得できます
     * 
     * @author imajuk
     */
    public class ProgressInfo
    {
        public var progress : IProgess;
        public var progressView : IProgressView;
        public var progressViewRef : Reference;
        public var waitProgressViewHiding : Boolean;
        public var monitor : Monitor;
        public var completeValue : Number;
        public var hideView : Boolean;

        /**
         * @param progress  進捗のモデル
         * @param progressTimeline          ビューがある場合それが格納されるコンテナ
         * @param progressPosX              ビューがある場合のそのx座標
         * @param progressPosY              ビューがある場合のそのy座標
         * @param waitProgressViewHiding    進捗はビューの終了を待って終了するかどうか
         * @param progressView              ビューとなるオブジェクト
         * @param progressViewRef           ビューとなるオブジェクトの参照オブジェクト
         * @param monitor                   進捗の終了を通知するためのMonitor
         *                                  何らかの理由で進捗の終了を通知する必要がある場合はこのパラメータを使う
         */
        public function ProgressInfo(
                            waitProgressViewHiding:Boolean = true,
                            progressView:IProgressView = null,
    	                    progressViewRef : Reference = null,
    	                    monitor:Monitor = null,
                            completeValue:Number = 1,
                            hideView:Boolean = true
                        )
        {
            this.progressViewRef = progressViewRef;
            this.progressView = progressView;
            this.waitProgressViewHiding = waitProgressViewHiding;
            this.monitor = monitor;
            this.completeValue = completeValue;
            this.hideView = hideView;
        }
    }
}
