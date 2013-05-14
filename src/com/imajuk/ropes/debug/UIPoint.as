package com.imajuk.ropes.debug
{
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    /**
     * @author imajuk
     */
    public class UIPoint extends Sprite
    {
        public var p : Point;
        private var color : int;
        private var size : Number;

        public function UIPoint(p : Point, color : int = 0x6984D6, draggable : Boolean = true, size : Number = 4, displayInfo:Boolean = false)
        {
            this.size = size;
            this.color = color;
            this.p = p;

            this.draggable = draggable;

            if (displayInfo)
            {
                var tfm : TextFormat = new TextFormat();
                tfm.color = color;
                tfm.size = 11;
                var tf : TextField = addChild(new TextField()) as TextField;
                tf.autoSize = TextFieldAutoSize.LEFT;
                tf.text = p.toString();
                tf.setTextFormat(tfm);
            }

            draw();
            update();
        }

        private var _draggable : Boolean;

        public function get draggable() : Boolean
        {
            return _draggable;
        }

        public function set draggable(value : Boolean) : void
        {
            _draggable = value;

            buttonMode = value;

            if (value)
            {
                addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
                addEventListener(MouseEvent.MOUSE_UP, upHandler);
                addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
            }
            else
            {
                removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
                removeEventListener(MouseEvent.MOUSE_UP, upHandler);
                removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
            }
        }

        private function moveHandler(event : MouseEvent) : void
        {
            p.x = x;
            p.y = y;
        }

        private function downHandler(event : MouseEvent) : void
        {
            startDrag();
        }

        private function upHandler(event : MouseEvent) : void
        {
            stopDrag();
        }

        public function update() : void
        {
            x = p.x;
            y = p.y;
        }

        private function draw() : void
        {
            var g : Graphics = graphics;
            g.clear();
            g.beginFill(color);
            g.drawCircle(0, 0, size);
        }
    }
}
