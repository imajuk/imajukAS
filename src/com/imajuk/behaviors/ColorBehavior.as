package com.imajuk.behaviors
{
    import com.imajuk.color.Color;
    import com.imajuk.color.ColorTransformEffect;
    import com.imajuk.constructions.InstanceFactory;
    import com.imajuk.motion.ColorTransformTweenHelper;

    /**
     * @author imajuk
     */
    public class ColorBehavior extends AbstractButtonBehavior implements IButtonBehavior
    {
        private var _colorTarget : *;
        private var _params : Array;
        private var _mode : String;
        
        public function ColorBehavior(
                            mode : String,
                            colorTarget : * = null,
                            ...params
                        )
        {
            super();

            _mode = mode;
            _colorTarget = colorTarget;
            _params = params;
        }

        override public function clone() : IButtonBehavior
        {
            return InstanceFactory.newInstance(
                        ColorBehavior, 
                        [_mode, _colorTarget].concat(_params)
                   ) as ColorBehavior;
        }
        
        override public function initialize(behaviorSubject:*, amount:Number) : IButtonBehavior
        {
            _target = resolveTarget(behaviorSubject, _colorTarget);
            proxy   = prepareProxy(amount);
            onObj   = {amount:1};
            offObj  = {amount:0};
            
            return this;
        }

        public static function createTint(
                                    onColor : Color, 
                                    onAmount : Number = 1, 
                                    colorTarget : * = null, 
                                    offColor : Color = null, 
                                    offAmount : Number = 0
                               ) : IButtonBehavior
                                    
        {
            return new ColorBehavior(
                        ColorTransformEffect.TINT, 
                        colorTarget, 
                        onColor, 
                        onAmount, 
                        offColor, 
                        offAmount
                    );
        }

        override public function dispose() : void
        {
            super.dispose();
            
            proxy.dispose();
            proxy = null;
            _colorTarget = null;
            _params = null;
        }

        private function prepareProxy(amount:Number) : ColorTransformTweenHelper
        {
//            var amount : Number = (proxy) ? proxy.amount : 0;
            return ColorTransformTweenHelper.create.apply(null, [_mode, _target, amount].concat(_params));
        }
        
        public function set onColor(value : Color) : void
        {
            proxy.toColor = value;
        }

        public function set offColor(value : Color) : void
        {
            proxy.fromColor = value;
        }

    }
}
