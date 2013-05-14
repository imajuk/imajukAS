package com.imajuk.site
{
    import com.imajuk.logs.Logger;

    import org.libspark.thread.Monitor;
    import org.libspark.thread.Thread;
    import org.libspark.thread.ThreadState;

    /**
     * @private
     * @author shinyamaharu
     */
    internal class StateInvoker extends Thread 
    {
        private var kill : Thread;
        private var execQueue : Array;

        public function StateInvoker(transitionInfo : StateTransitionInfo)
        {
            super();
            
            this.kill = transitionInfo.interruption;
            this.execQueue = transitionInfo.queue;
        }

        override protected function run() : void
        {
        	if (isInterrupted) return;
        	interrupted(function():void{});
        	
            if (kill)
            {
                error(Error, function(...param) : void
                {
                    Logger.error(param[0], param[1], "ステート終了時にエラーが発生しました");
                });
                kill.start();
                kill.join();
            }
            
            next(startState);
        }

        private function startState() : void
        {
        	if (isInterrupted) return;
            interrupted(function():void{});
            
            error(Error, function(...param) : void
            {
                var message : String = "ステート" + current + "の初期化に失敗しました.";
                Logger.error(param[0], param[1], message);
            });
            
            var current : StateThread = execQueue.shift();

            //=================================
            // 新しいステートをスタート
            //=================================
            if (current.state == ThreadState.NEW)
            {
                Logger.info(2, "➤  started new state : " + current);
                current.start();

                // 親子関係のあるステートの連鎖実行時に、前のステートのイニシャライズをまつ
                var m : Monitor = new Monitor();
                m.wait();
                current.initializeNotifer = m;
            }
            
            if (execQueue.length > 0)
                next(startState);
        }

        override protected function finalize() : void
        {
        }
    }
}
