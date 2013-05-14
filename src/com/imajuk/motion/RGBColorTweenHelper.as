package com.imajuk.motion 
{
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject;

    import fl.motion.Color;
    /**
     * @author shin.yamaharu
     */
    public class RGBColorTweenHelper implements ITweenHelper
    {
        private var target:DisplayObject;
        private var from:uint;
        private var to:uint;
        private var _amount:Number;

        public function RGBColorTweenHelper(
                                    target:DisplayObject,
                                    to:uint,
                                    from:uint,
                                    amount:Number = 0) 
        {
            this.target = target;
            this.to = to;
            this.from = from;
            _amount = amount;
        }

        public function get amount():Number
        {
            return _amount;
        }

        public function set amount(value:Number):void
        {
            var ct:ColorTransform = new ColorTransform();
            ct.color = Color.interpolateColor(from, to, value);
            target.transform.colorTransform = ct;
            _amount = value;
        }
    }
}
