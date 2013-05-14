package com.imajuk.ui 
{
    /**
     * @author shin.yamaharu
     */
    public class ScrollLock 
    {
        private var _isLock:Boolean = false;
        
        public function get isLock():Boolean
        {
            return _isLock;
        }
        
        public function set isLock(value:Boolean):void
        {
            _isLock = value;
        }
    }
}
