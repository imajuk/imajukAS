package com.imajuk.animations 
{
    import flash.display.PixelSnapping;    
    import flash.display.BitmapData;    
    import flash.display.Bitmap;

    /**
     * @author yamaharu
     */
    public class AvoidChara extends Bitmap 
    {
        private var _id:uint;

        public function AvoidChara(bitmapData:BitmapData, id:uint)
        {
            super(bitmapData, PixelSnapping.NEVER, false);
            _id = id;
        }

        override public function toString():String 
        {
            return "AvoidChara[" + id + "]";
        }

        public function get id():uint
        {
            return _id;
        }
    }
}
