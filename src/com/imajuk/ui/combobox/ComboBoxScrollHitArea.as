package com.imajuk.ui.combobox 
{
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    /**
     * @author shin.yamaharu
     */
    public class ComboBoxScrollHitArea extends Sprite 
    {
        private var top:Bitmap;
        private var bottom:Bitmap;
        private var _hitAreaHeight:int = 25;
        private var debug : Boolean;

        public function ComboBoxScrollHitArea(debug:Boolean = false)
        {
            this.debug       = debug;
            this.top         = addChild(new Bitmap()) as Bitmap;            this.top.name    = "_top_";            this.bottom      = addChild(new Bitmap()) as Bitmap;
            this.bottom.name = "_bottom_";
            
            this.mouseEnabled = false;
            this.mouseChildren = false;
        }

        public function updateSize(w:int, h:int):void
        {
            top.bitmapData    = createHitArea(w);
            bottom.bitmapData = createHitArea(w);
            bottom.y          = h - _hitAreaHeight;
        }

        private function createHitArea(w:int):BitmapData
        {
            return new BitmapData(w, _hitAreaHeight, true, debug ? 0x4400FF00 : 0);
        }
    }
}
