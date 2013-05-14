package com.imajuk.behaviors 
{
    import com.imajuk.ui.buttons.IButton;
    import com.imajuk.ui.buttons.button_internal;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.core.easing.IEasing;
    import org.libspark.betweenas3.tweens.ITween;

    import flash.display.DisplayObject;
    import flash.media.Sound;


    /**
     * @author shinyamaharu
     */
    public class AbstractButtonBehavior implements IButtonBehavior 
    {
        protected var onObj : Object;
        protected var offObj : Object;
        internal var proxy : *;
        internal var proxy_invert : *;
        
        //--------------------------------------------------------------------------
        //  getter/setter
        //--------------------------------------------------------------------------
        protected var _target : DisplayObject;
        public function get target() : DisplayObject
        {
            return _target;
        }

        protected var behavior : ITween;
        protected function setBehavior(t:ITween) : ITween
        {
            disposeBehavior();
            
            behavior = t;
            return behavior;
        }
        
        protected var _sound : Sound;
        public function get sound() : Sound
        {
            return _sound;
        }
        public function set sound(sound : Sound) : void
        {
            _sound = sound;
        }
        
        //--------------------------------------------------------------------------
        //  Constructor
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //  IButton Behavior implementation
        //--------------------------------------------------------------------------
        public function initialize(behaviorSubject:*, amount:Number) : IButtonBehavior
        {
            throw new Error("initialize is abstract method");
            return this;
        }
        
        public function dispose() : void
        {
            disposeBehavior();
            _target = null;
        }

        public function clone() : IButtonBehavior
        {
            throw new Error("clone is abstract method");
            return null;
        }
        
        public function rollOverBehavior(_detail:BehaviorDetail) : ITween
        {
            return getOnBehavior(_detail.overDuration, _detail.overEasing);
        }

        public function rollOutBehavior(_detail:BehaviorDetail) : ITween
        {
            return getOffBehavior(_detail.outDuration, _detail.outEasing);
        }
        
        public function downBehavior(_detail:BehaviorDetail) : ITween
        {
            return getOnBehavior(_detail.downDuration, _detail.downEasing);
        }

        public function upBehavior(_detail:BehaviorDetail) : ITween
        {
            return getOffBehavior(_detail.upDuration, _detail.upEasing);
        }

        public function disableBehavior(_detail:BehaviorDetail) : ITween
        {
            return getOnBehavior(_detail.disabledDuration, _detail.disabledEasing);
        }

        public function enableBehavior(_detail:BehaviorDetail) : ITween
        {
            return getOffBehavior(_detail.enabledDuration, _detail.enabledEasing);
        }

        public function selectedBehavior(_detail:BehaviorDetail) : ITween
        {
            return getOnBehavior(_detail.selectedDuration, _detail.selectedEasing);
        }

        public function unSelectedBehavior(_detail:BehaviorDetail) : ITween
        {
            return getOffBehavior(_detail.unSelectedDuration, _detail.unSelectedEasing);
        }
        
        //--------------------------------------------------------------------------
        //  private
        //--------------------------------------------------------------------------
        protected function getOnBehavior(duration:Number, easing:IEasing):ITween
        {
            var t:ITween = 
                proxy_invert ?
                    BetweenAS3.parallel(
                        BetweenAS3.to(proxy,         onObj, duration, easing),
                        BetweenAS3.to(proxy_invert, offObj, duration, easing)
                    ) :
                    BetweenAS3.to(proxy, onObj, duration, easing);

            return setBehavior(t);
        }
        
        protected function getOffBehavior(duration:Number, easing:IEasing):ITween
        {
            var t:ITween = 
                proxy_invert ?
                    BetweenAS3.parallel(
                        BetweenAS3.to(proxy,       offObj, duration, easing),
                        BetweenAS3.to(proxy_invert, onObj, duration, easing)
                    ) :
                    BetweenAS3.to(proxy, offObj, duration, easing);
                  
            return setBehavior(t);
        }
        
        protected function resolveTarget(behaviorSubject:*, behaviorTarget:*) : *
        {
            if (behaviorSubject is IButton)
                return behaviorSubject.button_internal::initTargetAsset(behaviorTarget);
            else
                return behaviorSubject;
        }

        private function disposeBehavior() : void
        {
            if (behavior)
                behavior.stop();
            behavior = null;
        }
    }
}
