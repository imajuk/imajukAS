package com.imajuk.geom
{
    /**
     * @author shin.yamaharu
     */
    public class SimpleEquation
    {
        private var _inclination : Number;
        private var _interception : Number;

        /**
         * @param slope         傾きのラジアン度
         * @param interception  y軸に対する切片
         */
        public function SimpleEquation(slope : Number, interception : Number)
        {
            _inclination = Math.sin(slope) / Math.cos(slope);
            _interception = interception;
        }

        public function getX(y : int) : Number
        {
            return (y - _interception) / _inclination;
        }
        
        public function getY(x : Number):Number
        {
            return _inclination * x + _interception;
        }

        public function get inclination() : Number
        {
            return _inclination;
        }

        public function get interception() : Number
        {
            return _interception;
        }

    }
}
