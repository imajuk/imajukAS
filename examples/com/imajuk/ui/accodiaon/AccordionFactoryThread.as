package com.imajuk.ui.accodiaon 
{
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.service.AssetLocation;
    import com.imajuk.service.IAssetLocation;
    import com.imajuk.service.PreLoader;
    import com.imajuk.service.PreLoaderThread;
    import com.imajuk.ui.Accordion;
    import com.imajuk.ui.combobox.ComboBox;
    import com.imajuk.ui.combobox.ComboBoxMargin;
    import flash.display.Sprite;
    import flash.net.URLRequest;
    import org.libspark.thread.Thread;



    /**
     * @author shinyamaharu
     */
    public class AccordionFactoryThread extends Thread 
    {
    	private var level1 : ComboBox;
        private var getUI : Function;
        private var timeline : Sprite;

        public function AccordionFactoryThread(getUI:Function = null, timeline:Sprite = null)
        {
            super();
            this.getUI = getUI;
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
            //Level1
            var kuraraComboItem_L1:ComboBoxItem = 
                new ComboBoxItem(
                    "$ArrowL1",
                    "$Level1",
                    333, //width
                    26,  //height
                    ColorConfig.GRAY,   //default color
                    ColorConfig.BLACK,   //rollover color
                    ColorConfig.BLACK,  //selected color
                    0,   //y offset
                    0,   //arrow offset
                    12
                );
                
            //Level2
            var kuraraComboItem_L2:ComboBoxItem = 
                new ComboBoxItem(
                    "$ArrowL2",
                    "$Level2",
                    210, //width
                    18,  //height
                    ColorConfig.GRAY,   //default color
                    ColorConfig.BLUE,   //rollover color
                    ColorConfig.BLUE,  //selected color
                    0,   //y offset
                    13,   //arrow offset
                    17   //label offset
                );
                    
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
            // level1
            //=================================
            level1 = 
                new Accordion("Level1");
            level1.name = "Level1";
            level1.openDuration = 1;
            level1.x = 20;
            level1.y = 20;
            level1.alpha = (getUI != null) ? 0 : 1;
            if (timeline)
                timeline.addChild(level1);
            else
                DocumentClass.container.addChild(level1);
            
            //=================================
            // Level3   精鋭影像
            //=================================
            var level3_0:ComboBox = 
                new ComboBox(kuraraComboItem_L2, kuraraComboItemL3, Data.FEATURE_3, false, "Level3_0");

            level3_0.autoSelectedItem = 1;
            level3_0.name = "Level3_0";
            level3_0.rowCount = -1;
            level3_0.selectableItem = false;
            level3_0.autoClose = false;
            level3_0.addItem(Data.FEATURE_3_0);
            level3_0.addItem(Data.FEATURE_3_1);
            level3_0.addItem(Data.FEATURE_3_2);
            level3_0.addItem(new ComboBoxMargin(18));
            
            //=================================
            // Level3   捕捉精彩瞬間
            //=================================
            var level3_1:ComboBox = 
                new ComboBox(kuraraComboItem_L2, kuraraComboItemL3, Data.FEATURE_4, false, "level3_1");

            level3_1.autoSelectedItem = 1;
            level3_1.name = "level3_1";
            level3_1.rowCount = -1;
            level3_1.selectableItem = false;
            level3_1.autoClose = false;
            level3_1.addItem(Data.FEATURE_4_0);
            level3_1.addItem(Data.FEATURE_4_1);
            level3_1.addItem(new ComboBoxMargin(18));
            
            //=================================
            // Level3   精彩視界
            //=================================
            var level3_2:ComboBox = 
                new ComboBox(kuraraComboItem_L2, kuraraComboItemL3, Data.FEATURE_5, false, "level3_2");

            level3_2.autoSelectedItem = 1;
            level3_2.name = "level3_2";
            level3_2.rowCount = -1;
            level3_2.selectableItem = false;
            level3_2.autoClose = false;
            level3_2.addItem(Data.FEATURE_5_0);
            level3_2.addItem(Data.FEATURE_5_1);
            level3_2.addItem(Data.FEATURE_5_2);
            level3_2.addItem(new ComboBoxMargin(18));
            
            //=================================
            // Level3   精彩視界
            //=================================
            var level3_3:ComboBox = 
                new ComboBox(kuraraComboItem_L2, kuraraComboItemL3, Data.FEATURE_6, false, "level3_3");
                
            level3_3.autoSelectedItem = 1;
            level3_3.name = "level3_3";
            level3_3.rowCount = -1;
            level3_3.selectableItem = false;
            level3_3.autoClose = false;
            level3_3.addItem(Data.FEATURE_6_0);
            level3_3.addItem(Data.FEATURE_6_1);
            level3_3.addItem(Data.FEATURE_6_2);
            level3_3.addItem(new ComboBoxMargin(18));
            
            //=================================
            // Level2  S60系統
            //=================================
            var level2_0:ComboBox = 
                new ComboBox(kuraraComboItem_L1, kuraraComboItem_L2, Data.CATEGORY_0, false, "Level2_0");
               
            //開いた時に1番目のアイテムを選択状態にする
            level2_0.autoSelectedItem = 1;
            level2_0.name = "Level2_0";
            level2_0.rowCount = -1;
            level2_0.autoClose = false;
            level2_0.selectableItem = false;
            level2_0.addItem(Data.FEATURE_0);
            level2_0.addItem(Data.FEATURE_1);
            level2_0.addItem(new ComboBoxMargin(20));
            
            //=================================
            // Level2   其他精彩功能
            //=================================
            var level2_1:ComboBox = 
                new ComboBox(kuraraComboItem_L1, kuraraComboItem_L2, Data.CATEGORY_1, false, "Level2_1");
                
            level2_1.autoSelectedItem = 1;
            level2_1.name = "Level2_1";
            level2_1.rowCount = -1;
            level2_1.autoClose = false;
            level2_1.selectableItem = false;
            level2_1.addItem(Data.FEATURE_2);
            level2_1.addItem(level3_0);
            level2_1.addItem(level3_1);
            level2_1.addItem(level3_2);
            level2_1.addItem(level3_3);
            level2_1.addItem(new ComboBoxMargin(20));
            
            //=================================
            // Level2   其他精彩功能
            //=================================
            var level2_2:ComboBox = 
                new ComboBox(kuraraComboItem_L1, kuraraComboItem_L2, Data.CATEGORY_2, false, "Level2_2");
                
            level2_2.autoSelectedItem = 1;
            level2_2.name = "Level2_2";
            level2_2.rowCount = -1;
            level2_2.selectableItem = false;
            level2_2.autoClose = false;
            level2_2.addItem(Data.FEATURE_7);
            level2_2.addItem(Data.FEATURE_8);
            level2_2.addItem(Data.FEATURE_9);
            
            level1.addItem(level2_0);
            level1.addItem(level2_1);
            level1.addItem(level2_2);
            
            if (getUI != null)
               getUI(level1);
        }

        override protected function finalize() : void
        {
            trace("\t# product menu has created.");
        }
    }
}
