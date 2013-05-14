package com.imajuk.ui.combobox 
{
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.ui.window.IWindowContentBuilder;
    import com.imajuk.ui.window.WindowThread;
    import flash.display.Sprite;
    import org.libspark.thread.Thread;


    /**
     * @author shin.yamaharu
     */
    public class SearchResultsThread extends Thread 
    {
        private var combo_province:ComboBox;
        private var combo_city:ComboBox;
        private var data:XMLList;

        public function SearchResultsThread(combo_province:ComboBox, combo_city:ComboBox, xml:XML)
        {
            super();
            
            this.combo_province = combo_province;
            this.combo_city = combo_city;
            data = xml.province.(@name == combo_province.data).city.(@name == combo_city.data);
        }

        override protected function run():void
        {
            if (data.length() == 0)
                return;
            
            
            var resultContainer:Sprite = 
            	DocumentClass.container.addChild(
            		AssetFactory.create("$Popup")
            	) as Sprite;
            	
            resultContainer.alpha = 0;
            
            var content:IWindowContentBuilder = 
            	new SearchResultViewThread(
            		combo_province,
            		combo_city,
            		data,
            		resultContainer);
            		
            var t:Thread = new WindowThread(content);
            t.start();
            t.join();
                    
        }

        override protected function finalize():void
        {
        }
    }
}
