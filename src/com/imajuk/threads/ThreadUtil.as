package com.imajuk.threads 
{
    import com.imajuk.logs.Logger;
    import org.libspark.thread.EnterFrameThreadExecutor;
    import org.libspark.thread.utils.Executor;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.Thread;

    import flash.events.EventDispatcher;
    import flash.events.Event;

    /**
     * @author shinyamaharu
     */
    public class ThreadUtil 
    {
        public static function get infinityLoop() : Function
        {
            return function():void
            {
                Thread.interrupted(function():void
                {
                });
                Thread.event(new EventDispatcher(), Event.CANCEL, function():void
                {
                });
            };
        }

        public static function mixinErrorHandler(thread:Thread = null, reset : Boolean = true, autoTermination : Boolean = false) : void 
        {
            Thread.error(Error, function(...param):void
            {
            	Logger.error(param[0], param[1]);
            	interrupt(thread);
            }, reset, autoTermination);
        }

        public static function serial(threads : Array) : Thread 
        {        	return add(SerialExecutor, threads);
        }

        public static function pararel(threads : Array) : Thread 
        {
        	return add(ParallelExecutor, threads);
        }
        
        private static function add(executor : Class, threads : Array) : Thread 
        {
            var e : Executor = new executor();
            threads.forEach(function(t : Thread, ...param):void
            {
            	if (t)
                    e.addThread(t);
            });
            return e;
        }

        public static function interrupt(thread : Thread) : void 
        {
        	//TODO クライアントのエラーハンドラを上書きしてしまう？
        	//Threadの中でこのメソッドが呼ばれたらエラーハンドラを設定
//        	if(Thread.currentThread != null)
//            	Thread.error(Error, function(...param):void
//                {
//                    Logger.error(param[0], param[1], thread + "のinterrupt中にエラーが発生しました");
//                });
                        
        	if (thread)
        	   thread.interrupt();
        }

        public static function initAsEnterFrame() : void 
        {
        	if (!(Thread.isReady))
        	   Thread.initialize(new EnterFrameThreadExecutor());
        }
    }
}


