package com.imajuk.ui.buttons
{
    import com.bit101.components.CheckBox;
    import com.bit101.components.ColorChooser;
    import com.bit101.components.ComboBox;
    import com.bit101.components.HBox;
    import com.bit101.components.HUISlider;
    import com.bit101.components.InputText;
    import com.imajuk.color.Color;
    import com.imajuk.color.ColorTransformEffect;

    import flash.geom.Matrix;

    public class BehaviorParamsUI
    {
        public static const COLOR : String = "ColorBehavior";
        public static const COLORLIZE : String = "ColorlizeBehavior";
        public static const TRANSPARENT : String = "TransparentBehavior";
        public static const SWAP_IMAGE : String = "ImageSwapBehavior";
        public static const MATRIX : String = "MatrixBehavior";
        public static const FRAME_STEP : String = "FrameStepBehavior";

        public static function getRecipe(behaviorClass : String) : XML
        {
            switch(behaviorClass)
            {
                case COLOR:
                    return <comps>
                    <Label text="is applied on" />
                    <ComboBox id="target" />
                    <Label text="/ on color" />
                    <ColorChooser id="onColor" value="0xFFFFFF" usePopup="true" />
                    <HUISlider id="onAmount" label="amount" value="1" minimum="0" maximum="1" width="140" />
                    <CheckBox id="use" label="/ use off color" y="5" />
                    <ColorChooser id="offColor" value="0x000000" usePopup="true" />
                    <HUISlider id="offAmount" label="amount" value="1" minimum="0" maximum="1" width="140" />
                </comps>;
                    break;

                case COLORLIZE:
                    return <comps>
                    <Label text="is applied on" />
                    <ComboBox id="target" />
                    <Label text="/ color" />
                    <ColorChooser id="color" />
                    <Label text="/ brightness(-255 ~ 255)" />
                    <InputText id="brightness" width="40" text="0" />
                    <Label text="/ max(0 ~ 1)" />
                    <InputText id="max" width="40" text="1" />
                </comps>;
                    break;

                case TRANSPARENT:
                    return <comps>
                    <Label text="is applied on" />
                    <ComboBox id="target" />
                    <Label text="as onAlpha" />
                    <InputText id="onAlpha" width="40" text="1" />
                    <Label text="/offAlpha" />
                    <InputText id="offAlpha" width="40" text=".5" />
                </comps>;
                    break;

                case SWAP_IMAGE:
                    return <comps>
                    <Label text="as on image" />
                    <ComboBox id="onImage" />
                    <Label text="/off image" />
                    <ComboBox id="offImage" />
                </comps>;
                    break;

                case MATRIX:
                    return <comps>
                    <Label text="is applied on" />
                    <ComboBox id="target" />
                    <Label text="as on matrix" />
                    <InputText id="onMatrix" width="100" text="[1.2, 0, 0, 1.2]" />
                    <Label text="/off matrix" />
                    <InputText id="offMatrix" width="100" text="[1, 0, 0, 1]" />
                </comps>;
                    break;

                case FRAME_STEP:
                    return <comps>
                    <Label text="is applied on" />
                    <ComboBox id="target" />
                    <Label text="/ on frame (index or label)" />
                    <InputText id="onFrame" width="40" text="10" />
                    <Label text="/ off frame (index or label)" />
                    <InputText id="offFrame" width="40" text="1" />
                </comps>;
                    break;
            }
            return null;
        }

        public static function getparams(behaviorType : String, hbox : HBox) : Array
        {
            switch(behaviorType)
            {
                case COLOR:
                    var useOffColor : Boolean = CheckBox(hbox.getChildByName("use")).selected;
                    return [
                        ColorTransformEffect.TINT, 
                        ComboBox(hbox.getChildByName("target")).selectedItem ? ComboBox(hbox.getChildByName("target")).selectedItem.data : null, 
                        null, 
                        Color.fromRGB(ColorChooser(hbox.getChildByName("onColor")).value), 
                        HUISlider(hbox.getChildByName("onAmount")).value, 
                        useOffColor ? Color.fromRGB(ColorChooser(hbox.getChildByName("offColor")).value) : null, 
                        useOffColor ? HUISlider(hbox.getChildByName("offAmount")).value : null];
                    break;

                case COLORLIZE:
                    return [Color.fromRGB(ColorChooser(hbox.getChildByName("color")).value), InputText(hbox.getChildByName("max")).text, ComboBox(hbox.getChildByName("target")).selectedItem ? ComboBox(hbox.getChildByName("target")).selectedItem.data : null, InputText(hbox.getChildByName("brightness")).text];
                    break;

                case TRANSPARENT:
                    return [InputText(hbox.getChildByName("onAlpha")).text, InputText(hbox.getChildByName("offAlpha")).text, ComboBox(hbox.getChildByName("target")).selectedItem ? ComboBox(hbox.getChildByName("target")).selectedItem.data : null];
                    break;

                case SWAP_IMAGE:
                    return [ComboBox(hbox.getChildByName("onImage")).selectedItem ? ComboBox(hbox.getChildByName("onImage")).selectedItem.data : null, ComboBox(hbox.getChildByName("offImage")).selectedItem ? ComboBox(hbox.getChildByName("offImage")).selectedItem.data : null];
                    break;

                case MATRIX:
                    return [
                        textToMatrix(InputText(hbox.getChildByName("onMatrix")).text), 
                        textToMatrix(InputText(hbox.getChildByName("offMatrix")).text), 
                        ComboBox(hbox.getChildByName("target")).selectedItem ? 
                            ComboBox(hbox.getChildByName("target")).selectedItem.data : 
                            null
                        ];
                    break;

                case FRAME_STEP:
                    return [
                        InputText(hbox.getChildByName("onFrame")).text, 
                        InputText(hbox.getChildByName("offFrame")).text, 
                        ComboBox(hbox.getChildByName("target")).selectedItem ? 
                            ComboBox(hbox.getChildByName("target")).selectedItem.data : 
                            null
                        ];
                    break;

                default:
                    throw new Error("un-recognize behavior type[" + behaviorType + "]");
            }
            return [];
        }

        private static function textToMatrix(text : String) : Matrix
        {
            var a : Array = text.substr(0, text.length - 1).substr(1).split(",");
            var m : Matrix = new Matrix();
            a.forEach(function(s : String, idx : int, ...param) : void
            {
                switch(idx)
                {
                    case 0:
                        m.a = Number(s);
                        break;
                    case 1:
                        m.b = Number(s);
                        break;
                    case 2:
                        m.c = Number(s);
                        break;
                    case 3:
                        m.d = Number(s);
                        break;
                    case 4:
                        m.tx = Number(s);
                        break;
                    case 5:
                        m.ty = Number(s);
                        break;
                }
            });
            return m;
        }

    }

}
