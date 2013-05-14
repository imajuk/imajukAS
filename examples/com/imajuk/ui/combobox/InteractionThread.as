package com.imajuk.ui.combobox 
{
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    import com.imajuk.ui.combobox.ComboBox;

    import org.libspark.thread.Thread;

    /**
     * @author shin.yamaharu
     */
    public class InteractionThread extends Thread 
    {
        private var task:Function;
        private var xml:XML;
        private var combo_province:ComboBox;
        private var combo_city:ComboBox;
        private var search:Function;
        private var cityThread:CityUpdateThread;

        public function InteractionThread(
                            combo_province:ComboBox,
                            combo_city:ComboBox,
                            data_market:XML,
                            submit:DisplayObject)
        {
            super();
            
            this.combo_province = combo_province;
            this.combo_city = combo_city;
            this.xml = data_market;
            
            //command for clicking search button
            search = 
	            function():void
	            {
	                var resultThread:Thread = 
	                    new SearchResultsThread(combo_province, combo_city, xml);
	                resultThread.start();
	                resultThread.join();
	                next(task);
	            };
            
            //commnad for accepting to click
            task = 
	            function():void
	            {
	                event(submit, MouseEvent.MOUSE_DOWN, search);
	            };
        }

        override protected function run():void
        {
        	//mediate secondary combobox
            cityThread = new CityUpdateThread(combo_province, combo_city, xml);
            cityThread.start();
            
            //initialize first combo box
            new ProvinceThread(combo_province, combo_city, xml).start();
            cityThread.updateData(xml);
            
        	task();
        }

        override protected function finalize():void
        {
        }
    }
}
