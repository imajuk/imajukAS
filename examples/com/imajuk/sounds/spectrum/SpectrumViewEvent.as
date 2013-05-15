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
        public static const CHANGE_MIC_MODE : String = "CHANGE_MIC_MODE";
        public static const CHANGE_STRETCH_FACTOR : String = "CHANGE_STRETCH_FACTOR";
        
        public function SpectrumViewEvent(type : String)
        {
            super(type, true);
        }
    }
}
