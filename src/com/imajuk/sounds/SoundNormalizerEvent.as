package com.imajuk.sounds
{
    import flash.events.Event;

    /**
     * @author imajuk
     */
    public class SoundNormalizerEvent extends Event
    {
        public static const COMPLETE : String = "COMPLETE";


        private var _soundData : SoundData;
        public function get soundData() : SoundData
        {
            return _soundData;
        }
        
        public function SoundNormalizerEvent(type : String, soundData : SoundData)
        {
            super(type);
            _soundData = soundData;
        }
    }
}
