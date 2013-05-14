package com.imajuk.threads 
{
    import org.libspark.thread.Thread;

    /**
     * @author yamaharu
     */
    public class InvorkerThread extends Thread 
    {
        private var closure:Function;
        private var param : Array;

        public function InvorkerThread(closure:Function, ...param)
        {
            super();
            
            if (closure == null)
            	throw new Error("recieved null.");
            	
            this.closure = closure;
            this.param = param;
//            this.closure = 
//	            function():void
//	            {
//	            	interrupted(function():void
//	                {
//	                    trace("Closure execution is Canceled");
//	                });
//	                
//                	closure.apply(closure, param);
//	            };
        }
        
        override protected function run():void
        {
        	if (isInterrupted)
        		return;
        	
        	//TODO このinterruptedが必要になるテストを書く
        	interrupted(function():void
            {
                trace("Closure execution is Canceled");
            });
        	
        	closure.apply(closure, param);
//        	if (closure != null)
//            	closure();
        }
        
        override protected function finalize():void
        {
            closure = null;
        }
    }
}
