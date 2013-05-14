package com.imajuk.site
{

    import org.libspark.thread.Thread;

    /**
     * @author shinyamaharu
     */
    public class MockStateThread extends StateThread
    {
        internal static var sid : int = 0;
        protected var sid : int;

        public function MockStateThread(name : String)
        {
            super();
            this.name = name;
            this.sid = MockStateThread.sid++;
        }

        override protected function initialize() : void
        {
            Log.logs += "initialize[" + name + "(" + sid + ")]";
            
            CallbackInvoker.exec(this);
                
            next(loop);
        }

        private function loop() : void
        {
            if (isInterrupted) return;

            next(loop);
        }

        override protected function finalize() : void
        {
            var t : Thread = new WaitThread(100);
            t.start();
            t.join();

            next(function() : void
            {
                Log.logs += "finalize[" + name + "(" + sid + ")]";
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