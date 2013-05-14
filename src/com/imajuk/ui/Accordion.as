package com.imajuk.ui 
{
    import com.imajuk.ui.combobox.ComboBox;

    /**
     * AccordionはComboBoxを子要素にもつComboBoxとして定義されます
     * @author shinyamaharu
     */
    public class Accordion extends ComboBox 
    {
        public function Accordion(name : String = null, debug : Boolean = false)
        {
            super(null, null, "accordiaon", debug, name);
            super.autoClose = false;
        }

        override public function set rowCount(value : int) : void
        {
            throw new Error("AccodiaonのrowCountを設定する事はできません.この値は常に-1です.");        }
        
        override public function set autoClose(autoClose : Boolean) : void
        {
            throw new Error("AccodiaonのautoCloseを設定する事はできません.この値は常にfalseです.");
        }
    }
}
