package com.imajuk.ui.combobox 
{
    import com.imajuk.ui.combobox.ComboBox;

    import org.libspark.thread.Thread;

    /**
     * @author shin.yamaharu
     */
    public class ProvinceThread extends Thread 
    {
        private var combo_province : ComboBox;
        private var combo_city : ComboBox;
        private var xml : XML;

        public function ProvinceThread(combo_province : ComboBox, combo_city : ComboBox, xml : XML)
        {
            super();
            this.combo_province = combo_province;
            this.combo_city = combo_city;
            this.xml = xml;
        }

        override protected function run() : void
        {
            combo_province.reset();
            combo_city.reset();
                
            //add items
            for each (var provinse : XML in xml.province) 
            {
                combo_province.addItem(provinse.@name.toString());
            }
        }

        override protected function finalize() : void
        {
        }
    }
}
