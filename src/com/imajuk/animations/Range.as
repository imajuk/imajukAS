package com.imajuk.animations 
{

    /**
     * 数値の範囲を表現する
     * @author yamaharu
     */
    public class Range 
    {
        protected var _max:Number;
        protected var _min:Number;

        public function Range(min:Number, max:Number) 
        {
            this._min = min;
            this._max = max;
        }
        
        public function toString() : String {
            return "Range[" + _min + "~" + _max + "]";
        }

        public function get min():Number
        {
            return _min;
        }

        public function get max():Number
        {
            return _max;
        }
        
        public function get size():Number
        {
            return _max - _min;
        }
        
        /**
         * 範囲中からランダムな数値を返す
         */
        public function random():Number
        {
            return _min + Math.random() * size;
        }
    }
}
