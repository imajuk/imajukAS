package com.imajuk.constructions
{
    import org.libspark.betweenas3.events.TweenEvent;
    import org.libspark.betweenas3.tweens.ITween;

    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    /**
     * @author imajuk
     */
    public class GlobalPause
    {
        private static var tweens : Dictionary = new Dictionary(true);
//        private static var isInitialized : Boolean;
        public static var isPause : Boolean;
        private static var dispatcher : EventDispatcher= new EventDispatcher();

        public static function registerTween(tween : ITween) : void
        {
            tweens[tween] = tween;
            tween.addEventListener(TweenEvent.COMPLETE, onCompTween);

//            if (!isInitialized) initialize();
        }

        private static function unRegisterTween(tween : ITween) : void
        {
            delete tweens[tween];
            tween.removeEventListener(TweenEvent.COMPLETE, onCompTween);
        }
        
        private static function onCompTween(event : TweenEvent) : void
        {
            unRegisterTween(ITween(event.target));
        }


//        private static function initialize() : void
//        {
//            dispatcher = new EventDispatcher();
//            isInitialized = true;
////            StageReference.stage.addEventListener(GlobalPauseEvent.PAUSE, function() : void
////            {
////                togglePause();
////            });
//        }

        public static function togglePause() : void
        {
            isPause = !isPause;
            for each (var twn : ITween in tweens)
                twn.togglePause();
            
            dispatcher.dispatchEvent(new GlobalPauseEvent(isPause?GlobalPauseEvent.PAUSE:GlobalPauseEvent.RESUME));
        }

        public static function addEventListener(type : String, listener : Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true) : void
        {
            dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        
        public static function removeEventListener(type : String, listener : Function, useCapture:Boolean=false):void
        {
            dispatcher.removeEventListener(type, listener, useCapture);
        }

        public static function disposeAllTween() : void
        {
            for each (var twn : ITween in tweens)
                twn.stop();
        }

    }
}
