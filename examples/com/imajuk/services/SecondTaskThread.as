package com.imajuk.services
{
    import com.imajuk.service.ProgressInfo;
    import org.libspark.thread.Thread;

    /**
     * @author shinyamaharu
     */
    public class SecondTaskThread extends Thread 
    {
        private var progressInfo : ProgressInfo;

        public function SecondTaskThread(progressInfo : ProgressInfo)
        {
            super();
            this.progressInfo = progressInfo;
        }

        override protected function run() : void
        {
        }

        override protected function finalize() : void
        {
        }
    }
}
