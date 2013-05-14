package com.imajuk.behaviors
{
    /**
     * @author imajuk
     */
    public class TransparentBehavior extends AbstractButtonBehavior implements IButtonBehavior
    {
        private var _onAlpha : Number;
        private var _offAlpha : Number;
        private var _alphaTarget : Object;

        public function TransparentBehavior(
                            onAlpha:Number = .5,
                            offAlpha:Number = 1,
                            alphaTarget:Object = null
                            
                        )
        {
            super();
            
            _onAlpha = onAlpha;
            _offAlpha = offAlpha;
            _alphaTarget = alphaTarget;
        }
        
        public static function create(
                            onAlpha:Number = .5,
                            offAlpha:Number = 1,
                            alphaTarget:Object = null
                        ) : IButtonBehavior
        {
            return new TransparentBehavior(onAlpha, offAlpha, alphaTarget);
        }
        
        override public function clone() : IButtonBehavior
        {
            return new TransparentBehavior(_onAlpha, _offAlpha, _alphaTarget);
        }
        
        override public function initialize(behaviorSubject:*, amount:Number) : IButtonBehavior
        {
            _target = resolveTarget(behaviorSubject, _alphaTarget);
//            _target.alpha = amount;
            
            proxy = _target;
            onObj = {alpha:_onAlpha};
            offObj = {alpha:_offAlpha};
            
            return this;
        }
    }
}
