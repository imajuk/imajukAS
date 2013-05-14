package com.imajuk.sounds.spectrum
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.logs.Logger;
    import com.imajuk.sounds.SoundSpectrumMapper;
    import com.imajuk.threads.ThreadUtil;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.utils.setInterval;


    /**
     * @author shinyamaharu
     */
    public class SpectrumDev extends DocumentClass
    {
        public function SpectrumDev()
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

            setInterval(function() : void
            {
                spectrumView.update(spectrumMapper.map());
                spectrumView2.update(spectrumMapper2.map());
            }, 1000 / 60);
            
            
//            new PlayUsersSongThread(10).start();
        };
    }
}
