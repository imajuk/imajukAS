package com.imajuk.display
{
    import flash.display.PixelSnapping;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * @author imajuk
     */
    public class Ticker extends Sprite
    {
        private var _content : DisplayObject;
        private var _visibleWidth : int;
        private var _visibleHeight : int;
        private var source : BitmapData;
        private var canvas : BitmapData;
        private var needTickerFunction : Boolean;
        private var point : Point = new Point();
        private var rect : Rectangle;
        private var rect2 : Rectangle = new Rectangle();
        private var point2 : Point = new Point();
        private var _margin : int = 10;
        private var rx : Number = 0;
        private var _speed : Number;

        public function Ticker(
                            content : DisplayObject, 
                            visibleWidth : int, 
                            visibleHeight : int, 
                            speed:Number = 1,
                            autoPlay : Boolean = false
                        )
        {
            _content = content;
            _speed = speed;
            _visibleWidth = visibleWidth;
            _visibleHeight = visibleHeight;

            needTickerFunction = content.width > visibleWidth;

            if (needTickerFunction)
                build();
            else
                addChild(_content);

            if (autoPlay)
                start();
        }

        private function build() : void
        {
            source = new BitmapData(_content.width, _content.height, true, 0);
            source.draw(_content, _content.transform.matrix, _content.transform.colorTransform, null, null, true);

            canvas = new BitmapData(_visibleWidth, _visibleHeight, true, 0);
            rect = canvas.rect.clone();
            rect2.height = canvas.height;
            
            draw();

            addChild(new Bitmap(canvas, PixelSnapping.AUTO, true));
        }

        public function start() : void
        {
            if (!needTickerFunction)
                return;

            removeEventListener(Event.ENTER_FRAME, draw);
            addEventListener(Event.ENTER_FRAME, draw);
        }

        public function stop() : void
        {
            removeEventListener(Event.ENTER_FRAME, draw);
        }

        private function draw(...param) : void
        {
            canvas.fillRect(canvas.rect, 0);

            rect.x = int(rx);
            canvas.copyPixels(source, rect, point);
            
            var right : Number = rect.x + rect.width;
            var w : int = source.width;
            if (right > w)
            {
                var diff : Number = right - w;
                rect2.width = diff;
                point2.x = canvas.width - diff + _margin;

                canvas.copyPixels(source, rect2, point2);
            }
            
            rx += _speed;
            rx %= w + _margin;
            rx = rx < _speed ? 0 : rx;
        }

        public function get margin() : int
        {
            return _margin;
        }

        public function set margin(value : int) : void
        {
            _margin = value;
        }

        public function reset() : void
        {
        	stop();
        	rx = 0;
        }

    }
}
