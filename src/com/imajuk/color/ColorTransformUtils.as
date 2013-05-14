package com.imajuk.color
{
    import flash.geom.ColorTransform;

    /**
     * @author imajuk
     */
    public class ColorTransformUtils
    {
        /**
         * Tint(着色)用のColorTransformオブジェクトを返します.
         * 
         */
        public static function createTint(color : Color, amount:Number = 1) : ColorTransform
        {
            return applyTint(new ColorTransform(), color, amount);
        }
        
        public static function applyTint(colorTransform:ColorTransform, color : Color, amount:Number = 1) : ColorTransform
        {
            var m : Number = 1 - amount;
            colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = m;
            colorTransform.redOffset       = color.red   * amount;
            colorTransform.greenOffset     = color.green * amount;
            colorTransform.blueOffset      = color.blue  * amount;
            
            if (!isNaN(color.alpha))
            {
                colorTransform.alphaMultiplier = (color.alpha / 255 - 1) * amount + 1;
                colorTransform.alphaOffset     = 0;
            }
            
            return colorTransform;
        }

        public static function create2WayTint(blackDest : Color, whiteDest : Color, amount : Number) : ColorTransform
        {
            return new ColorTransform(
                            (whiteDest.red   / 255 * 2 - 2) * amount + 1 , 
                            (whiteDest.green / 255 * 2 - 2) * amount + 1, 
                            (whiteDest.blue  / 255 * 2 - 2) * amount + 1, 
                            1, 
                            blackDest.red   * amount, 
                            blackDest.green * amount, 
                            blackDest.blue  * amount, 
                            0
                        );
        }

        public static function createLightness(lightness : Number, amount : Number) : ColorTransform
        {
            var m : Number = 1 - Math.abs(lightness) / 255 * amount;
            lightness = lightness > 0 ? lightness * amount : 0;
            return new ColorTransform(m, m, m, 1, lightness, lightness, lightness, 0);
        }

        public static function createLightness_offset(lightness : Number, amount : Number) : ColorTransform
        {
            lightness *= amount;
            return new ColorTransform(1, 1, 1, 1, lightness, lightness, lightness, 0);
        }

        public static function createInvert(amount : Number) : ColorTransform
        {
            var m : Number = amount * -2 + 1;
            var offset:Number = amount * 255;
            return new ColorTransform(m, m, m, 1, offset, offset, offset, 0);
        }
    }
}
