﻿
package com.imajuk.color
{
    /**
     * Colorは色を表現するためのクラスです.
     * 
     * ARGBモデルとAHSVモデルで表現することができます.
     * ColorCoreインスタンスの生成は、通常<code>new Color()</code>は使用しません。
     * Color.fromHSV()かColor.fromRGB()を使用します。
     * RGBカラーとHSVカラーの同期はインスタンス生成時に一度だけ行われます.
     * つまり、インスタンス生成後redやhなどのプロパティに値を設定しても
     * RGBカラーとHSVカラーは同期されません.
     * 
     * @author yamaharu
     */
    public class Color 
    {
        private var recalc : Boolean;
        
        private var _rgb : int = 0x000000;
        public function get rgb():int
        {
            return _rgb;
        }
        public function set rgb(value:int):void
        {
            _rgb = value;
        }

        /**
         * 未定義のalphaを表現するために型はNumber
         */
        private var _argb:Number = NaN;
        public function get argb():Number
        {
            if (recalc)
            {
                _argb = ColorUtil.getARGBFromSeparatedElements(_red, _green, _blue, _alpha);
                recalc = false;
            }
            return _argb;
        }
        public function set argb(value:Number):void
        {
            _argb = value;
        }

        /**
         * 未定義のalphaを表現するために型はNumber
         */
        private var _alpha:Number = NaN;
        public function get alpha():Number
        {
            return _alpha;
        }
        public function set alpha(value:Number):void
        {
            _alpha = value;
            recalc = true;
        }

        private var _red:int;
        public function get red():int
        {
            return _red;
        }
        public function set red(value:int):void
        {
            _red = value;
        }

        private var _green:int;
        public function get green():int
        {
            return _green;
        }
        public function set green(value:int):void
        {
            _green = value;
        }

        private var _blue:int;
        public function get blue():int
        {
            return _blue;
        }
        public function set blue(value:int):void
        {
            _blue = value;
        }

        private var _h:int;
        public function get h():int
        {
            return _h;
        }
        public function set h(value:int):void
        {
            _h = value;
        }

        private var _s:int;
        public function get s():int
        {
            return _s;
        }
        public function set s(value:int):void
        {
            _s = value;
        }

        private var _v:int;
        public function get v():int
        {
            return _v;
        }
        public function set v(value:int):void
        {
            _v = value;
        }

        /**
         * 渡された色相、彩度、明度からColorCoreインスタンスを生成して返します。
         * ColorCoreインスタンスの生成は、通常<code>new Color()</code>は使用しません。
         * このメソッドかColor.fromRGB()を使用します。
         * 
         * @param h   色相（0~359）
         * @param s   彩度（0~100）         * @param v   明度（0~100）
         * @param a   透明度（0~1 未定義にする場合はNaN）
         * @return    Colorインスタンス         */
        public static function fromHSV(
                                hue:Number,
                                s:Number,
                                v:Number,
                                a:Number = NaN
                              ):Color
        {
            //Colorインスタンスを生成
            var c:Color = new Color();
            
            //HSVを設定            c.h = hue;
            c.s = s;
            c.v = v;
            
            //alphaを設定
            if (!isNaN(a))
                c.alpha = a * 255;
                
            //ARGB/RGBを設定
            var argb : Number;
            if (isNaN(a))
            {
                argb = ColorUtil.hsvToRGB(hue, s, v);
                c.argb = NaN;
                c.rgb = argb;
            }
            else
            {
                argb = ColorUtil.hsvToARGB(hue, s, v, a);
                c.argb = argb;
                c.rgb = uint(argb & 0x00FFFFFF);
            } 
            
            //RGB成分を設定
            c.red = ColorUtil.getRedFromARGB(argb);
            c.green = ColorUtil.getGreenFromARGB(argb);
            c.blue = ColorUtil.getBlueFromARGB(argb);
        	
            return c;
        }

        /**
         * 渡されたARGB値からColorCoreインスタンスを生成して返します。
         * ColorCoreインスタンスの生成は、通常<code>new Color()</code>は使用しません。
         * このメソッドかColor.fromRGB、またはColor.fromHSV()を使用します。
         * 
         * @param argb   ARGB値
         * @return       Colorインスタンス
         */
        public static function fromARGB(argb : uint) : Color
        {
            var color : Color = fromRGB(argb & 0x00FFFFFF);
            color.argb = argb;
            color.alpha = ColorUtil.getAlphaFromARGB(argb);
            return color;
        }
        
        /**
         * 渡されたRGB値からColorインスタンスを生成して返します。
         * ARGB値を渡してもアルファ値は無視されます。
         * このメソッドで生成したColorインスタンスのalphaおよびargbプロパティは未定義(NaN)になります.
         * Colorインスタンスの生成は、通常<code>new Color()</code>は使用しません。
         * このメソッドかColor.fromARGB、またはColor.fromHSV()を使用します。
         * 
         * @param rgb   RGB値
         * @return      Colorインスタンス
         */
        public static function fromRGB(rgb:uint):Color
        {
             //hsv成分を取得
            var o : Object = ColorUtil.rgbToHSV(rgb);
            
            //Colorインスタンスを生成
            var color:Color = Color.fromHSV(o.h, o.s, o.v);
            
            //ARGB系のプロパティを設定
            color.rgb = rgb;
            color.red = ColorUtil.getRedFromARGB(rgb);
            color.green = ColorUtil.getGreenFromARGB(rgb);
            color.blue = ColorUtil.getBlueFromARGB(rgb);
            
            return color;
        }
        
        public function equals(color : Color) : Boolean
        {
            return isNaN(_argb) ? _rgb == color.rgb : _argb == color.argb;
        }

        public function clone():Color
        {
            return Color.fromARGB(_argb);
        }

        public function toString():String 
        {
            return "Color[" + _h + "," + _s + "," + _v + "," + _alpha + "]";
        }
    }
}
