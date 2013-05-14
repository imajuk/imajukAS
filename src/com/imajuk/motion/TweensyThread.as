package com.imajuk.motion
{
    import com.flashdynamix.motion.TweensyTimeline;    
    import com.flashdynamix.motion.Tweensy;    
    
    import org.libspark.thread.Monitor;    
    import org.libspark.thread.Thread;

    /**
     * @author yamaharu
     */
    public class TweensyThread extends Thread 
    {
        private var target:*;        private var optionalProp:*;
        private var _monitor:Monitor;
        private var delay:Number;
        private var duration:Number;
        private var to:Object;
        private var from:Object;
        private var easing : Function;
        private var tt : TweensyTimeline;
        private var onComplete : Function;

        public function TweensyThread(
                            target:*,
                            delay:Number,
                            duration:Number,
                            easing:Function,
                            from:Object=null,
                            to:Object=null,
                            optionalProp:* = null,
                            onComplete:Function = null
                        )
        {
            super();
            this.target = target;
            this.delay = delay;
            this.duration = duration;
            this.easing = easing;
            this.to = to;
            this.from = from;
            this.optionalProp = optionalProp;
            this.onComplete = onComplete;
            _monitor = new Monitor();
        }
        
        override protected function run():void
        {
        	if (isInterrupted)
        		return;
        		
        	interrupted(function():void
            {
            	if (tt)
            	   Tweensy.remove(tt);
            });
            
            error(Error, function(e:Error):void
            {
                trace("TweensyThreadエラー", e);                throw new Error("TweensyThreadエラー", e);
                interrupt();
            });
            
        	_monitor.wait();
        	
        	var mainTarget:*;
        	var subTarget:*;            if (optionalProp)
            {
                mainTarget = optionalProp;
                subTarget = target;
            }            else
            {
                mainTarget = target;
                subTarget = optionalProp;
            }
            
//        	trace(this + " : run " + [target, mainTarget]);
            try
            {        	
                var f : Function = 
                    (onComplete == null) ? 
                        _monitor.notifyAll : 
                        function():void
                        {
                        	onComplete();
                        	_monitor.notifyAll();
                        };
                 
                if (from != null && to != null)
                    tt = Tweensy.fromTo(mainTarget, from, to, duration, easing, delay, subTarget, f);                else if(from != null)
                    tt = Tweensy.from(mainTarget, to, duration, easing, delay, subTarget, f);
                else if(to != null)
                    tt = Tweensy.to(mainTarget, to, duration, easing, delay, subTarget, f);
            }
            catch(e:Error)
            {
            	trace("$$$$", e.message);   
            }
        }

        override protected function finalize() : void
        {
            target = null;
            optionalProp = null;
            _monitor = null;
            to = null;
            from = null;
            easing = null;
//            if (tt)
//            	tt.dispose();
            tt = null;
        }

        override public function toString() : String 
        {
            return "TweensyThread " + id + "[" + [target] + "]";
        }
    }
}
