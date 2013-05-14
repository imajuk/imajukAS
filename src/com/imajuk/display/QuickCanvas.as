package com.imajuk.display
{
    import com.imajuk.tle.TextLineFactory;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.engine.FontDescription;

    /**
     * @author imajuk
     */
    public class QuickCanvas
    {
        private var timeline : Sprite;
        private var cursor : Point = new Point();
        private var sx : int;
        private var sy : int;
        private var last : DisplayObject;
        private var range : int = -1;
        private var led : Number = 1.3;
        private var tle : Boolean;

        public static function base(timeline : Sprite) : QuickCanvas
        {
            return new QuickCanvas(timeline);
        }

        public function QuickCanvas(timeline : Sprite)
        {
            this.timeline = timeline;
        }

        /**
         * @param target    DisplayObjectまたはDisplayObjectを要素にもつコレクションまたは文字列
         *                  文字列の場合はTextFieldまたはTextLineを生成する
         */
        public function add(target : *) : QuickCanvas
        {
            if (target is DisplayObject)
            {
                last = DisplayObject(target);
                last.x = cursor.x;
                last.y = cursor.y;
                timeline.addChild(last);
                cursor.x += last.width;
            }
            else if (target is Array)
            {
                target.forEach(function(d : DisplayObject, ...param) : void
                {
                    last = d;
                    d.x = cursor.x;
                    d.y = cursor.y;
                    cursor.x += d.width;
                    if (range > 0)
                        if (cursor.x - sx >= range)
                        {
                            br();
                        }
                    timeline.addChild(d);
                });
            }
            return this;
        }

        /**
         * 改行
         */
        public function br(offset:Number=0) : QuickCanvas
        {
            cursor.x = sx;
            if (last)
                cursor.y += last.height * led;
            cursor.y += offset;
            return this;
        }

        public function move(x : int, y : int) : QuickCanvas
        {
            sx = x;
            sy = y;
            cursor = new Point(x, y);
            last = null;
            return this;
        }

        public function space(value : int) : QuickCanvas
        {
            cursor.x += value;
            return this;
        }

        public function box(width : int) : QuickCanvas
        {
            br();
            range = width;
            return this;
        }

        /**
         * @param value パーセント
         */
        public function leading(value : Number) : QuickCanvas
        {
            led = value;
            return this;
        }

        public function end() : QuickCanvas
        {
            range = -1;
            return this;
        }

        public function useTLE() : QuickCanvas
        {
            tle = true;
            return this;
        }

        public function text(
                            fontDescription : FontDescription, 
                            size : Number, 
                            text : String, 
                            kerning : Number = 0, 
                            fontColor : uint = 0xFFFFFF, 
                            justify : Boolean = true
                        ) : QuickCanvas
        {
            if (range == -1)
                throw new Error("text() can't use without call box()");

            if (tle)
                add(TextLineFactory.createTextLines(range, fontDescription, size, text, kerning, fontColor, justify));
            else
                trace("TextField未実装. useTLE()でTLEをしていすること");
            return this;
        }

        public function fillTextBox(
                            boxWidth : int, 
                            boxHeight : int, 
                            font:FontDescription, 
                            text : String, 
                            kerning : Number = 0,
                            fontColor : uint = 0xFFFFFF, 
                            justify : Boolean = true,
                            debug:Boolean = false
                        ) : QuickCanvas
        {
        	//debug
        	if (debug)
        	{
            	timeline.graphics.clear();
            	timeline.graphics.lineStyle(1, 0x00ff00);
            	timeline.graphics.drawRect(145, 35, boxWidth, boxHeight);
            	timeline.graphics.endFill();
        	}
        	box(boxWidth);
            add(
                TextLineFactory.createFillText(
                    new Rectangle(cursor.x, cursor.y, boxWidth, boxHeight), 
                    font, text, kerning, led, fontColor, justify)
                );
            end();
            return this;
        }

        public function base(timeline : Sprite) : QuickCanvas
        {
        	this.timeline = timeline;
            return this;
        }
    }
}
