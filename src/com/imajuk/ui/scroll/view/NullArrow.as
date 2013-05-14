package com.imajuk.ui.scroll.view 
{
    import com.imajuk.ui.IUIView;

    import flash.display.Sprite;

    /**
     * @author shinyamaharu
     */
    public class NullArrow extends Sprite implements IUIView
    {
        protected var _size : int;

        public function NullArrow()
        {
        }

        public function get externalHeight() : int
        {
            return _size;
        }

        public function set externalHeight(value : int) : void
        {
            _size = value;
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
            return 0;
        }
        
        public function set externalWidth(value : int) : void
        {
        }
        
        public function get actualHeight() : int
        {
            return _size;
        }
        
        public function set actualHeight(value : int) : void
        {
        	_size = value;
        }
    }
}
