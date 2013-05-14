package com.imajuk.site
{
    import com.imajuk.logs.Logger;

    import org.libspark.thread.Thread;
    import org.libspark.thread.ThreadState;

    /**
     * @private     * @author shinyamaharu     */
    public class InterruptThread extends Thread
    {
        private var threads : Array;
        private var model : ApplicationStateModel;

        public function InterruptThread(threads : Array, model:ApplicationStateModel)
        {
            super();
            this.threads = threads;
            this.model = model;
        }

        override protected function run() : void
        {
            threads.forEach(function(t : Thread, ...param) : void
            {
            	Logger.info(2, "✕  interrupted state : " + t);
            	
            	//ステートのfinalizeを確実に呼ぶために、実行されてないステートがあれば実行する
            	if (t.state == ThreadState.NEW)
            		t.start();
                
                t.interrupt();
                model.removeActiveState(t);
            });
            
            next(waitInterrution);
        }
        
        private function waitInterrution() : void
        {
            var interruptedAll:Boolean = threads.every(function(t:Thread, ...param) : Boolean
            {
                return t.state == ThreadState.TERMINATED;
            });
            
            if (!interruptedAll)
                next(waitInterrution);
        }

        override protected function finalize() : void
        {
        }
    }
}