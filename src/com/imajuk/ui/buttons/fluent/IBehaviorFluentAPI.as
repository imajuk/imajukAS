package com.imajuk.ui.buttons.fluent
{
    import com.imajuk.behaviors.IButtonBehavior;
    import com.imajuk.ui.buttons.IButton;
    import flash.media.Sound;

    /**
     * @author imajuk
     */
    public interface IBehaviorFluentAPI
    {
        function context(contextType : String) : IButton;
        function behave(behavior : IButtonBehavior) : IButton;
        function sound(sound : Sound) : IButton;
    }
}
