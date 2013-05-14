package com.imajuk.ui.scroll.view 
{
    import com.imajuk.ui.scroll.IScrollContainerMask;

    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    /**
     * @author imajuk
     */
    public class ScrollMask extends Sprite implements IScrollContainerMask 
    {
        protected var _mask:DisplayObject;
        private var _bmp:Bitmap;
        private var maskUpdate:Function;
        protected var _rectangle : Rectangle;

		/**
		 * @param rectangle	IScrollContainerの座標系でのマスク領域です
		 */
        public function ScrollMask(rectangle:Rectangle, debug:Boolean = false) 
        {
            _rectangle = rectangle;
            mouseEnabled = false;        	mouseChildren = false;
        	
        	//デバッグモードならマスクビットマップに色を付ける
        	var debugColor:uint = (debug) ? Math.random() * 0xFFFFFF + 0x22000000 : 0;
        	
            var createMaskBD : Function = 
                function():BitmapData
                {
                	return debug ? 
                	   new BitmapData(rectangle.width, rectangle.height, true, debugColor) : 
                	   new BitmapData(rectangle.width, rectangle.height);
                };
        	
            maskUpdate = function():void
            {                _bmp.bitmapData = createMaskBD();
            };
        	
        	_bmp = new Bitmap(createMaskBD());
            _mask = addChild(_bmp);
            
            x = rectangle.x;
            y = rectangle.y;
            
            maskUpdate();
        }

        public function get rectangle() : Rectangle
        {
            return _rectangle;
        }
        
        /**
         * マスクの幅
         * コンボボックスの描画範囲となる
         */
        public function get maskWidth():int
        {
            return _mask.width;
        }

        public function set maskWidth(value:int):void
        {
            _mask.width = value;
            _rectangle.width = value;
        }
        
        /**
         * マスクの高さ
         * コンボボックスの描画範囲となる
         */
        public function get maskHeight():int
        {
            return _mask.height;
        }

        public function set maskHeight(value:int):void
        {
            _mask.height = value;
            _rectangle.height = value;
        }
    }
}
