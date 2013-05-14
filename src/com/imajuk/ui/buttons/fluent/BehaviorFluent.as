package com.imajuk.ui.buttons.fluent
{
    import com.imajuk.behaviors.IButtonBehavior;
    import com.imajuk.ui.buttons.AbstractButton;
    import com.imajuk.ui.buttons.IButton;
    import com.imajuk.ui.buttons.button_internal;
    import flash.media.Sound;

    /**
     * @author imajuk
     */
    public class BehaviorFluent implements IBehaviorFluentAPI
    {
        private var _contextType : String;
        private var _button : AbstractButton;

        public function BehaviorFluent(button : AbstractButton)
        {
            _button = button;
        }


        public function context(contextType : String) : IButton
        {
            _contextType = contextType;
            
            return _button;
        }

        public function behave(behavior : IButtonBehavior) : IButton
        {
            behavior = behavior.clone();
            AbstractButton(_button).button_internal::applyBehaviorToContext(behavior, _contextType);
            behavior.initialize(_button, 0);
            _button.start();

            return _button;
        }

        public function sound(sound : Sound) : IButton
        {
            AbstractButton(_button).button_internal::applySoundToContext(sound, _contextType);
            return _button;
        }
    }
}
