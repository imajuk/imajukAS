package com.imajuk.ui 
{
    import flash.display.DisplayObject;

    import com.imajuk.interfaces.IDisplayObjectWrapper;
    import flash.display.Sprite;

    /**
     * DisplayObjectをIUIViewとして扱うためのアダプター
     * @author shinyamaharu
     */
    public class IUIViewAdapter extends Sprite implements IUIView, IDisplayObjectWrapper
    {
        private var _aseet : Sprite;
        
        public function IUIViewAdapter(aseet:Sprite)
        {
            this._aseet = addChild(aseet) as Sprite;
        }

        public function get actualHeight() : int
        {
            return height;        }
        
        public function get externalHeight() : int
        {
            return height;
        }
        
        public function get externalWidth() : int
        {
            return width;
        }
        
        public function get externalY() : int
        {
            return y;
        }
        
        public function get externalX() : int
        {
            return x;
        }
        
        public function set actualHeight(value : int) : void
        {
        	height = value;        }
        
        public function set externalWidth(value : int) : void
        {
        	width = value;
        }
        
        public function set externalHeight(value : int) : void
        {
            height = value;
        }
        
        public function get asset() : DisplayObject
        {
            return _aseet;
        }
    }
}
