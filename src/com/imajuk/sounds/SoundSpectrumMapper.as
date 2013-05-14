package com.imajuk.sounds
{
    import flash.utils.ByteArray;
    /**
     * @author imajuk
     */
    public class SoundSpectrumMapper
    {
        private static const SOUND_SPECTRUM_LEFT_CHANNEL_RANGE : int = 255;
        
        private var spectrumWatcher : SoundSpectrumWatcher;
        private var left_channel_output_range_min : uint;
        private var left_channel_output_range_max : uint;
        
        public var spectrum_partition : uint;
        
        
        private var _minimam_watch_spectrum : uint;
        public function get minimam_watch_spectrum() : uint
        {
            return _minimam_watch_spectrum;
        }
        public function set minimam_watch_spectrum(value : uint) : void
        {
            _minimam_watch_spectrum       = value;
            left_channel_output_range_min = value / 11008 * SOUND_SPECTRUM_LEFT_CHANNEL_RANGE;
        }


        private var _maximum_watch_spectrum : uint;
        public function get maximum_watch_spectrum() : uint
        {
            return _maximum_watch_spectrum;
        }

        public function set maximum_watch_spectrum(value : uint) : void
        {
            _maximum_watch_spectrum       = value;
            left_channel_output_range_max = value / 11008 * SOUND_SPECTRUM_LEFT_CHANNEL_RANGE;
        }        
        
        
        private var _onSound : Function;
        public function get onSound() : Function
        {
            return _onSound;
        }
        public function set onSound(f:Function) : void
        {
            _onSound = f;
        }


        private var _onSoundStop : Function;
        public function get onSoundStop() : Function
        {
            return _onSoundStop;
        }
        public function set onSoundStop(f:Function) : void
        {
            _onSoundStop = f;
        }
        
        public function get FFT_mode() : Boolean
        {
            return spectrumWatcher.FFT_mode;
        }
        public function set FFT_mode(value:Boolean) : void
        {
            spectrumWatcher.FFT_mode = value;
        }
        


        public function SoundSpectrumMapper (
                            spectrum_partition     : uint = 6, 
                            minimam_watch_spectrum : uint = 0, 
                            maximum_watch_spectrum : uint = 11008, 
                            FFT_mode               : Boolean = true
                        )
        {
            this.spectrumWatcher        = new SoundSpectrumWatcher(FFT_mode);
            this.spectrum_partition     = spectrum_partition;
            this.minimam_watch_spectrum = minimam_watch_spectrum;
            this.maximum_watch_spectrum = maximum_watch_spectrum;
        }
        
        public function map() : Vector.<Number>
        {
            const 
                  bytes : ByteArray       = spectrumWatcher.spectrum,
                 result : Vector.<Number> = new Vector.<Number>(spectrum_partition + 1, true),
                      b : Boolean         = _onSound is Function,
                     b2 : Boolean         = _onSoundStop is Function,
                    fft : Boolean         = spectrumWatcher.FFT_mode,
              clipWidth : int             = left_channel_output_range_max-left_channel_output_range_min;
                
            var        v : Number,      //spectrum (-1 ~ 1) or FFTmode(0 ~ 1.141421356)
                     idx : int,         //index of spectrum partition (0 ~ spectrum_partition)
                     sum : Number = 0,
                       i : int,
                       j : int,
                writeIdx : int, 
                   lastV : Number = 0,
                   delta : Number,
                linerMlt : Number,
                    diff : Number;

            
            for (i = 0; i <= SOUND_SPECTRUM_LEFT_CHANNEL_RANGE; i++) 
            {
                v = bytes.readFloat();
                if (b) sum += v < 0 ? -v : v;
                if (i >= left_channel_output_range_min && i <= left_channel_output_range_max)
                {
                    idx = (i - left_channel_output_range_min) / clipWidth * spectrum_partition;
                    
                    if (fft) v /= 1.41421356;
                               
                        
                    for (       j = writeIdx,
                            delta = (idx == writeIdx) ? 1 : 1 / (idx - writeIdx + 1),
                         linerMlt = delta,
                             diff = v - lastV; 
                             
                               j <= idx; 
                               j++, linerMlt += delta
                         )
                    {
                        result[j] = lastV + diff * linerMlt;
                    }
                        
                    writeIdx = idx+1;
                    lastV = v;
                }
            }
            
            if (b) _onSound(sum / SOUND_SPECTRUM_LEFT_CHANNEL_RANGE);
            if (b2 && sum==0) _onSoundStop();
            
            
            return result;
        }

    }
}
