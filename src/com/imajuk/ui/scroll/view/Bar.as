package com.imajuk.ui.scroll.view 
{
    import com.imajuk.ui.IUIView;

    import flash.filters.BevelFilter;
	import flash.display.Sprite;
    import flash.display.CapsStyle;
    import flash.display.LineScaleMode;
    import flash.display.Graphics;
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
    public class Bar extends Sprite implements IUIView    {
        private var thicness : int;

        public function Bar() 
        {
        	thicness = 5;
            buttonMode = true;
            filters = [new BevelFilter(1, 45, 0xFFFFFF, .5, 0, .3)];
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
            return 5;
        }
        public function set externalWidth(value:int):void
        {
            var g : Graphics = graphics;
            g.clear();
            g.lineStyle(thicness, 0xd9c8b4, 1, false, LineScaleMode.NONE, CapsStyle.ROUND);
            g.moveTo(thicness * .5, 0);
            g.lineTo(value - thicness * .5, 0);
        }
        
        public function get actualHeight() : int
        {
            return height;
        }
        public function set actualHeight(value : int) : void
        {
        	externalHeight = value;
        }
        
        public function get externalHeight():int
        {
            return height;
        }
        public function set externalHeight(value:int):void
        {
            var g : Graphics = graphics;
            g.clear();
            g.lineStyle(thicness, 0xd9c8b4, 1, false, LineScaleMode.NONE, CapsStyle.ROUND);
            g.moveTo(0, thicness * .5);
            g.lineTo(0, value - thicness * .5);
        }
    }
}
