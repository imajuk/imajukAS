package com.imajuk.ui.combobox 
{
    import com.imajuk.ui.scroll.IScrollCommandFactory;
    import com.imajuk.ui.scroll.MouseOverScrollCommandFactory;
    import com.imajuk.ui.scroll.IScrollContainerMask;
    import com.imajuk.ui.ScrollLock;
    import com.imajuk.color.Color;
    import com.imajuk.ui.IUIView;

    import flash.utils.getQualifiedClassName;
    import flash.display.Sprite;

    /**
     * ListBoxは2つ以上のIComboBoxItemViewで構成される.
     * addItem()されたとき新しいIComboBoxItemViewインスタンスを生成して追加する
     * この処理はComboBoxItemContainerに委譲される.
     * 
     * viewのヒエラルキーは以下の通り
     *   # ComboBoxItemContainer
     *     # mouseHitArea 
     *     # itemContainer
     *     # ComboBoxMask
     *     # ComboBoxScrollHitArea
     *     
     * @author shinyamaharu
     */
    public class ListBox extends Sprite implements IUIView, IComboBoxItemView 
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        /**
         * @param itemView リストのアイテムとなるIComboBoxItemViewインスタンス
         * @param debug    debugモードの有無
         * @param name     このリストボックスインスタンスの名前
         */
        public function ListBox(
                            itemView : IComboBoxItemView,
                            debug : Boolean = false,
                            name : String = null
                        )
        {
            if (name != null)
               this.name = name;
            
            //=================================
            // limitation of MouseEvent
            //=================================
            mouseEnabled = false;

            //=================================
            // factory
            //=================================            
            var factory : IItemContainerFactory = getFactory();
            
            //=================================
            // create model
            //=================================
            model = factory.createModel();
            
            //=================================
            // create view
            //=================================
            //アイテムを格納するコンテナ
            itemContainer = addChild(factory.createItemContainer(itemView, debug)) as ListBoxItemContainer;
            itemContainer.name = "_itemContainer_";
                
            //=================================
            // resister as listener
            //=================================
            itemContainer.addEventListener(ComboBoxEvent.SELECT, selectedItemHandler, false, 1);
            model.addEventListener(ComboBoxEvent.ADD_ITEM, addItemHandler, false, 1);

            //=================================
            // scrolling
            //=================================
            //マスク            
            scrollMask = itemContainer.contentMask;
            
            //ヒットエリア            
            mouseHitArea = itemContainer.addChild(new ComboBoxHitArea(debug)) as ComboBoxHitArea;

            //スクロールロック管理オブジェクト
            scrollLock = new ScrollLock();
        }
    	
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
    	//=================================
        // Model
        //=================================
        protected var model : ListBoxModel;
        //=================================
        // Container
        //=================================
        internal var itemContainer : ListBoxItemContainer;
        //=================================
        // for scroll
        //=================================
        protected var scroll : IScrollCommandFactory;
        protected var scrollMask : IScrollContainerMask;
        protected var scrollLock : ScrollLock;
        protected var mouseHitArea : ComboBoxHitArea;
        
        //--------------------------------------------------------------------------
        //
        //  Implementation of IView
        //
        //--------------------------------------------------------------------------
        public function get actualHeight() : int
        {
            return itemContainer.actualHeight;
        }

        public function set actualHeight(value : int) : void
        {
            throw new Error(getQualifiedClassName(this) + "にはこのプロパティを指定する事はできません.");
        }

        public function get externalHeight() : int
        {
            return scrollMask.maskHeight;
        }

        public function set externalHeight(value : int) : void
        {
            throw new Error(getQualifiedClassName(this) + "にはこのプロパティを指定する事はできません.");
        }

        public function get externalWidth() : int
        {
            return itemContainer.externalWidth;
        }
        
        public function set externalWidth(value:int):void
        {
            //未実装
        }

        public function get externalY() : int
        {
            return y;
        }
        
        public function get externalX() : int
        {
            return x;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Implementation of IComboBoxItemView
        //
        //--------------------------------------------------------------------------
        public function clone() : IComboBoxItemView
        {
            throw new Error("未実装");
            return null;
        }

        public function setItemColor(value : Color) : void
        {
            itemContainer.setItemColor(value);
        }

        public function setLabel(data : *) : void
        {
            //このメソッドはListBoxでは実装しない
        }
    	        
        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------

        /** コンボボックスが開いた時に表示するアイテムの数です.
         * -1を指定するとすべてのアイテムを表示します.
         * デフォルト値は-1です。
         */
        protected var _rowCount : int = -1;
        public function get rowCount() : int
        {
            return _rowCount;
        }
        public function set rowCount(value : int) : void
        {
            if (value == 0)
               throw new Error("不正な値です.");
               
            _rowCount = value;
            
            updateMaskSize(value);   
        }
        
        public function get data() : *
        {
            var d : * = model.current;
            if (d is ComboBox)
               return ComboBox(d).data;
            else 
                return model.current;
        }
    	        
        //--------------------------------------------------------------------------
        //
        //  Overridden methods
        //
        //--------------------------------------------------------------------------
    	override public function toString() : String 
        {
            return "ListBox[" + name + "]";
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods: API
        //
        //--------------------------------------------------------------------------
        /**
         * コンボボックスにアイテムを追加
         * @param data  追加するアイテムに関連づけられたデータ
         *              IComboBoxItemViewはこのデータを解決しビューをレンダリングする
         *              
         * コンボボックスはアイテムの内容を知らないままmodelに追加する
         * このあとaddItemHandlerが呼び出される
         * @see ComboBoxItemContainer.addItem
         */
        public function addItem(data : *) : void
        {
            if(!model.addItem(data))
                throw new Error(data + "は既に登録されています.");
        }

        public function reset() : void
        {
            model.reset();
            
            itemContainer.reset();
            resetContainerPosition();
        }
    	
    	//--------------------------------------------------------------------------
        //
        //  Methods: creates factory
        //
        //--------------------------------------------------------------------------
        protected function getFactory() : IItemContainerFactory 
        {
            return new ListBioxItemContainerFactory();
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: for scrolling
        //
        //--------------------------------------------------------------------------
        protected function updateMaskSize(rows : int) : void 
        {
            //最大のマスクサイズ（開いた時のサイズ）を更新する
            scrollMask.maskWidth = itemContainer.externalWidth;
            scrollMask.maskHeight = (rows == -1) ?
                    //コンボボックスが内包される事があるのでここはactualHeightではなくexternalHeight 
                    itemContainer.externalHeight : 
                    itemContainer.getExternalHeightFromRowCount(rows);
                    
            if (_rowCount > 0)
            {
                updateScrollHitArea();
                if (scrollMask.maskWidth > 0 && scrollMask.maskHeight > 0)
                    updateContainerHitArea();
                //全体表示でなければスクロール機能をオン
                startScrollFunction();
            }         
        }

        /**
         * @private
         * マスクよりもアイテムコンテナが大きければ
         * スクロール処理が必要なのでヒットエリアをアップデートする
         */
        protected function updateScrollHitArea() : void
        {
            //マスクがなければ何もしない
            if (scrollMask.maskWidth == 0 || scrollMask.maskHeight == 0)
               return;

            //=================================
            // スクロールヒットエリア
            //=================================               
            var scrollHitArea : ComboBoxScrollHitArea = 
                ComboBoxScrollHitArea(itemContainer.contentHitArea);

            var needHitArea : Boolean = scrollMask.maskHeight <= itemContainer.height; 
                
            scrollHitArea.visible = needHitArea;

            //アイテムコンテナよりマスクが大きければスクロールは必要ない
            if (!needHitArea)      
                return;         
                
            //ヒットエリアをアップデート
            updateScrollHitArea2();
        }

        protected function updateScrollHitArea2() : void 
        {
            ComboBoxScrollHitArea(itemContainer.contentHitArea)
                .updateSize(scrollMask.maskWidth, scrollMask.maskHeight);
        }

        protected function updateContainerHitArea() : void 
        {
            mouseHitArea.update(scrollMask.maskWidth, scrollMask.maskHeight);
            mouseHitArea.startHitTest();
        }

        private function startScrollFunction() : void 
        {
            if (scroll)
            {
            	scroll.disposeCommand().start();
            	scroll = null;
            }
            scroll = new MouseOverScrollCommandFactory(itemContainer, scrollLock, itemContainer.itemViewHeight);
            scroll.startCommand().start();
        }

        internal function resetContainerPosition() : void
        {
            itemContainer.content.y = 0;
        }
           
        //--------------------------------------------------------------------------
        //
        //  Event handlers
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         * modelにアイテムが追加された
         */
        protected function addItemHandler(event : ComboBoxEvent) : void
        {
            //=================================
            // コンテナにアイテムを追加
            // ComboBoxItemContainerに委譲する
            //=================================
            itemContainer.addItem(event.id, event.data); 
            
            //=================================
            // マスクの更新
            //=================================  
            updateMaskSize(_rowCount);
        }

        /**
         * @private
         * アイテムが選択された
         */
        protected function selectedItemHandler(event : ComboBoxEvent) : void 
        {
            //モデルを更新
            model.current = event.data;
        }
    }
}
