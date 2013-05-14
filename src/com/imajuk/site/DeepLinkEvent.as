package com.imajuk.site
{
    import flash.events.Event;

    /**
     * @author imajuk
     */
    public class DeepLinkEvent extends Event
    {
        public static const CHANGE_PARAMETER : String = "CHANGE_PARAMETER";
        public function DeepLinkEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
