package com.imajuk.motion
{
    import com.imajuk.logs.Logger;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.core.easing.IEasing;
    import org.libspark.betweenas3.easing.Expo;
    import org.libspark.betweenas3.events.TweenEvent;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.thread.Monitor;
    import org.libspark.thread.Thread;

    /**
     * @author shinyamaharu
     */
    public class BetweenThread extends Thread 
    {
        private var tween : ITween;
        private var monitor : Monitor = new Monitor();
        private var _onComplete : Function;
        private var _onPlay : Function;
        private var _onUpdate : Function;
        private var _onStop : Function;

        public function BetweenThread(
                            tween : ITween, 
                            onPlay    :Function = null,
                            onUpdate  :Function = null,
                            onStop    :Function = null,
                            onComplete:Function = null
                        )
        {
            super();
            
            this.tween = tween;

            _onComplete = onComplete;
            _onStop = onStop;
            _onUpdate = onUpdate;
            _onPlay = onPlay;
            
            if (onPlay != null)
                tween.addEventListener(TweenEvent.PLAY, _onPlay);
            if (onUpdate != null)
                tween.addEventListener(TweenEvent.UPDATE, _onUpdate);
            if (onStop != null)
                tween.addEventListener(TweenEvent.STOP, _onStop);

            tween.addEventListener(TweenEvent.COMPLETE, completeHandler);
        }

        private function completeHandler(event : TweenEvent) : void
        {
        	monitor.notify();
        	if (_onComplete != null) _onComplete();
        }

        override protected function run() : void
        {
        	if (isInterrupted) return;
        	interrupted(function():void{tween.stop();});
        	
            error(Error, function(...param) : void
            {
            	Logger.warning("a error occured while tweening!\n[REASON]" + param);
            });
        	
        	monitor.wait();
        	
        	try
        	{
        	   tween.play();
        	}
        	catch(e:Error)
        	{
            	Logger.warning("a error occured while tweening!\n[REASON]" + e);
        	}
        }

        override protected function finalize() : void
        {
            if (_onPlay != null)
                tween.removeEventListener(TweenEvent.PLAY, _onPlay);
            if (_onUpdate != null)
                tween.removeEventListener(TweenEvent.UPDATE, _onUpdate);
            if (_onStop != null)
                tween.removeEventListener(TweenEvent.STOP, _onStop);
            tween.removeEventListener(TweenEvent.COMPLETE, completeHandler);
        	
        	monitor = null;
        	tween = null;
        }

        public static function create(
                                  target   : *, 
                                  duration : Number,
                                  to       : Object, 
                                  from     : Object = null, 
                                  easing   : IEasing = null,
                                  delay    : Number = 0,
                                  repeat   : int = 0,
                                  onComplete : Function = null
                               ) : Thread
        {
            easing = easing || Expo.easeInOut;
            var tween : ITween = 
                (from != null) ? 
                    BetweenAS3.tween(target, to, from, duration, easing) : 
                    BetweenAS3.to(target, to, duration, easing);
        	
        	if (delay > 0)
        	   tween = BetweenAS3.delay(tween, delay);
        	   
        	if (repeat > 0)
        	   tween = BetweenAS3.repeat(tween, repeat);
        	
            return new BetweenThread(tween, null, null, null, onComplete);
        }
    }
}
