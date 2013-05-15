package com.imajuk.sounds.spectrum
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.logs.Logger;
    import com.imajuk.sounds.SoundSpectrumMapper;
    import com.imajuk.sounds.SoundSpectrumWatcher;
    import com.imajuk.threads.ThreadUtil;

    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.events.Event;
    import flash.media.Microphone;


    /**
     * @author shinyamaharu
     */
    [SWF(backgroundColor="#FFFFFF", frameRate="60", width="640", height="480")]
    public class SpectrumExample extends DocumentClass
    {
        public function SpectrumExample()
        {
            super(StageQuality.HIGH, StageAlign.TOP_LEFT);
            
            ThreadUtil.initAsEnterFrame();
            Logger.show(Logger.INFO);
        }

        override protected function start() : void
        {
            const       FFT_mode : Boolean = true,
                    spectrumView : BasicSoundSpectrumView = addChild(new BasicSoundSpectrumView(FFT_mode)) as BasicSoundSpectrumView,
                   spectrumView2 : BasicSoundSpectrumView = addChild(new BasicSoundSpectrumView(FFT_mode)) as BasicSoundSpectrumView,
                          clipUI : SpectrumClipUI = addChild(new SpectrumClipUI()) as SpectrumClipUI,
                  spectrumMapper : SoundSpectrumMapper = new SoundSpectrumMapper(255, 0, 11008, FFT_mode),
                 spectrumMapper2 : SoundSpectrumMapper = new SoundSpectrumMapper(clipUI.spectrum_partition.value, 0, 11008, FFT_mode);
                        
            spectrumView.x = 30;
            spectrumView.y = 30;
            spectrumView2.x = 360;
            spectrumView2.y = 30;
            clipUI.x = 30;
            clipUI.y = 30;
            
            clipUI.addEventListener(SpectrumViewEvent.CHANGE_SPECTRUM_PARTITION, function() : void
            {
                spectrumMapper2.spectrum_partition = clipUI.spectrum_partition.value;
            });
            clipUI.addEventListener(SpectrumViewEvent.CHANGE_FFT_MODE, function() : void
            {
                spectrumView.FFT_mode = clipUI.fftmode.selected;
                spectrumView2.FFT_mode = clipUI.fftmode.selected;
                spectrumMapper.FFT_mode = clipUI.fftmode.selected;
                spectrumMapper2.FFT_mode = clipUI.fftmode.selected;
            });
            clipUI.addEventListener(SpectrumViewEvent.CHANGE_SPECTRUM_RANGE, function() : void
            {
                spectrumMapper2.minimam_watch_spectrum = clipUI.spectrumRange.lowValue;
                spectrumMapper2.maximum_watch_spectrum = clipUI.spectrumRange.highValue;
                spectrumView2.ui.updateLabels(clipUI.spectrumRange.lowValue, clipUI.spectrumRange.highValue);
            });
            clipUI.addEventListener(SpectrumViewEvent.CHANGE_STRETCH_FACTOR, function() : void
            {
                SoundSpectrumWatcher.stretchFactor = clipUI.samplingRate.selectedItem.value;
            });
            clipUI.addEventListener(SpectrumViewEvent.CHANGE_MIC_MODE, function() : void
            {
                //--------------------------------------------------------------------------
                //  For a recording process, all you need to do is just call SoundSpectrumWatcher.watchMicrophone()
                //  my wave will move along with the input of microphone instead of SoundMixier.
                //  call SoundSpectrumWatcher.unwatchMicrophone() if the recording finished.
                //
                //  Here's the example how to link my wave to a microphone. (comment out for use.)
                //--------------------------------------------------------------------------
                if (clipUI.mic.selected)
                {
                    var m:Microphone = Microphone.getEnhancedMicrophone();
                        m.rate = 11;
                        m.setSilenceLevel(0);
                        m.setLoopBack(false);
                        
                    SoundSpectrumWatcher.watchMicrophone(m);
                }
                else
                {
                    SoundSpectrumWatcher.unwatchMicrophone();
                }
            });

            addEventListener(Event.ENTER_FRAME, function() : void
            {
                spectrumView.update(spectrumMapper.map());
                spectrumView2.update(spectrumMapper2.map());
            });
        };
    }
}
