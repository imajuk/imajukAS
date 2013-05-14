package com.imajuk.sounds.spectrum
{
    import flash.events.Event;

    /**
     * @author imajuk
     */
    public class SpectrumViewEvent extends Event
    {
        public static const CHANGE_SPECTRUM_PARTITION : String = "CHANGE_SPECTRUM_PARTITION";
        public static const CHANGE_SPECTRUM_RANGE : String = "CHANGE_SPECTRUM_RANGE";
        public static const CHANGE_FFT_MODE : String = "CHANGE_FFT_MODE";
        
        public function SpectrumViewEvent(type : String)
        {
            super(type, true);
        }
    }
}
