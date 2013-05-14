package com.imajuk.ui.combobox 
{
    import flash.display.Sprite;

    import com.imajuk.ui.scroll.IScrollContainerMask;

    import flash.geom.Rectangle;
    import flash.display.DisplayObject;

    /**
     * @author shinyamaharu
     */
    public class ComboBioxItemContainerFactory implements IItemContainerFactory 
    {
        private var defaultItemView : IComboBoxItemView;

        public function ComboBioxItemContainerFactory(defaultItemView : IComboBoxItemView)         
        {
    		
            this.defaultItemView = defaultItemView;
        }

        public function createItemContainer(itemView : IComboBoxItemView, debug : Boolean) : DisplayObject
        {
        	var scroll:ScrollResolver = 
               new ScrollResolver(
                   createScrollMask(debug), 
                   createContainerlHitArea(debug)
               );
               
             return new ComboBoxItemContainer(
                        defaultItemView,
                        itemView, 
                        scroll,
                        debug
                    );
        }

        private function createContainerlHitArea(debug : Boolean) : Sprite 
        {
            return new ComboBoxScrollHitArea(debug);
        }

        private function createScrollMask(debug:Boolean) : IScrollContainerMask 
        {
            return new ComboBoxMask(new Rectangle(0, 0, 1, 1), debug);
        }
        
        public function createModel() : ListBoxModel
        {
            return new ComboBoxModel();
        }
    }
}
