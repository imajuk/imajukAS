package com.imajuk.ui.combobox 
{
    import flash.events.Event;
    /**
     * @author shin.yamaharu
     */
    public class ComboBoxEvent extends Event 
    {
        public static const SELECT:String = "SELECT";
        public static const ADD_ITEM:String = "ADD_ITEM";
        public static const SELECT_DEFAULT_ITEM:String = "SELECT_DEFAULT_ITEM";
        public static const ADD_DEFAULT_ITEM:String = "ADD_DEFAULT_ITEM";
        public static const OUT_OF_HITAREA:String = "CLOSE";
        public static const OPEN:String = "OPEN";
        public static const CLOSE:String = "CLOSE";
        
        private var _id:int;
        private var _data:*;
        private var _defaultData:*;

        public function ComboBoxEvent(type:String, id:int, data:*, defaultData:*)
        {
            _id = id;
            _data = data;
            _defaultData = defaultData;
            
            super(type, true);
        }

        override public function toString():String
        {
            return super.toString() + [_id, _data, _defaultData];
        }

        public function get id():int
        {
            return _id;
        }

        public function set id(id:int):void
        {
            _id = id;
        }

        public function get data():*
        {
            return _data;
        }

        public function set data(value:*):void
        {
            _data = value;
        }
        
        public function get defaultData():*
        {
            return _defaultData;
        }
    }
}
