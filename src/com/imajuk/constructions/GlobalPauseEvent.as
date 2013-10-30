package com.imajuk.constructions
{
    import flash.events.Event;

    /**
     * @author imajuk
     */
    public class GlobalPauseEvent extends Event
    {
        public static const PAUSE : String = "PAUSE";
        public static const RESUME : String = "RESUME";
        
        public function GlobalPauseEvent(type : String)
        {
            super(type, true, false);
        }
    }
}
