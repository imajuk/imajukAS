package com.imajuk.motion 
{
    import flash.utils.Dictionary;

    import flash.filters.BlurFilter;
    import flash.display.DisplayObject;
    /**
     * @author shin.yamaharu
     */
    public class BlurTweenHelper implements ITweenHelper
    {
        private static var cache:Dictionary= new Dictionary(true);
        private var blurX:Number;
        private var blurY:Number;
        private var _amount:Number;
        private var target:DisplayObject;

        public function BlurTweenHelper(target:DisplayObject, blurX:Number, blurY:Number)         
        {
            this.target = target;
            this.blurY = blurY;
            this.blurX = blurX;
            amount = 0;
        }

        public function get amount():Number
        {
            return _amount;
        }

        public function set amount(amount:Number):void
        {
            _amount = amount;
            
            var bx:Number = _amount * blurX;            var by:Number = _amount * blurY;
            var id:String = bx.toString() + "," + by.toString();
            
            var f:BlurFilter;
            if (cache[id]) 
            {
                f = cache[id];
            }
            else
            {
            	f =  new BlurFilter(bx, by);
            	cache[id] = f;
            }
            target.filters = [f];            
        }
    }
}
