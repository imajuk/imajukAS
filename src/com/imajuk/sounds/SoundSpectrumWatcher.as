package com.imajuk.sounds
{
    import flash.media.SoundMixer;
    import flash.utils.ByteArray;

    /**
     * @author imajuk
     */
    public class SoundSpectrumWatcher
    {
        public static const KHz_44_1   : int = 0;
        public static const KHz_22_05  : int = 1;
        public static const KHz_11_025 : int = 2;
        public static var stretchFactor : int = KHz_44_1;
        
        public var FFT_mode : Boolean;
        
        private var empty : ByteArray;

        
        public function SoundSpectrumWatcher(FFT_mode : Boolean = true)
        {
            this.FFT_mode = FFT_mode;
            
            empty = new ByteArray();
            for (var i : int = 0; i < 512; i++)
            {
                empty.writeFloat(0);
            }
        }

        public function get spectrum() : ByteArray
        {
            var bytes : ByteArray = new ByteArray();

            try
            {
                SoundMixer.computeSpectrum(bytes, FFT_mode, stretchFactor);
            }
            catch(e : Error)
            {
                empty.position = 0;
                bytes = empty;
            }
            
            return bytes;
        }
    }
}