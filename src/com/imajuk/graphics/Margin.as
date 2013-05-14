package com.imajuk.graphics 
{

    /**
     * @author yamaharu
     */
    public class Margin 
    {
        private var _h:Number;
        private var _v:Number;

        public function Margin(marginH:Number = 0, marginV:Number = 0) 
        {
            _h = marginH;	            _v = marginV;	
        }

        public function get h():Number
        {
            return _h;
        }

        public function set h(value:Number):void
        {
            _h = value;
        }

        public function get v():Number
        {
            return _v;
        }

        public function set v(value:Number):void
        {
            _v = value;
        }
    }
}
