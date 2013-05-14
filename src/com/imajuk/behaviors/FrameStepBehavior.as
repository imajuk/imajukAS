package com.imajuk.behaviors 
{
    import com.imajuk.logs.Logger;
    import com.imajuk.utils.MovieClipUtils;

    import flash.display.MovieClip;


    /**
     * @author shinyamaharu
     */
    public class FrameStepBehavior extends AbstractButtonBehavior implements IButtonBehavior 
    {
        private var _onFrame : *;
        private var _offFrame : *;
        private var _stepTarget : *;

        public function FrameStepBehavior(
                                onFrame : *,
                                offFrame : * = 1,
                                stepTarget : * = null
                            ) 
        {
            super();

            _onFrame = onFrame;
            _offFrame = offFrame;
            _stepTarget = stepTarget;
        }
        
        override public function initialize(behaviorSubject:*, amount:Number) : IButtonBehavior
        {
            _target = resolveTarget(behaviorSubject, _stepTarget);

            var mc:MovieClip = _target as MovieClip,
                diff:int = _onFrame-_offFrame;
            if (!mc)
                Logger.warning(_target.name + "はMovieClipではありません.");
                
            mc.gotoAndStop(_offFrame + int(diff*amount));
            
            proxy = _target;
            onObj  = {_frame:MovieClipUtils.getFrameFromLabel(mc, _onFrame)  || int(_onFrame)};
            offObj = {_frame:MovieClipUtils.getFrameFromLabel(mc, _offFrame) || int(_offFrame)};
            
            return this;
        }
        
        public static function create(
                                    onFrame : *,
                                    offFrame : * = 1,
                                    target : * = null
                                ) : IButtonBehavior
        {
            return new FrameStepBehavior(onFrame, offFrame, target);
        }
        
        override public function clone() : IButtonBehavior
        {
            return new FrameStepBehavior(_onFrame, _offFrame, _stepTarget);
        }
    }
}
