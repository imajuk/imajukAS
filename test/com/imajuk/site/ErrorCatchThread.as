package com.imajuk.site
{
    import com.imajuk.threads.ThreadUtil;
    import org.libspark.thread.Thread;

    /**
     * @author shinyamaharu
     */
    public class ErrorCatchThread extends Thread
    {
        private var task : Function;
        private var test : Function;

        public function ErrorCatchThread(task : Function, test : Function)
        {
            super();
            
            this.task = task;
            this.test = test;
        }

        override protected function run() : void
        {
            error(ApplicationError, function(...param) : void
            {
                test(param[0]);
            });

            try
            {
                task();
                
                ThreadUtil.infinityLoop();
            }
            catch(e : ApplicationError)
            {
                test(e);
            }
        }

        override protected function finalize() : void
        {
        }
    }
}
