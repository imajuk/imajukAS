package com.imajuk.motion 
{
    import com.imajuk.color.Color;
    import com.imajuk.color.ColorMatrixUtil;

    import flash.filters.ColorMatrixFilter;    
    import flash.utils.Dictionary;    
    import flash.display.DisplayObject;    
    /**     * @author yamaharu     */    public class ColorMatrixTweenHelper implements ITweenHelper
    {        public static const HUE:int = 0;
        public static const SATURATION:int = 1;        public static const VALUE:int = 2;        public static const CONTRAST:int = 3;
        public static const COLORIZE:int = 4;
        public static const COLORIZE2:int = 5;
        private var _target:DisplayObject;
        private var brightnessCashe:Dictionary = new Dictionary(true);
        private var colorizeCashe:Dictionary = new Dictionary(true);
        private var _rgb : Number;
        private var _brightness:int;
        private var _amount : Number = 0;
        private var isApplyRGB : Boolean;
        private var isApplyBrightness : Boolean;
        private var tempFilter : Array;

        /**
         * @param rgb           0x000000 ~ 0xFFFFFF
         * @param brightness    -255 ~ 255
         */
        public function ColorMatrixTweenHelper(target:DisplayObject, rgb:Color = null, brightness:Number = 0) 
        {
            _target = target;
            _rgb = rgb ? rgb.rgb : NaN;
            _brightness = brightness;
                        isApplyRGB        = !isNaN(_rgb);
            isApplyBrightness = brightness != 0;
            tempFilter        = target.filters.concat();
        }
        
        public function dispose() : void
        {
            amount = 0;
            _target = null;
            tempFilter = null;
            brightnessCashe = null;
            colorizeCashe = null;
        }

        public function get amount() : Number
        {
            return _amount;
        }
        
        public function set amount(value : Number) : void
        {
            _amount = value;
            
            if (_amount == 0)
            {
            	 _target.filters = tempFilter;
            	 return;
            }
            
            var appliedFilters:Array = tempFilter.concat();
            
            if (isApplyRGB) appliedFilters.push(getColorizeFilter(value));
            if (isApplyBrightness) appliedFilters.push(getBrightnessFilter(value));
            
            _target.filters = appliedFilters;
        }

        private function getColorizeFilter(amount : Number) : ColorMatrixFilter
        {
            //まだなければ生成してキャッシュ
            if (!colorizeCashe[amount])
                colorizeCashe[amount] = ColorMatrixUtil.colorize(_rgb, amount);
            
           return colorizeCashe[amount];
        }

        /**
         * return a filter for brightness
         */
        private function getBrightnessFilter(amount:Number) : ColorMatrixFilter
        {
            //まだなければ生成してキャッシュ
            if (!brightnessCashe[amount])
                brightnessCashe[amount] = ColorMatrixUtil.brightness(_brightness * amount);
            
            return brightnessCashe[amount];
        }
        
        public function set rgb(value : uint) : void
        {
            _rgb = value;
        }
        
        public function set brightness(brightness : int) : void
        {
            _brightness = brightness;
        }

        public function  set toColor(value:Color) : void 
        {
        	_rgb = value.rgb;
        }
    }}