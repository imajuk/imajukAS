package com.imajuk.service
{
    import com.imajuk.interfaces.IProgess;
    import com.imajuk.interfaces.IProgressView;
    import com.imajuk.threads.ThreadUtil;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import org.libspark.thread.Monitor;
    import org.libspark.thread.Thread;



    /**
     * IProgressオブジェクトの進捗と終了を監視するThread
     * IProgressをモデルとしIProgressViewを更新する.
     * IProgressが終了するとこのThreadも終了する.
     * 
     * @author yamaharu
     */
    public class ProgressThread extends Thread 
    {
        private var completeValue : Number;
        private var hideView : Boolean;

        public static function create(info : ProgressInfo) : Thread
        {
            var progressView:IProgressView = info.progressView;
            if (progressView)
            {
                if (!(progressView is AbstractProgressView))
                    throw new Error(progressView + "はAbstractProgressViewを継承しなければなりません.");
            }
            
            return new ProgressThread(info);
        }
        
        private var progress:IProgess;
        private var view : IProgressView;
        private var showThread : Thread = new Thread();
        private var waitProgressViewHiding : Boolean;
        private var monitor : Monitor;

        /**
         * @param progress  進捗状況を表示するIProgressViewです.
         *                  viewのaddChild(),removeChild()はこのThreadは関知しません.
         *                  viewの責任において管理する必要があります.
         *                  addChid()はIProgressView#initialize(),
         *                  removeChild()はIProgressView#destroy()に記述します.
         *                  
         * @param waitProgressViewHiding    viewの非表示終了をもってこのThreadの終了を見なすかどうか
         *                                  trueを指定した場合、viewの非表示終了を待ってこのThreadは終了します.
         *                                  falseを指定した場合、viewの非表示処理を開始した後すぐにこのThreadは終了します.
         *                                  
         * @param monitor   通常Monitorを使用する必要はありません.何らかの理由でこのスレッドをjon()できない時の代替手段です
         */
        public function ProgressThread(progressInfo:ProgressInfo)
        {
            super();
            
            this.progress = progressInfo.progress;
            this.view     = progressInfo.progressView;
            this.monitor       = progressInfo.monitor;
            this.completeValue = progressInfo.completeValue;
            this.hideView      = progressInfo.hideView;
            this.waitProgressViewHiding = progressInfo.waitProgressViewHiding;
        }

        override protected function run():void
        {
            if (isInterrupted) return;
            
            if (view)
            {
            	if (!(view is IProgressView))
                    throw new Error("不正なIProgressViewです.");
             
                view.build();
                
                showThread = view.show();
                showThread.start();
            }
            
            next(waitEvent);
        }

        private function waitEvent() : void
        {
            if (isInterrupted) return;
            interrupted(function():void{});
            
            event(progress, ProgressEvent.PROGRESS, function() : void
            {
                if (view)
                    view.update(progress.percent);
                    
                if (progress.percent == completeValue)
                    waitProgressView();
                else
                    waitEvent();
            });

            event(progress, Event.COMPLETE, function() : void
            {
            	if (view)
                    view.update(progress.percent);
                    
                waitProgressView();
            });
        }

        private function waitProgressView():void
        {
        	if (isInterrupted) return;
        	
            if(view && !AbstractProgressView(view).updateCalled)
            	throw new Error("おそらくAbstractProgressViewのサブクラスのupdate()メソッドでsuper.update()が呼び出されていません.");
            
            if (progress.percent == completeValue)
               next(hideProgress);
            else
               next(waitProgressView);
        }

        private function hideProgress():void
        {
            if (!hideView) return;
            
        	if (isInterrupted) return;
            interrupted(
                function():void
                {
                	t.interrupt();
                }
            );
        	   
            var t:Thread =  view ? view.hide() : new Thread();
            t.start();
            
            if (waitProgressViewHiding)
                t.join();
        }
        
        override protected function finalize():void
        {
        	//ビューのremoveChild()はビューの責任でやる
        	if (hideView && view)
        	   view.destroy();
        	view = null;
        	progress = null;
        	
        	ThreadUtil.interrupt(showThread);
        	showThread = null;
        	
        	//モニタがあれば通知する
        	if (monitor)
        	   monitor.notify();
        }
    }
}
