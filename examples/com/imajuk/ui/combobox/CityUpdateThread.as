package com.imajuk.ui.combobox 
{
    import com.imajuk.ui.combobox.ComboBox;
    import com.imajuk.ui.combobox.ComboBoxEvent;

    import org.libspark.thread.Thread;

    /**
     * @author shin.yamaharu
     */
    public class CityUpdateThread extends Thread 
    {
        private var combo_province : ComboBox;
        private var combo_city : ComboBox;
        private var xml : XML;

        public function CityUpdateThread(combo_province : ComboBox, combo_city : ComboBox, xml : XML)
        {
            super();
            this.combo_province = combo_province;
            this.combo_city = combo_city;
            updateData(xml);
        }

        override protected function run() : void
        {
            event(combo_province, ComboBoxEvent.SELECT, selectProvinceHandler);
        }

        internal function updateData(xml : XML) : void
        {
            this.xml = xml;
        }

        private function selectProvinceHandler(e : ComboBoxEvent) : void
        {
            next(run);
            
            if (e.id == 0)
        	   return;
        	   
            combo_city.reset(); 
            for each (var city : XML in xml.province.(@name == e.data).city) 
            {
                combo_city.addItem(city.@name);
            }
        }

        override protected function finalize() : void
        {
        }
    }
}
