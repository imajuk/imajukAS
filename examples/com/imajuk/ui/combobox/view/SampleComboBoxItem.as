package com.imajuk.ui.combobox.view 
{
    import com.imajuk.behaviors.BehaviorDetail;
    import com.imajuk.behaviors.ColorBehavior;
    import com.imajuk.color.Color;
    import com.imajuk.ui.buttons.fluent.BehaviorContext;
    import com.imajuk.ui.combobox.IComboBoxItemView;

    /**
     * @author shin.yamaharu
     */
    public class SampleComboBoxItem extends SampleButton implements IComboBoxItemView 
    {
        private var h:int;
        private var iconID:String;
        private var textID:String;
        private var w:int;
        private var yo:int;
        private var or:int;
        private var f:Class;

        public function SampleComboBoxItem(
                                iconAssetID:String,
                                textAssetID:String,
                                width:int,
                                height:int,
                                yOffset:int = 0,
                                offsetR:int = 0
                                )
        {
            super(iconAssetID, textAssetID, width, height, yOffset, offsetR);
            
            iconID = iconAssetID;
            textID = textAssetID;
            w = width;
            h = height;
            yo = yOffset;
            or = offsetR;
        }

        public function clone():IComboBoxItemView
        {
            return new SampleComboBoxItem(iconID, textID, w, h, yo, or);
        }

        public function setLabel(data:*):void
        {
            labelText.text = data;
        }

        override public function get externalHeight():int
        {
            return h + 1;
        }
        
        override public function get externalWidth():int
        {
            return w + 1;
        }
        
        public function setItemColor(value:Color):void
        {
            base.baseColor = value;
            
            var b:Array = getBehaviors(BehaviorContext.ROLL_OVER_OUT);
            ColorBehavior(b[2]).rollOverBehavior(new BehaviorDetail()).play();
        }
        
        override public function get externalY() : int
        {
            // TODO: Auto-generated method stub
            return 0;
        }
        
        override public function set externalHeight(value : int) : void
        {
        }
        
        override public function get actualHeight() : int
        {
            return h + 1;
        }
        
        override public function set actualHeight(value : int) : void
        {
        }
    }
}
