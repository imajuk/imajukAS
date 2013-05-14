package com.imajuk.sounds.spectrum
{
    import com.bit101.components.Label;

    import flash.display.Sprite;

    /**
     * @author imajuk
     */
    public class BasicSoundSpectrumUI extends Sprite
    {
        private var label : Array;
        private var display_width : int;
        private var display_height : int;

        public function BasicSoundSpectrumUI(display_width : int, display_height : int)
        {
            this.display_height = display_height;
            this.display_width = display_width;
            build();
            updateLabels(0, 11008);
        }

        internal function updateLabels(min:Number, max : Number) : void
        {
            var n:Number = 0;
            label.forEach(function(label : Label, ...param) : void
            {
                label.text = ((min + max * n) / 1000).toFixed(2) + "KHz";
                n += .25;
            });
        }

        private function build() : void
        {
            var oy:int = -20;
            
            label = [
                new Label(this, 0, oy),
                new Label(this, display_width*.25, oy),
                new Label(this, display_width*.5, oy),
                new Label(this, display_width*.75, oy),
                new Label(this, display_width-20, oy)
            ];
        }
    }
}
