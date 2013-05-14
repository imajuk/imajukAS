package com.imajuk.site
{
    import com.imajuk.threads.ThreadUtil;


    /**
     * @author shinyamaharu
     */
    public class MockStateThread5 extends StateThread
    {
        internal static var sid : int = 0;
        private var sid : int;
        
        [inject]
        public var view:ViewA;
        
        [inject]
        public var myProgressView:ProgressView;

        /**
         * プログレスビューテスト用
         * プログレスフェーズを終わらせるタイミングをメタタグで定義
         */
        public function MockStateThread5(name : String)
        {
            super();
            
            this.name = name;
            this.sid = MockStateThread.sid++;
            
            resisterProgressView(new Reference(ProgressView));
            
        }

        override protected function initialize() : void
        {
            Log.logs += "initialize[" + name + "(" + sid + ")]";

        	next(loop);
        }

        private function loop() : void
        {
        	
        	ThreadUtil.infinityLoop();
        }

        override protected function finalize() : void
        {
            sleep(100);

            next(function() : void
            {
                Log.logs += "finalize[" + name + "(" + sid + ")]";
                CallbackInvoker.exec(this);
            });
        }
    }
}

import org.libspark.thread.Thread;

class WaitThread extends Thread
{
    private var time : int;
    
    public function WaitThread(time : int)
    {
        this.time = time;
    }
    
    override protected function run():void
    {
    	sleep(time);
    }
}