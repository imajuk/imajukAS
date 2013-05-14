package com.imajuk.ui.combobox.view 
{
    import com.imajuk.behaviors.ColorBehavior;
    import com.imajuk.color.Color;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.ui.buttons.AbstractButton;
    import com.imajuk.ui.buttons.ButtonBase;
    import com.imajuk.ui.buttons.fluent.BehaviorContext;
    import com.imajuk.ui.combobox.ColorConfig;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;
    import flash.text.TextField;



    /**
     * @author shin.yamaharu
     */
    public class SampleButton extends AbstractButton 
    {
        protected var labelText : TextField;
        protected var base : ButtonBase;
        
        public function SampleButton(
                                    iconAssetID:String,
                                    textAssetID:String,
                                    width:int,
                                    height:int,
                                    yOffset:int = 0,
                                    offsetR:int = 0
                                    )
        {
            var asset:Sprite = addChild(new Sprite()) as Sprite;
            super(asset);
            
        	var lineColor:Color = Color.fromHSV(16, 64, 39);
            
            base = 
            	new ButtonBase(
	                        width,
	                        height,
	                        24,
	                        [new DropShadowFilter(2, 26.5651, 0, .53, 9, 9)],
	                        ColorConfig.DARK_RED,
	                        1,
	                        lineColor
                     );
            
            var icon:DisplayObject = AssetFactory.create(iconAssetID);
            icon.x = 8;            icon.y = yOffset + 4;
            
            var label:DisplayObject = AssetFactory.create(textAssetID);
            label.x = 12 + offsetR;
            label.y = yOffset;

            asset.addChild(base);
            asset.addChild(icon);
            asset.addChild(label);
            
            if (label is Sprite)
                labelText = Sprite(label).getChildByName("tx") as TextField;
            

            context(BehaviorContext.ROLL_OVER_OUT)
            .behave(ColorBehavior.createTint(ColorConfig.CREAM, 1, base.base, ColorConfig.DARK_RED, 1))
            .behave(ColorBehavior.createTint(ColorConfig.RED, 1, icon, ColorConfig.CREAM, 1))
            .behave(ColorBehavior.createTint(ColorConfig.RED, 1, label, ColorConfig.CREAM, 1));            

            
//            super(
//                new FlatColorBehavior(
//	            	 btnBase,
//	                 ColorConfig.CREAM,
//	                 ColorConfig.DARK_RED,
//	                 btnBase.base
//	            ),//                new FlatColorBehavior(
//                	icon,            
//                	ColorConfig.RED, 
//                	ColorConfig.CREAM
//                ),
//                new FlatColorBehavior(
//                	label,
//                	ColorConfig.RED,
//                	ColorConfig.CREAM
//                	)
//                );
            
        }
    }
}
