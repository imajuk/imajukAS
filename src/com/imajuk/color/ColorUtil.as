﻿package com.imajuk.color
{
    /**
     * カラーに関するユーティリティ
     * @author yamaharu
     */
    public class ColorUtil 
    {
        /**
         * R,G,B,Aの各成分からなるARGB値を返します.
         * @param r RED値（0x00~0xFF）         * @param g GREEN値（0x00~0xFF）         * @param b BLUE値（0x00~0xFF）         * @param a ALPHA値（0x00~0xFF）
         * @return  ARGB値
         */
        public static function getARGBFromSeparatedElements(r:uint, g:uint, b:uint, a:Number = NaN):uint
        {
            if (isNaN(a))
                return r << 16 | g << 8 | b;
            else
                return a << 24 | r << 16 | g << 8 | b;
        }

        /**
         * ARGB値からALPHA値を抽出します
         * @param argb  ARGB値
         * @return      ALPHA値（0~255）
         */
        public static function getAlphaFromARGB(argb:uint):uint
        {
            return uint(uint(argb >> 24) & 0x000000FF);
        }

        /**
         * ARGB値からRED値を抽出します
         * @param argb  ARGB値
         * @return      RED値（0x00~0xFF）
         */
        public static function getRedFromARGB(argb:uint):uint
        {
            return argb >> 16 & 0x000000FF;
        }

        /**
         * ARGB値からGREEN値を抽出します
         * @param argb  ARGB値
         * @return      GREEN値（0x00~0xFF）
         */
        public static function getGreenFromARGB(argb:uint):uint
        {
            return argb >> 8 & 0x000000FF;
        }

        /**
         * ARGB値からBLUE値を抽出します
         * @param argb  ARGB値
         * @return      BLUE値（0x00~0xFF）
         */
        public static function getBlueFromARGB(argb:uint):uint
        {
            return argb & 0x000000FF;
        }

        /**
         * RGB値を6桁の16進数文字列に変換します
         * @param rgb   RGB値
         * @return      変換された6桁の文字列表現
         */
        public static function RGBToFormattedStrings(rgb:int):String
        {
            var r:String = getRedFromARGB(rgb).toString(16);
            var g:String = getGreenFromARGB(rgb).toString(16);
            var b:String = getBlueFromARGB(rgb).toString(16);
            r = (r.length == 1) ? "0" + r : r; 
            g = (g.length == 1) ? "0" + g : g; 
            b = (b.length == 1) ? "0" + b : b; 
		
            return r + g + b;
        }

        /**
         * AHSV値をARGB値に変換します
         * @param       h hue（色相 0~359）
         * @param       s saturation（彩度 0~100）
         * @param       v value of brightness（明度 0~100）
         * @param       a alpha（透明度 0~1）
         * @return      ARGB値
         * 
         * 参考：
         * http://level0.cuppy.co.jp/2008/06/rgbhsvcmyk.php
         * http://hooktail.org/computer/index.php?RGB%A4%AB%A4%E9HSV%A4%D8%A4%CE%CA%D1%B4%B9%A4%C8%C9%FC%B8%B5
         */
        public static function hsvToARGB(h:Number, s:Number, v:Number, a:Number):uint
        {
            h %= 360;
            h = Math.min(Math.max(h, 0), 360);            if(h == 360)
				h = 0;

            s = (s == 100) ? 255 : s * 2.55;
            s = Math.min(Math.max(s, 0), 255) / 255;
            
            v = (v == 100) ? 255 : v * 2.55;
            v = Math.min(Math.max(v, 0), 255) / 255;

            var r:Number;
            var g:Number;
            var b:Number;

            if (s == 0) 
            {
                r = g = b = v;
            }
            else 
            {
                var hi:Number = Math.floor(h / 60);                var f:Number = (h / 60) - hi;
                var m:Number = v * (1 - s);
                var n:Number = v * (1 - f * s);
                var k:Number = v * (1 - (1 - f) * s);
                switch (hi) 
                {
                    case 0 :
                        r = v;
                        g = k;
                        b = m;
                        break;

                    case 6 :
                        r = v;
                        g = 0;
                        b = m;
                        break;

                    case 1 :
                        r = n;
                        g = v;
                        b = m;
                        break;

                    case 2 :
                        r = m;
                        g = v;
                        b = k;
                        break;

                    case 3 :
                        r = m;
                        g = n;
                        b = v;
                        break;

                    case 4 :
                        r = k;
                        g = m;
                        b = v;
                        break;

                    case 5 :
                        r = v;
                        g = m;
                        b = n;
                        break;

                    default :
                        trace("error");
                }
            }
            return getARGBFromSeparatedElements(
                        Math.floor(r * 255),
                        Math.floor(g * 255),
                        Math.floor(b * 255),
                        isNaN(a) ? NaN : a * 255
                    );
        }
        
        public static function rgbToHSV(rgb:uint):Object 
        {
            var h:Number, s:Number, v:Number;
            var r:uint = ColorUtil.getRedFromARGB(rgb);
            var g:uint = ColorUtil.getGreenFromARGB(rgb);
            var b:uint = ColorUtil.getBlueFromARGB(rgb);
            var cmax:uint = Math.max(r, g, b);
            var cmin:uint = Math.min(r, g, b);
            v = cmax;
            s = (cmax == 0) ? 0 : (cmax - cmin) / cmax;
            
            if (r == cmax) 
                h = 60 * ((g - b) / (cmax - cmin));
            else if (g == cmax) 
                h = 60 * (2 + (b - r) / (cmax - cmin));
            else if (b == cmax) 
                h = 60 * (4 + (r - g) / (cmax - cmin));

            if (h < 0) 
                h += 360;
            if (s == 0) 
                h = 0;
            s *= 100;
            v = v / 255 * 100;

            return {h:h, s:s, v:v};
        }

        public static function hsvToRGB(h : int, s : int, v : int) : uint
        {
        	return hsvToARGB(h, s, v, 1) & 0x00FFFFFF;
        }
    }
}