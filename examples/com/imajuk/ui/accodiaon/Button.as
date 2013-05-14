package com.imajuk.ui.accodiaon 
{
    import com.imajuk.behaviors.ColorBehavior;
    import com.imajuk.color.Color;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.ui.buttons.AbstractButton;
    import com.imajuk.ui.buttons.fluent.BehaviorContext;

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;


    /**
     * @author shinyamaharu
     */
    public class Button extends AbstractButton 
    {
        protected var label : MovieClip;

        /**
    	 * @param offsetR  widthで指定された幅ニア流転の座標を0とした時
    	 *                 左にどのくらいオフセットするか
    	 */
    	public function Button(iconAssetID:String,
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
            var spr:Sprite = new Sprite();
            spr.graphics.beginFill(0xff0000, 0);
            spr.graphics.drawRect(0, 0, width, height);
            super(spr);
            
            var icon:DisplayObject = AssetFactory.create(iconAssetID);
            icon.x = offsetArrow;
            icon.y = yOffset;

            label = AssetFactory.create(textAssetID) as MovieClip;
            label.x = offsetLabel;
            label.y = yOffset;
            
            Sprite(asset).addChild(icon);
            Sprite(asset).addChild(label);
            
            context(BehaviorContext.ROLL_OVER_OUT)
            .behave(ColorBehavior.createTint(rolloverColor, 1, icon, defaultColor))
            .behave(ColorBehavior.createTint(rolloverColor, 1, label, defaultColor))
            .context(BehaviorContext.SELECT_UNSELECT)
            .behave(ColorBehavior.createTint(selectedColor, 1, label));
            
        }
    }
}
