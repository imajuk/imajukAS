package com.imajuk.ui.combobox 
{
    import flash.events.EventDispatcher;

    /**
     * @author shinyamaharu
     */
    internal class ListBoxModel extends EventDispatcher 
    {
        internal var current : *;
        private var defaultData : *;
        private var id : int = 0;
        private var _data : Array = [];

        internal function addItem(data : *, isDefault : Boolean = false) : Boolean
        {
            //=================================
            // 重複チェック
            //=================================
            if (_data.some(
                function(e:*, ...param):Boolean
                {
                    return e === data;
                })
            ) return false;
            
            _data.push(data);
            
            if (isDefault)
                defaultData = data;
                
            dispatchEvent(new ComboBoxEvent(ComboBoxEvent.ADD_ITEM, id++, data, defaultData));
            return true;
        }
        
        public function reset():void
        {
            _data = [_data[0]];
            id = 1;
        }
    }
    
    
}
