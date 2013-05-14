package com.imajuk.ui.scroll.view 
{
	import flash.filters.DropShadowFilter;
	import flash.display.Sprite;
    import com.imajuk.ui.IUIView;

    import flash.display.Graphics;
    import flash.display.CapsStyle;
    import flash.display.LineScaleMode;

    /**
     * This is ScrollBar's view.
     * 
     * UIScrollBar has two elements of view - Bar and BarBG.
     * 
     * if you would like to custum this,
     * you have to override buildView() method.
     * 
     * @author shin.yamaharu
     */
    public class BarBG extends Sprite implements IUIView    {
        private var thicness : int;

        public function BarBG() 
        {
        	buttonMode = true;
            filters = [new DropShadowFilter(1, 45, 0, .2, 3, 3, 1, 1, true)];
        	thicness = 8;
        }

        public function get externalHeight() : int
        {            return height;
        }

        public function set externalHeight(value : int) : void
        {
            var g : Graphics = graphics;
            g.clear();
            g.lineStyle(thicness, 0xf7f3ee, .5, false, LineScaleMode.NONE, CapsStyle.ROUND);
            g.moveTo(0, thicness * .5);
            g.lineTo(0, value - thicness * .5);
        }
        
        public function set externalWidth(value : int) : void
        {
            var g : Graphics = graphics;
            g.clear();
            g.lineStyle(thicness, 0xf7f3ee, .5, false, LineScaleMode.NONE, CapsStyle.ROUND);
            g.moveTo(thicness * .5, 0);
            g.lineTo(value - thicness * .5, 0);
        }

        public function get externalX() : int
        {
            return x;
        }
        
        public function get externalY() : int
        {
            return y;
        }
        
        public function get externalWidth() : int
        {
            return 8;
        }
        
        public function get actualHeight() : int
        {
            return height;
        }
        
        public function set actualHeight(value : int) : void
        {
        	externalHeight = value;
        }
    }
}
