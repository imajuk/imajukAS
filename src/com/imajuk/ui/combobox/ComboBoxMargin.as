package com.imajuk.ui.combobox 
{
    import com.imajuk.color.Color;

    import flash.display.Sprite;

    /**
     * @author shinyamaharu
     */
    public class ComboBoxMargin extends Sprite implements IComboBoxItemView 
    {
        private var marginH : int;

        public function ComboBoxMargin(marginH:int = 0)
        {
        	this.marginH = marginH;
        }
        
        public function get actualHeight() : int
        {
            return marginH;
        }
        
        public function get externalHeight() : int
        {
            return marginH;
        }
        
        public function get externalWidth() : int
        {
            return 0;
        }
        
        public function get externalY() : int
        {
            return 0;
        }
        
        public function get externalX() : int
        {
            return 0;
        }
        
        public function set actualHeight(value : int) : void
        {
        	marginH = value;        }
        
        public function set externalWidth(value:int):void
        {
            //未実装
        }
        
        public function set externalHeight(value : int) : void
        {
        	marginH = value;
        }
        
        public function setItemColor(value : Color) : void
        {
        }
        
        public function clone() : IComboBoxItemView
        {
            return new ComboBoxMargin(marginH);
        }
        
        public function setLabel(data : *) : void
        {
        }
    }
}
