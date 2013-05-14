package com.imajuk.ui.combobox 
{
    import com.imajuk.color.Color;
    import com.imajuk.ui.IUIView;
    import com.imajuk.ui.buttons.AbstractButton;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.utils.getQualifiedClassName;

    /**
     * IComboBoxItemViewをラップし、このアイテムのidとデフォルト値を保存する
     * またイベント配信などの基本的なIComboBoxItemViewのための機能を実装する
     * IComboBoxItemViewの実装クラスは任意のクラスにしたいので、
     * IComboBoxItemViewの抽象クラスを定義せずにIComboBoxItemViewをコンポジットするようにした。
     * @author shin.yamaharu
     */
    internal class ComboBoxItemViewContainer extends Sprite implements IUIView
    {
        internal var data:*;
        internal var itemView:IComboBoxItemView;
        internal var id:int;
        private var isDefaultItem : Boolean;

        public function ComboBoxItemViewContainer(
                                id:int, 
                                data:*, 
                                itemView:IComboBoxItemView, 
                                isDefaultItem:Boolean
                        ) 
        {
            if (!(itemView is DisplayObject))
                throw new Error("the ComboBoxItem should be DisplayObject. but actual " + getQualifiedClassName(itemView));

            this.id = id;
            this.data = data;
            this.isDefaultItem = isDefaultItem;
            
            this.itemView = addChild(DisplayObject(itemView)) as IComboBoxItemView;
            this.itemView.addEventListener(MouseEvent.CLICK, clickedItemViewHandler);
            this.itemView.setLabel(data);
            
            //=================================
            // limitation of MouseEvent
            //=================================
            mouseEnabled = false;
        }

        override public function toString() : String 
        {
            return "ComboBoxItemViewContainer[" + id + "," + data + "]";
        }

    	//アイテムがクリックされた
        private function clickedItemViewHandler(event : MouseEvent = null) : void 
        {
//        	trace(this + " : clickedItemViewHandler " + 
//        	   [
//        	       "\n\ttarget is IComboBoxItemView:" + (event.target is IComboBoxItemView),//        	       "\n\ttarget is ComboBox:" + (event.target is ComboBox)
//        	   ]
//            );
            
        	//IComboBoxItemView以外のイベントは受け付けない
        	if (!(event.target is IComboBoxItemView))
        	   return;
        	//入れ子になったコンボボックスからのイベントも無視する
        	if (event.target is ComboBox)
        	   return;
        	   
        	
        	dispatchEvent(new ComboBoxEvent(ComboBoxEvent.SELECT, id, data, null));
        	
        	//デフォルトアイテムがクリックされた
        	if (isDefaultItem)
                dispatchEvent(new ComboBoxEvent(ComboBoxEvent.SELECT_DEFAULT_ITEM, id, data, null));
        }
        
        internal function virtualClick() : void 
        {
            if (itemView is AbstractButton)
                AbstractButton(itemView).virtualClick();  	
        }

        internal function resetLabel():void
        {
        	setLabel(data);
        }

        internal function setItemColor(value:Color):void
        {
            itemView.setItemColor(value);
        }
        
        internal function setLabel(data:*):void
        {
            itemView.setLabel(data);
        }
        
        public function get actualHeight():int
        {
            return itemView.actualHeight;        }
        
        public function get externalWidth():int
        {
            return itemView.externalWidth;
        }
        
        public function set externalWidth(value:int):void
        {
        	//未実装
        }
        
        public function get externalHeight():int
        {
            return itemView.externalHeight;
        }
        
        public function get externalY() : int
        {
        	//未実装
            return y;
        }
        
        public function get externalX() : int
        {
            //未実装
            return x;
        }
        
        public function set actualHeight(value : int) : void
        {        	//未実装
        }
        
        public function set externalHeight(value : int) : void
        {        	//未実装
        }
    }
}
