package com.imajuk.ui.combobox 
{
    import com.imajuk.ui.combobox.IComboBoxItemView;

    import flash.display.DisplayObject;

    /**
     * @author shinyamaharu
     */
    public interface IItemContainerFactory 
    {
        function createItemContainer(itemView : IComboBoxItemView, debug : Boolean) : DisplayObject;

        function createModel() : ListBoxModel;
    }
}
