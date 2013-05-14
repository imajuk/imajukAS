package com.imajuk.ui.window 
{
    import flash.display.Graphics;

    import com.imajuk.ui.scroll.view.NullArrow;

    /**
     * @author shinyamaharu
     */
    public class SampleArrow extends NullArrow
    {
        public function SampleArrow() 
        {
            buttonMode = true;
            externalHeight = 10;
        }

        override public function set externalHeight(value : int) : void
        {
            _size = value;
        	
            var g : Graphics = graphics;
            g.clear();
            g.beginFill(0, .8);
            g.drawCircle(0, 0, _size * .5);
        }
    }
}
