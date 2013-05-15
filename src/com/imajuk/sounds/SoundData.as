package com.imajuk.sounds
{
    import flash.utils.ByteArray;
    /**
     * @author imajuk
     */
    public class SoundData
    {
        internal var _binary : ByteArray;
        public function get binary() : ByteArray
        {
            return _binary;
        }

        internal var _url : String;
        public function get url() : String
        {
            return _url;
        }

        internal var _soundDuration : uint;
        public function get soundDuration() : uint
        {
            return _soundDuration;
        }
    }
}
