package com.imajuk.ui.listbox 
{
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.logs.Logger;
    import com.imajuk.service.AssetLocation;
    import com.imajuk.service.IAssetLocation;
    import com.imajuk.service.PreLoader;
    import com.imajuk.service.PreLoaderThread;
    import com.imajuk.ui.combobox.ComboBoxMargin;
    import com.imajuk.ui.combobox.ListBox;
    import flash.display.Sprite;
    import flash.net.URLRequest;
    import org.libspark.thread.Thread;



    /**
     * @author shinyamaharu
     */
    public class ListboxFactoryThread extends Thread 
    {
        private var timeline : Sprite;

        public function ListboxFactoryThread(getUI:Function = null, timeline:Sprite = null)
        {
            super();
            this.timeline = timeline;
        }

        override protected function run() : void
        {
            error(Error, function(e:Error, failed:Thread):void
            {
                trace("////////////////////////");
                trace(e);
                trace(e.getStackTrace());
                trace(failed);
                trace("////////////////////////");
            });
            
            //アセットがロードされていなければロードする
            if(!AssetFactory.isResisterd("$ArrowL1"))
            {
                var a : IAssetLocation = 
                    new AssetLocation()
                        .add(
                            new URLRequest("assets/ui.swf"), 
                            function(d : Sprite):void
                            {
                                AppDomainRegistry.getInstance().resisterAppDomain(d);
                            });
                
                var preloader : PreLoader = new PreLoader();
                var t : Thread = new PreLoaderThread(preloader, a);
                t.start();
                t.join();
            }
            
            next(buildCombobox);
        }
        
        private function buildCombobox() : void
        {
            /********************************************
             * ComboBox
             */
             
            //=================================
            // create combobox item
            // アイテムはIComboBoxItemViewを実装する任意のオブジェクト
            // 今回はAbstractButtonを継承
            //=================================
            //Level3
            var kuraraComboItemL3:ComboBoxItem = 
                new ComboBoxItem(
                    "$ArrowL3",
                    "$Level3",
                    260, //width
                    18,  //height
                    ColorConfig.DEFAULT_GRAY,   //default color
                    ColorConfig.LIGHTBLUE,   //rollover color
                    ColorConfig.LIGHTBLUE,  //selected color
                    0,   //y offset
                    0,   //arrow offset
                    26   //label offset
                );
            
            
            //=================================
            // Level3   精鋭影像
            //=================================
            var level3_0:ListBox = 
                new ListBox(kuraraComboItemL3, false, "Level3_0");
                

            level3_0.name = "Level3_0";
            level3_0.rowCount = 4;            level3_0.addItem(Data.FEATURE_3_0);
            level3_0.addItem(Data.FEATURE_3_1);
            level3_0.addItem(Data.FEATURE_3_2);
            level3_0.addItem(new ComboBoxMargin(18));
            level3_0.addItem(Data.FEATURE_4_0);
            level3_0.addItem(Data.FEATURE_4_1);            
            DocumentClass.container.addChild(level3_0);
            level3_0.y = 50;
            
        }

        override protected function finalize() : void
        {
            Logger.info(0, "product menu has created.");
        }
    }
}
