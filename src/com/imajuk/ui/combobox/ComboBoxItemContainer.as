package com.imajuk.ui.combobox 
{
    import com.imajuk.ui.scroll.IScrollContainer;
    import com.imajuk.utils.DisplayObjectUtil;

    /**
     * @author shin.yamaharu
     */
    public class ComboBoxItemContainer extends ListBoxItemContainer implements IScrollContainer
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        public function ComboBoxItemContainer(
                            defaultItemView : IComboBoxItemView,
                            itemView : IComboBoxItemView,
                            scroll : ScrollResolver,
                            debug:Boolean = false
                        )
        {
            super(itemView, scroll, debug);
            
            this.defaultItemView = defaultItemView;
            this._hasDefaultItemView = defaultItemView != null;
        }
    	
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        private var defaultItemView:IComboBoxItemView;
    	       
        //--------------------------------------------------------------------------
        //
        //  Overridden properties
        //
        //--------------------------------------------------------------------------
    	        
        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------

        private var _defaultItemInstance:ComboBoxItemViewContainer;
        internal function get defaultItem() : ComboBoxItemViewContainer
        {
            return _defaultItemInstance;
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------
        /**
         * コンテナからデフォルトアイテム以外のアイテムを取り除く
         */
        override internal function reset() : void
        {
            _items.forEach(
                function(item : ComboBoxItemViewContainer, ...param):void
                {
                    if (item == _defaultItemInstance)
                    {
                        item.resetLabel();
                        return;
                    }
                       
                    DisplayObjectUtil.removeChild(item);
                }
            );
            _items = [_defaultItemInstance];
        }

        //マスクを開く時間
        private var _openDuration : Number = .5;
        internal function set openDuration(value:Number) : void 
        {
        	_openDuration = value;
        	
            ComboBoxMask(contentMask).openDuration = value;
        	
        	//内包しているコンボボックスがあれば設定
        	_items.forEach(
                function(item : ComboBoxItemViewContainer, ...param):void
                {
                    if(item.itemView is ComboBox)
                        ComboBox(item.itemView).openDuration = value;
                }
            );
        }

        internal function open() : void 
        {
        	//マスクを開く
        	ComboBoxMask(_contentMask).open();
        	//イベント配信        	dispatchEvent(new ComboBoxEvent(ComboBoxEvent.OPEN, 0, null, null));
        }

        internal function close() : void 
        {
        	//マスクを閉じる
        	ComboBoxMask(_contentMask).close();
        	
        	//内包しているコンボボックスがあれば閉じる
            _items.forEach(
                function(item : ComboBoxItemViewContainer, ...param):void
                {
                    if(item.itemView is ComboBox)
                        ComboBox(item.itemView).close();
                }
            );
            
            mouseChildren = true;
            
        	//イベント配信
            dispatchEvent(new ComboBoxEvent(ComboBoxEvent.CLOSE, 0, null, null));
        }

        internal function isDefaultItemInstance(item : ComboBoxItemViewContainer) : Boolean 
        {
            return item == _defaultItemInstance;
        }

        private var _hasDefaultItemView : Boolean;
        
        internal function get hasDefaultItem() : Boolean 
        {            return _hasDefaultItemView;
        }

        override public function toString() : String {
        	return "ComboBoxItemContainer["+ (parent ? parent.name : "") +"]";
        }
        
        override protected function createItemView(data : *) : IComboBoxItemView 
        {
            if (data is ComboBox || data is ComboBoxMargin || !(_items.length==0 && defaultItemView))
                return super.createItemView(data);                
            return defaultItemView.clone();
        }

        override internal function addItem(id : int, data : *) : Boolean
        {
        	super.addItem(id, data);
        	
            var isDefaultItem : Boolean = defaultItemView && _defaultItemInstance == null;
            
            //デフォルトアイテムが設定されていて、まだインスタンスがなければ格納する
            if (isDefaultItem) 
                _defaultItemInstance = _items[0];
            
            openDuration = _openDuration;
            
            return isDefaultItem;
        }
    }
}
