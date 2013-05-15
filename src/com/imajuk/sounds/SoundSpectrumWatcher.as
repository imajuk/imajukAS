package com.imajuk.sounds
{
    import org.si.utils.FFT;
    import flash.events.SampleDataEvent;
    import flash.media.Microphone;
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
        private static var mic : Microphone;
        private static var inputBuffer : ByteArray;
        
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
            var bytes : ByteArray;

            if (mic)
            {
                if (inputBuffer)
                {
                    if (FFT_mode)
                    {
                        bytes = new ByteArray();
                        
                        const      fft : FFT = new FFT(2048),
                                source : Vector.<Number> = new Vector.<Number>(2048, true),
                                result : Vector.<Number> = new Vector.<Number>(2048, true);
                                
                        var i : int, j:int, l:int, n : Number;
                        
                        inputBuffer.length = 8192;
                        inputBuffer.position = 0;
                        
                        while(inputBuffer.position < inputBuffer.length)
                        {
                            source[i++] = inputBuffer.readFloat();
                            source[i++] = inputBuffer.readFloat();
                        }
                            
                        fft.setData(source);                // set source data
                        fft.calcFFT().scale(1/20);          // calculate FFT
                        fft.getData(result);                // recieve combinated result by vector
                        
                                            
                        for (j = 0, l = result.length; j < l; j++)
                        {
                            n = result[j];
                            n = n < 0 ? -n : n;
                            bytes.writeFloat(n);
                        }
                        bytes.position = 0;
                    }
                    else
                    {
                        bytes = inputBuffer;
                    }
                    
                }
                else
                {
                    empty.position = 0;
                    bytes = empty;
                }
            }
            else
            {
                bytes = new ByteArray();
                try
                {
                    SoundMixer.computeSpectrum(bytes, FFT_mode, stretchFactor);
                }
                catch(e : Error)
                {
                    empty.position = 0;
                    bytes = empty;
                }
            }
            return bytes;
        }

        public static function watchMicrophone(microphone:Microphone) : void
        {
            mic = microphone;
            mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
        }

        public static function unwatchMicrophone() : void
        {
            if (mic)
                mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
            mic = null;
        }

        private static function micSampleDataHandler(event : SampleDataEvent) : void
        {
            inputBuffer = event.data;
        }
    }
}