package com.imajuk.sounds.spectrum
{
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;

    /**
     * @author imajuk
     */
    public class BasicSoundSpectrumView extends Sprite
    {
        internal var display_width : uint = 300;
        internal var display_height : uint = 300;
        internal var ui : BasicSoundSpectrumUI;
        internal var FFT_mode : Boolean;
        internal var debug : Boolean;
        
        private var spectrum_color : uint = 0x00FF00;
        private var g : Graphics;
        private var display : Graphics;
        private var color_bg : uint;
        private var grid_partition : uint = 5;
        private var grid_color : uint = 0x333333;

        public function BasicSoundSpectrumView(FFT_mode:Boolean)
        {
            g = graphics;
            
            this.FFT_mode = FFT_mode;

            clear();
            drawBackground();
            drawGrid();
            updateSpectrumLabel();
            buildDisplay();
            buildUI();
        }

        private function updateSpectrumLabel() : void
        {
            
        }

        private function buildDisplay() : void
        {
            const s:Shape = addChild(new Shape()) as Shape;
            s.y = display_height;
            display = s.graphics;
        }

        private function clear() : void
        {
            g.clear();
        }

        private function drawBackground() : void
        {
            g.beginFill(color_bg, 1);
            g.drawRect(0, 0, display_width, display_height);
            g.endFill();
        }

        private function drawGrid() : void
        {
            g.lineStyle(1, grid_color);
            const delta : Number = display_width / grid_partition;
            for (var i : uint = 1; i < grid_partition; i++)
            {
                g.moveTo(delta * i, 0);
                g.lineTo(delta * i, display_height);
            }
        }

        private function buildUI() : void
        {
            ui = addChild(new BasicSoundSpectrumUI(display_width, display_height)) as BasicSoundSpectrumUI;
        }

        public function update(spectrum : Vector.<Number>) : void
        {
            display.clear();
            display.lineStyle(1, spectrum_color);
            
            const delta:Number = display_width / (spectrum.length-1);
            for (var     i : int = 0, 
                         l : int = spectrum.length, 
                     value : Number, 
                        lx : int,
                     lastX : int, 
                     lastY : int; 
                    
                         i < l; 
                    
                         i++, lx = i * delta)
            {
                value = spectrum[i];
                
                
                if (FFT_mode)
                    value *= -display_height;
                else
                    value = value * display_height/2 - display_height/2;
                
                
                if (i == 0)
                    display.moveTo(lx, value);
                else
                    for (var j : int = lastX+1,
                             k : int,
                             d : Number = 1/(lx-lastX); 
                            
                            j <= lx; 
                            j++, k++)
                    {
                        display.lineTo(j, lastY + (value - lastY) * d * (j - lastX));
                    }
                    
                    
                lastX = lx;
                lastY = value;
            }
        }


    }
}
