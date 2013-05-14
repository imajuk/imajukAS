package com.imajuk.ui.combobox 
{
    import com.imajuk.logs.Logger;
    import com.imajuk.ui.IUIView;
    import com.imajuk.utils.DisplayObjectUtil;

    import flash.geom.Point;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;

    /**
     * ComboBoxは開閉できるListBoxとして定義されます.
     * また選択されたアイテムを表示する独立したラベルをもっています.
     * 
     * @author shin.yamaharu
     */
    public class ComboBox extends ListBox implements IUIView, IComboBoxItemView
    {
        private var itemEnableThread : ComboBoxItemEnableThread;
        private var defaultItemView : IComboBoxItemView;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        /**
         * @param defaultItemView   デフォルトのラベルを表示するためのビュー
         *                          デフォルトのラベルを表示する必要がなければnullを渡します.
         *                          たとえば、入れ子になったComboBoxのトップレベルのコンボボックスがこのケースにあたります
         * @param itemView          アイテムになるビュー
         *                          アイテムになるビューを表示する必要がなければnullを渡します.
         *                          たとえば、入れ子になったComboBoxのトップレベルのコンボボックスがこのケースにあたります
         * @param defaultData       デフォルトのラベルが選択されている時のこのComboBoxが返すデータです.
         *                          また、IComboBoxItemViewはこのデータを解釈しラベルをレンダリングします.
         *                          
         * TODO イベントリレーのテスト
         */
        public function ComboBox(
                            defaultItemView : IComboBoxItemView,
                            itemView : IComboBoxItemView,
                            defaultData : *,
                            debug:Boolean = false,
                            name:String = null,
                            autoPosition:Boolean = false
                        ) 
        {
            this.defaultItemView = defaultItemView;
            
            super(itemView, debug, name);
        	
            //=================================
            // resister as listener
            //=================================
            itemContainer.addEventListener(
                ComboBoxEvent.SELECT_DEFAULT_ITEM,  selectedDefaultItemHandler, false, 1
            );
            mouseHitArea.addEventListener(
                ComboBoxEvent.OUT_OF_HITAREA,       outSideHitAreaHandler,      false, 1
            );
            
            //=================================
            // positioning
            // コンボボックスが開いたとき画面領域外に行ってしまうのを防ぐ
            //=================================
            if (autoPosition)
            {
                positionThread = new ComboBoxPositionThread(this);
                positionThread.start();
            }
            
            //=================================
            // layout item
            // アイテムのサイズは動的に可変する可能性があるので
            // アイテムをレイアウトするThreadを起動しておく
            //=================================
            layoutItemThread = new ComboBoxLayoutItemThread(itemContainer.items);
            layoutItemThread.start();
            
            //=================================
            // アイテムの選択状態を管理する
            //=================================
            itemEnableThread = new ComboBoxItemEnableThread(this);
            itemEnableThread.start();

            //=================================
            // initialize
            //=================================
            if (ComboBoxItemContainer(itemContainer).hasDefaultItem)
                addItem(defaultData);
            
            //マスクの最小サイズを決定  
            //defaultItemViewが指定されていればその高さを、なければitemViewの高さを使用する
            ComboBoxMask(scrollMask).closedHeight = defaultItemView ? defaultItemView.externalHeight : itemContainer.itemViewHeight;
        }
        
        override protected function getFactory() : IItemContainerFactory 
        {
            return new ComboBioxItemContainerFactory(defaultItemView);
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        private var positionThread : ComboBoxPositionThread;
        private var layoutItemThread : ComboBoxLayoutItemThread;

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        //=================================
        // public
        //=================================
        /**
         * アイテム選択後自動で閉じるかどうか
         */
        private var _autoClose : Boolean = true;
        public function get autoClose() : Boolean
        {
            return _autoClose;
        }
        public function set autoClose(autoClose : Boolean) : void
        {
            _autoClose = autoClose;
        }
        
        /**
         * アイテムを選択したときそのアイテムのラベルをデフォルトラベルとして表示するか
         * デフォルトはtrue
         */
        private var _selectableItem : Boolean = true;
        public function get selectableItem() : Boolean
        {
            return _selectableItem;
        }
        public function set selectableItem(value:Boolean) : void 
        {
            _selectableItem = value;
        }

        override public function get externalHeight() : int
        {
        	if (isOpen)
        	   return ComboBoxMask(scrollMask).openedHeight;        	else
        	   return ComboBoxMask(scrollMask).closedHeight;
        }

        /**
         * マスクされている領域の高さを返す
         * マスクはトランジションするので現在のサイズを返すために
         */
        internal function get currentHeight() : Number
        {
            return scrollMask.maskHeight;
        }

        //=================================
        // internal, private
        //=================================        
        internal function get isOpen() : Boolean
        {
            return ComboBoxModel(model).status == ComboBoxModel.OPEN;
        }

        internal function get bottom() : int
        {
        	var r:Rectangle = visibleRect;
            return r.y + r.height;
        }

        private function get visibleRect() : Rectangle
        {
            var gp : Point = DisplayObjectUtil.getGlobalPosition(DisplayObject(scrollMask));
            return new Rectangle(gp.x, gp.y, scrollMask.maskWidth, scrollMask.maskHeight);
        }
        //--------------------------------------------------------------------------
        //
        //  Overridden, implemented Methods
        //
        //--------------------------------------------------------------------------
        override public function toString() : String {
        	return "ComboBox[" + name + "]";
        }
        
        override public function clone() : IComboBoxItemView
        {
            throw new Error("未実装");
            return null;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        public function open() : void 
        {
        	Logger.debug(this , ComboBoxModel(model).status);
        	            //モデルのステータス更新.このあとupdateViewが呼ばれる            ComboBoxModel(model).status = ComboBoxModel.OPEN;
            updateView();
        }

        public function close() : void 
        {
        	Logger.debug(this , ComboBoxModel(model).status);
        	
            //モデルのステータス更新
            ComboBoxModel(model).status = ComboBoxModel.CLOSE;
            updateView();
        }
        
        override public function reset() : void
        {
            ComboBoxModel(model).status = ComboBoxModel.CLOSE;
            super.reset();
        }
        
        override public function set rowCount(value : int) : void
        {
        	super.rowCount = value;
            updateView();
        }
        
        /**
         * ビューの開閉状態を更新
         */
        private function updateView(...param) : void
        {
        	Logger.debug(this, ComboBoxModel(model).status);
        	
        	switch(ComboBoxModel(model).status)
            {
                case ComboBoxModel.OPEN:
                    updateMaskSize(_rowCount);                    ComboBoxItemContainer(itemContainer).open();
                    scrollLock.isLock = false;
                    break;
                case ComboBoxModel.CLOSE:
                    updateMaskSize(_rowCount);
                    ComboBoxItemContainer(itemContainer).close();
                    resetContainerPosition();
                    scrollLock.isLock = true;
                    break;
            }
                
            updateScrollHitArea();
            updateContainerHitArea();
        }

        override protected function updateContainerHitArea() : void 
        {
            mouseHitArea.update(scrollMask.maskWidth, ComboBoxMask(scrollMask).openedHeight);
                
            if (isOpen)
                mouseHitArea.startHitTest();
            else
                mouseHitArea.stopHitTest();
        }
        
        override protected function updateScrollHitArea2() : void 
        {
            ComboBoxScrollHitArea(itemContainer.contentHitArea).updateSize(
                    scrollMask.maskWidth, 
                    ComboBoxMask(scrollMask).openedHeight
                );
        }
        
        override protected function updateMaskSize(rows : int) : void 
        {
            //=================================
            // マスクの更新
            //=================================  
            //デフォルトアイテムがないComboBoxは常に開いた状態なので最小サイズは見た目の高さ
            if (!ComboBoxItemContainer(itemContainer).hasDefaultItem)
                ComboBoxMask(scrollMask).closedHeight = itemContainer.externalHeight;
            
            super.updateMaskSize(rows);
        }
                
        //--------------------------------------------------------------------------
        //
        //  Event handlers : combobox
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         * ビューの領域外にマウスが移動した
         */
        protected function outSideHitAreaHandler(event : ComboBoxEvent) : void 
        {
        	//コンボボックスを閉じる
        	if (autoClose)
        	   close();
        }
        //--------------------------------------------------------------------------
        //
        //  Event handlers : デフォルトアイテム
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         * デフォルトアイテムが選択された
         */
        private function selectedDefaultItemHandler(event : ComboBoxEvent) : void 
        {
            //autoSelectedItemが設定されていればそのアイテムを選択状態
            if (_autoSelectedItem > 0)
            {
            	Logger.debug(this, "autoSelectedItemが指定されているのでvirtualClick");
                itemContainer.virtualClick(_autoSelectedItem);
            }
        }

        //--------------------------------------------------------------------------
        //
        //  Event handlers : アイテム
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         * アイテムが選択された
         */
        override protected function selectedItemHandler(event : ComboBoxEvent) : void 
        {
        	super.selectedItemHandler(event);

            //コンボボックスを開く
            open();
            
            //デフォルトアイテムのラベルを選択されたアイテムのラベルに更新
            if (ComboBoxItemContainer(itemContainer).hasDefaultItem)
            {
            	//クリックされたのがデフォルトアイテムなら何もしない
                if (ComboBoxItemContainer(itemContainer).isDefaultItemInstance(event.target as ComboBoxItemViewContainer))
                    return;
                    
                if (_selectableItem)
                    ComboBoxItemContainer(itemContainer).defaultItem.setLabel(event.data);
                
                //オートクローズが指定されていれば閉じる
                if (autoClose)
                    close();
            }
        }

        /**
         * コンボボックスを開く時間を設定
         */
        public function set openDuration(value:Number) : void 
        {
            ComboBoxItemContainer(itemContainer).openDuration = value;
        }
        
        override public function set mouseChildren(enabled : Boolean) : void
        {
        	super.mouseChildren = enabled;
        	//内包するアイテムを再起的に設定
            itemContainer.mouseChildren = enabled;
        }
        
        /**
         * デフォルトアイテムがクリックされた時に自動的に選択状態にするアイテム
         * 何も設定されていない時は0
         */
        private var _autoSelectedItem:int = 0;
        public function get autoSelectedItem() : int
        {
            return _autoSelectedItem;
        }
        public function set autoSelectedItem(autoSelectedItem : int) : void
        {
            _autoSelectedItem = autoSelectedItem;
        }

        internal function hasItem(item : IComboBoxItemView) : Boolean 
        {
            return itemContainer.hasItem(item);
        }

        public function getViewFromData(data : *) : DisplayObject
        {
        	return itemContainer.getViewFromData(data);
        }
    }
}
