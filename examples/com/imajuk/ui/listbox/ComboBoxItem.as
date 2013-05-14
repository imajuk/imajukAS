package com.imajuk.ui.listbox 
{
    import com.imajuk.ui.combobox.ComboBoxItemContainer;
    import com.imajuk.utils.StageReference;
	import fl.motion.easing.Exponential;
	import com.imajuk.motion.TweensyThread;
	import com.imajuk.ui.combobox.ComboBoxEvent;
	import flash.display.DisplayObject;
    import com.imajuk.utils.DisplayObjectUtil;
    import com.imajuk.ui.buttons.IButton;
    import com.imajuk.color.Color;
    import com.imajuk.ui.combobox.IComboBoxItemView;

    import flash.display.MovieClip;

    /**
     * @author shinyamaharu
     */
    public class ComboBoxItem extends Button implements IComboBoxItemView, IButton
    {
        private var h:int;
        private var iconID:String;
        private var textID:String;
        private var w:int;
        private var yo:int;
        private var ol:int;
        private var f: Class;
        private var oa : int;
        private var rolloverColor : Color;
        private var selectedColor : Color;
        private var defaultColor : Color;
        private var thirdPartyIcon: DisplayObject;
        private var iconTween:TweensyThread;

        public function ComboBoxItem(
                                iconAssetID:String,
                                textAssetID:String,
                                width:int,
                                height:int,
                                defaultColor:Color,
                                rolloverColor:Color,
                                selectedColor:Color,
                                yOffset:int = 0,
                                offsetArrow:int = 0,
                                offsetLabel:int = 0
                                )
        {
            super(iconAssetID, textAssetID, width, height, defaultColor, rolloverColor, selectedColor, yOffset, offsetArrow, offsetLabel);
            
            iconID = iconAssetID;
            textID = textAssetID;
            w = width;
            h = height;
            this.defaultColor = defaultColor;
            this.rolloverColor = rolloverColor;
            this.selectedColor = selectedColor;
            yo = yOffset;
            oa = offsetArrow;
            ol = offsetLabel;
        }

        override public function toString() : String 
        {
            return "KuraraComboBoxItem["+parent+"]";
        }

        public function clone():IComboBoxItemView
        {
            return new ComboBoxItem(iconID, textID, w, h, defaultColor, rolloverColor, selectedColor, yo, oa, ol);
        }

        /**
         * 
         */
        public function setLabel(data:*):void
        {
        	//KuraraComboboxItemViewのラベルはムービークリップ
        	var labelAsset:MovieClip = label;
//        	var labelAsset:MovieClip = label_text.asset as MovieClip;
        	//渡される値はムービークリップのフレームラベル
        	var frameLabel:String = String(data);
        	//ムービークリップのフレーム移動でラベルを表現
        	labelAsset.gotoAndStop(frameLabel);
        	//youkuなどのサードパーティアイコン
            var bannerIcon:Array = DisplayObjectUtil.getAllChildrenByName(labelAsset, "icon");
            if (bannerIcon.length == 1)
            {
                thirdPartyIcon = addChild(bannerIcon[0]);
                thirdPartyIcon.x += 30;
                var me:ComboBoxItem = this;
                
                StageReference.stage.addEventListener(ComboBoxEvent.CLOSE, function(e:ComboBoxEvent):void
                {
                    var container:ComboBoxItemContainer = e.target as ComboBoxItemContainer;
                    
                    if (!container)
                        return;
                        
                    if(!container.hasItem(me, false))
                        return;
                    
                    //TODO  コンテナからのイベントを重複して受け取っているようなのでイベント配信を見直す
                    
                    if (iconTween)
                	   iconTween.interrupt();
                	
                	thirdPartyIcon.alpha = 0;
                });
                StageReference.stage.addEventListener(ComboBoxEvent.OPEN, function(e:ComboBoxEvent):void
                {
                	var container:ComboBoxItemContainer = e.target as ComboBoxItemContainer;
                	
                    if (!container)
                        return;
                        
                    if(!container.hasItem(me, false))
                        return;
                        
                    //TODO  コンテナからのイベントを重複して受け取っているようなのでイベント配信を見直す
                    
                    if (iconTween)
                       iconTween.interrupt();
                       
                	iconTween = new TweensyThread(thirdPartyIcon, 0, 1, Exponential.easeInOut, null, {alpha:1});
                	iconTween.start();
                });
            } 
            
        }

        override public function get externalHeight():int
        {
            return h;
        }
        
        override public function get externalWidth():int
        {
            return w;
        }
        
        public function setItemColor(value : Color) : void
        {
        }
        
        override public function get externalY() : int
        {
            return y;
        }
        
        override public function set externalHeight(value : int) : void
        {
        }
        
        override public function get actualHeight() : int
        {
            return h;
        }
        
        override public function set actualHeight(value : int) : void
        {
        }
    }
}
