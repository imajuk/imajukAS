package com.imajuk.ui.combobox 
{
    import com.imajuk.ui.scroll.MouseOverScrollContainer;
    import com.imajuk.ui.scroll.IScrollContainer;
    import com.imajuk.color.Color;
    import com.imajuk.utils.DisplayObjectUtil;

    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.display.DisplayObject;

    /**
     * @author shinyamaharu
     */
    internal class ListBoxItemContainer extends MouseOverScrollContainer implements IScrollContainer
    {
    	/**
         * デフォルトアイテム以外のアイテムのベースカラー
         */
        protected var itemColor : Color;
        protected var itemView : IComboBoxItemView;
        
        protected var _items:Array = [];
        public function get items() : Array 
        {
            return _items;
        }
    	
        public function ListBoxItemContainer(
                            itemView : IComboBoxItemView,
                            scroll : ScrollResolver,
                            debug : Boolean = false
                        )
        {
        	var spr:Sprite = new Sprite();
            spr.name = "_container_";
            
            //=================================
            // limitation of MouseEvent
            //=================================
            mouseEnabled = false;
            spr.mouseEnabled = false;
            
            super(spr, scroll.contentMask, scroll.contenthitArea, debug);
            
            this.itemView = itemView;
        }
        
        /**
         * コンテナにアイテムを追加
         * @param id    ユニークなID.モデルで発行され渡される
         * @param data  追加するアイテムに関連づけられたデータ
         * @return このアイテムがデフォルトアイテムかどうか
         */
        internal function addItem(id : int, data : *) : Boolean
        {
            //=================================
            // 新しいアイテムとしてIComboBoxItemViewを追加
            // IComboBoxItemViewはこのデータを解決しビューをレンダリングする
            //=================================
            //現在のコンテナの最下部の座標
            var addY : int = actualHeight;
            //追加されるIComboBoxItemView
            var itemVIew:IComboBoxItemView = createItemView(data);
            //あらかじめ設定されたIComboBoxItemViewを複製して追加する
            var item : ComboBoxItemViewContainer = 
                Sprite(_content).addChild(
                    new ComboBoxItemViewContainer(
                        id, 
                        data, 
                        itemVIew, 
                        false                    )
                ) as ComboBoxItemViewContainer;
            //アイテムのポジショニング
            item.y = addY;
            _items.push(item);
            
            //アイテムカラーを更新
            setItemColor(itemColor);
            
//            var buttons : Array = _items.map(function(b : ComboBoxItemViewContainer, ...param):IButton
//            {
//                return b.itemView as IButton;
//            }).filter(function(b : IButton, ...param):Boolean
//            {
//              return b != null;
//            });
//            if(buttons.length > 0)
//            {
//                if (xor)
//                    xor.interrupt();
//                xor = new ButtonGroupThread(Vector.<InteractiveObject>(buttons));
//                xor.start();
//            }
            
            //スーパークラスの機能を使ってactualHeightを自動計算
            actualHeight = -1;
            
            return _items.length == 1;
        }
        
        protected function createItemView(data : *) : IComboBoxItemView 
        {
            if (data is ComboBox)
                return data;
            else if (data is ComboBoxMargin)
                return data;
                
            return itemView.clone();
        }
        
        /**
         * すべてのアイテムのカラーを設定する
         */
        internal function setItemColor(value : Color) : void
        {
            if (!value)
               return;
             
            itemColor = value; 
            _items.forEach(
                function(item : ComboBoxItemViewContainer, ...param):void
                {
                    item.setItemColor(value);
                }
            );
        }
        
        /**
         * コンテナからデフォルトアイテム以外のアイテムを取り除く
         */
        internal function reset() : void
        {
            _items.forEach(
                function(item : ComboBoxItemViewContainer, ...param):void
                {
                    DisplayObjectUtil.removeChild(item);
                }
            );
            _items = [];
        }
        
        internal function get itemViewHeight() : Number 
        {
        	if (itemView)
                return itemView.externalHeight;
            else
                return 0;
        }
        
        /**
         * 表示したいアイテムの数から見た目上の高さを返す
         */
        internal function getExternalHeightFromRowCount(value : int) : int 
        {
            var h : int;
            for (var i : int = 0;i < value;i++) 
            {
                if (i > _items.length - 1)
                   break;
                
                h += ComboBoxItemViewContainer(_items[i]).externalHeight;
            }
            return h;
        }
        
        internal function getViewFromData(data : *) : DisplayObject 
        {
            var result : DisplayObject;
            for (var i : int = 0; i < _items.length; i++) 
            {
                var item : ComboBoxItemViewContainer = _items[i];
                if (item.itemView is ComboBox)
                {
                    result = ComboBox(item.itemView).getViewFromData(data);
                }
                else
                {
                    if (data == item.data)
                        result = item;
                }
                
                if (result != null)
                    return result;
            }
            return null;
        }
        
        /**
         * 指定したアイテムがこのコンテナに含まれているかどうか返します.
         * @param item  コンテナに含まれているかどうか調べたいアイテム
         * @param deep  コンテナにコンテナが含まれていた場合再帰的に調べるかどうか
         */
        public function hasItem(item : IComboBoxItemView, deep:Boolean = true) : Boolean 
        {
            return _items.some(
                function(i : ComboBoxItemViewContainer, ...param):Boolean
                {
                    if (i.itemView is ComboBox)
                    {
                        if (deep)
                            return ComboBox(i.itemView).hasItem(item);
                        else
                            return false;
                    }
                    else
                    {
                        return i.itemView == item;
                    }
                }
            );
        }
        
        internal function virtualClick(itemIndex : int) : void 
        {
            ComboBoxItemViewContainer(_items[itemIndex]).virtualClick();
        }
        
        override public function get actualHeight() : int
        {
//          trace("\t\t" + this + " : actualHeight " + []);
            var addY : int;
            _items.forEach(
                function(item : ComboBoxItemViewContainer, ...param):void
                {
                    addY += item.actualHeight;    
//                  trace("\t\t\t", item.itemView, item.data, addY);
                }
            );
            return addY;      
        }
        
        override public function set mouseChildren(enabled : Boolean) : void
        {
            super.mouseChildren = enabled;
            //内包するアイテムを再起的に設定
            _items.forEach(
                function(item : ComboBoxItemViewContainer, ...param):void
                {
                    InteractiveObject(item.itemView).mouseEnabled = enabled;
                }
            );
        }
        
        override public function get externalWidth() : int
        {
            var w : int = 0;
            _items.forEach(
                function(item : ComboBoxItemViewContainer, ...param):void
                {
                    w = Math.max(item.externalWidth, w);    
                }
            );
            return w;
        }
        
        override public function get externalY() : int
        {
            return y;
        }

        override public function get externalHeight() : int
        {
            var addY : int;
            _items.forEach(
                function(item : ComboBoxItemViewContainer, ...param):void
                {
                    addY += item.externalHeight;    
                }
            );
            return addY;
        }
        
        override public function set externalHeight(value : int) : void
        {
        }
    }
}
