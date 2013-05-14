package com.imajuk.sounds.spectrum
{
    import com.bit101.components.CheckBox;
    import com.bit101.components.ComboBox;
    import com.bit101.components.HRangeSlider;
    import com.bit101.components.HUISlider;
    import com.bit101.components.RangeSlider;
    import com.imajuk.sounds.SoundSpectrumWatcher;
    import flash.display.Sprite;
    import flash.events.Event;


    /**
     * @author imajuk
     */
    public class SpectrumClipUI extends Sprite
    {
        internal var spectrumRange : RangeSlider;
        internal var spectrum_partition : HUISlider;
        internal var samplingRate : ComboBox;
        internal var fftmode : CheckBox;

        public function SpectrumClipUI()
        {
            build();
        }

        private function build() : void
        {
            var oy:int = 300;
            
            spectrumRange = new HRangeSlider(this, 0, oy);
            spectrumRange.minimum = 0;
            spectrumRange.maximum = 11008;
            spectrumRange.highValue = 11008;
            spectrumRange.width = 300;
            spectrumRange.labelPosition = RangeSlider.BOTTOM;
            spectrumRange.addEventListener(Event.CHANGE, function() : void
            {
                dispatchEvent(new SpectrumViewEvent(SpectrumViewEvent.CHANGE_SPECTRUM_RANGE));
            });
            
            
            spectrum_partition = new HUISlider(this, 330, oy, "spectrum_partition", function() : void
            {
                dispatchEvent(new SpectrumViewEvent(SpectrumViewEvent.CHANGE_SPECTRUM_PARTITION));
            });
            spectrum_partition.minimum = 0;
            spectrum_partition.maximum = 255;
            spectrum_partition.value = 255;
            spectrum_partition.width = 350;
            
            oy = 0;
            
            samplingRate = new ComboBox(this, 700, oy, "44.1KHz", [{label:"44.1KHz", value:0}, {label:"22.05KHz", value:1}, {label:"11.025KHz", value:2}]);
            samplingRate.addEventListener(Event.SELECT, function() : void
            {
                SoundSpectrumWatcher.stretchFactor = samplingRate.selectedItem.value;
            });
            
            oy += 30;
            
            fftmode = new CheckBox(this, 700, oy, "FFT mode", function() : void
            {
                dispatchEvent(new SpectrumViewEvent(SpectrumViewEvent.CHANGE_FFT_MODE));
            });
            fftmode.selected = true;
        }
    }
}
