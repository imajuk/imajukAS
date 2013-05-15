package com.imajuk.sounds
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    /**
     * @author imajuk
     */
    public class SoundNormalizerEvent extends Event
    {
        public static const COMPLETE : String = "COMPLETE";

        private var _soundBinary : ByteArray;
        public function get soundBinary() : ByteArray
        {
            return _soundBinary;
        }

        public function SoundNormalizerEvent(type : String, soundBinary : ByteArray)
        {
            super(type);
            _soundBinary = soundBinary;
        }

    }
}
