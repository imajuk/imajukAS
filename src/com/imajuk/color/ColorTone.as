package com.imajuk.color 
{
    import fl.motion.easing.Linear;
    import com.imajuk.utils.MathUtil;

    /**
     * @author shinyamaharu
     */
    public class ColorTone 
    {
    	//=================================
    	// all kind of Color Tone
    	//=================================
        public static const PALE : String           = "PALE";        public static const LIGHT_GRAYISH : String  = "LIGHT_GRAYISH";        public static const GRAYISH : String        = "GRAYISH";        public static const DARK_GRAYISH : String   = "DARK_GRAYISH";        
        public static const LIGHT : String          = "LIGHT";        public static const SOFT : String           = "SOFT";        public static const DULL : String           = "DULL";        public static const DARK : String           = "DARK";        
        public static const BRIGHT : String         = "BRIGHT";        public static const STRONG : String         = "STRONG";        public static const DEEP : String           = "DEEP";        public static const VIVID : String          = "VIVID";
        
        //=================================
        // defination of Color Tone
    	// [彩度min, 彩度max, 明度min, 明度max]
        //=================================
        internal static const DEF_PALE : Array            = [7, 20, 100, 100];        internal static const DEF_LIGHT_GRAYISH : Array   = [5, 20, 70, 90];        internal static const DEF_GRAYISH : Array         = [5, 20, 40, 50];
        internal static const DEF_DARK_GRAYISH : Array    = [5, 10, 7, 32];                internal static const DEF_LIGHT : Array           = [30, 68, 100, 100];        internal static const DEF_SOFT : Array            = [30, 68, 80, 90];        internal static const DEF_DULL : Array            = [30, 50, 40, 70];
        internal static const DEF_DARK : Array            = [50, 65, 10, 30];
                internal static const DEF_BRIGHT : Array          = [90, 100, 77, 90];        internal static const DEF_STRONG : Array          = [100, 100, 47, 67];
        internal static const DEF_DEEP : Array            = [100, 100, 40, 45];
        internal static const DEF_VIVID : Array           = [100, 100, 100, 100];
        
        /**
         * 任意のトーンのカラーを返します
         */
        public static function getToneAs(toneKind : String, hue : Number, alpha:Number = .1) : Color 
        {
        	var tone:Array = ColorTone["DEF_" + toneKind];
            var satiation : Number = MathUtil.random(tone[0], tone[1]);
            var value : Number = MathUtil.random(tone[2], tone[3]);
            
            return Color.fromHSV(hue, satiation, value, alpha);
        }
        
        /**
         * 任意のトーンのカラーを返します
         * @param n 明度と彩度の微調整 0~1
         */
        public static function getToneAs2(toneKind : String, hue : Number, n:Number = 0, alpha:Number = .1) : Color 
        {
            var tone:Array = ColorTone["DEF_" + toneKind];
            var satiation : Number = Linear.easeNone(n, tone[0], tone[1] - tone[0], 1);
            var value : Number = Linear.easeNone(n, tone[2], tone[3] - tone[2], 1);
            
            return Color.fromHSV(hue, satiation, value, alpha);
        }

        public static function getAll() : Array 
        {
        	return [PALE, LIGHT_GRAYISH, GRAYISH, DARK_GRAYISH, LIGHT, SOFT, DULL, DARK, BRIGHT, STRONG, DEEP, VIVID];
        }

        public var label : String;
        public var value : Number;
        
        /**
         * コンストラクタ
         * @param kind  トーンの種類. すべてのトーンの種類はColorToneに定義されています.
         * @param value 全体に占めるこのトーンの割合
         */
        public function ColorTone(kind : String, value : Number) 
        {
            this.label = kind;
            this.value = value;
        }
        
        public function toString() : String 
        {
            return label + " : " + int(value) + "%";
        }

        public function clone() : ColorTone 
        {
            return new ColorTone(label, value);
        }

        
    }
}
