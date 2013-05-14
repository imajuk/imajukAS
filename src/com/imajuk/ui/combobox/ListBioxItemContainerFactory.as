package com.imajuk.ui.combobox 
{
    import flash.display.Sprite;

    import com.imajuk.ui.scroll.view.ScrollMask;
    import com.imajuk.ui.scroll.IScrollContainerMask;

    import flash.geom.Rectangle;
    import flash.display.DisplayObject;


    /**
     * @author shinyamaharu
     */
    public class ListBioxItemContainerFactory implements IItemContainerFactory 
    {
    	public function createItemContainer(itemView:IComboBoxItemView, debug:Boolean) : DisplayObject 
        {
        	var scroll:ScrollResolver = 
        	   new ScrollResolver(
        	       createScrollMask(debug), 
        	       createContainerlHitArea(debug)
        	   );
                        
            return new ListBoxItemContainer(
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
            return new ScrollMask(new Rectangle(0, 0, 1, 1), debug);
        }
        
        public function createModel() : ListBoxModel
        {
            return new ListBoxModel();
        }
    }
}
