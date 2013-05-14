package com.imajuk.ui.slider
{
	import flash.events.Event;

    /**
     * @author shin.yamaharu
     */
    public class UISliderEvent extends Event
    {
        public static const UPDATE : String = "UPDATE";
        private var _value : Number;
        
        public function UISliderEvent(type : String, value:Number)
        {
            super(type, true, false);
            _value = value;
        }

        public function get value() : Number
        {
        	return _value;
        }
        
        override public function clone():Event
        {
        	return new UISliderEvent(type, value);
        }
    }
}
