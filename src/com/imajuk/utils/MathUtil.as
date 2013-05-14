﻿
package com.imajuk.utils
{
    import flash.geom.Point;
    /**
     * <code>Math</code>に関するのユーティリティ
     * @author yamaharu
     */
    public class MathUtil
    {
        //--------------------------------------------------------------------------
        //
        //  Class properties
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         */
        private static const PI:Number = Math.PI;
        
        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * 渡された2点間を結ぶ直線の角度を返します.
         * 第1引数で渡した点を原点と考えます. 引数を渡す順番に注意してください.
         * @param p1    原点と考える点
         * @param p2    角度を知りたい点
         */
        public static function getRadianFrom2Point(p1 : Point, p2 : Point) : Number
        {
        	var diff:Point = p2.subtract(p1);
            return Math.atan2(diff.y, diff.x);
        }


        /**
         * 渡された任意のラジアンを角度に変換します.
         * 
         * @param radians　角度に変換したいラジアンを渡します.
         * @return ラジアンから角度に変換された値を返します.
         */
        public static function radiansToDegrees(radians:Number):Number 
        {
            return radians / PI * 180;
        }

        /**
         * 渡された任意の角度をラジアンに変換します.
         * 
         * @param degrees　ラジアンに変換したい角度を渡します.
         * @return 角度からラジアンに変換された値を返します.
         */
        public static function degreesToRadians(degrees:Number):Number 
        {
            return degrees * PI / 180;
        }

        
        /**
         * 渡された任意の角度を-180〜180に正規化します.
         * @param degrees　正規化したい角度を渡します.
         * @return 正規化された角度を返します.
         */
        public static function normalizeDegrees(degrees:Number):Number
        {
            var d:Number = (degrees >= 360 || degrees <= -360) ? degrees % 360 : degrees;
            if (d > 180)
            {
                d = d - 360;
            }
            else if (d < -180)
            {
                d = d + 360;
            }
            else if (d == 180)
            {
                d = -180;
            }
            return d;
        }

        
        /**
         * 指定された桁数の精度で剰余を求めます.
         * 
         * <p>例えば、以下のコード<code>trace(1.12345 % 1)</code>は、不正確な値0.12345000000000006を返しますが、これは桁落ち誤差や丸め誤差のためです.</p>
         * <p>このメソッドはそれらの誤差を解決します.</p>
         * @param num1
         * @param num2
         * @param fractionalPart 求めたい剰余の値の精度。小数点以下の桁数で指定します.
         */
        public static function getRemainder(num1:Number, num2:Number, fractionalPart:Number):Number
        {
            var multipler:int = int("1" + createZeroStr(fractionalPart));
            var n:int = int(num1 * multipler) % int(num2 * multipler);
            var lessThanZero:Boolean = n < 0;
            var keta:int = String(n).split("-").join("").length;
            var zero:String = "0." + createZeroStr(fractionalPart - keta);
            n = (lessThanZero) ? -n : n;
            
            var result:Number = Number(zero + n); 
            result = (lessThanZero) ? -result : result;

            return result;
        }

        
        /**
         * @private
         */
        private static function createZeroStr(num:Number):String
        {
            var zero:String = "";
            for (var i:int = 1;i < num; i++) 
            {
                zero += "0";
            }
            return zero;
        }
        /**
         * 任意の範囲からランダムな数値を返す
         */        public static function random(min:Number, max:Number):Number        {
            return Math.random() * (max - min) + min;
        }

        public static function hexToBinary(hex : String) : String 
        {
            var bin : String = "";
            for (var i : int = 0;i < hex.length;i++) 
            {
                var buff : String = hex.substr(i, 1);
                var temp : String = parseInt(buff, 16).toString(2);
                while(temp.length < 4)
                {
                    temp = "0" + temp;
                }
                bin += temp;
            }
            return bin;
        }

        public static function binToHex(bin : String) : String
        {
            var buff : String = "";
            var hex : String = "";
            for (var i : int = 1;i <= bin.length;i++) 
            {
                buff += bin.charAt(i - 1);
                if (i % 8 == 0)
                {
                    var temp : String = parseInt(buff, 2).toString(16);
                    if (temp.length == 1)
                     temp = "0" + temp;
                    hex += temp;

                    buff = "";
                } 
            }
            return hex;
        }

        public static function getAngleDiff(angle1 : Number, angle2 : Number) : Number
        {
        	var vx1:Number, vy1:Number, vx2:Number, vy2:Number;
        	
            vx1 = Math.cos(angle1);
            vy1 = Math.sin(angle1);
            vx2 = Math.cos(angle2);
            vy2 = Math.sin(angle2);
            
            return Math.atan2(crossProduct(vx1, vy1, vx2, vy2), dotProduct(vx1, vy1, vx2, vy2));
        }
        
        public static function dotProduct(vx1:Number, vy1:Number, vx2:Number, vy2:Number):Number
        {
            return vx1 * vx2 + vy1 * vy2;
        }
        
        public static function crossProduct(vx1:Number, vy1:Number, vx2:Number, vy2:Number) : Number 
        {
            return vx1 * vy2 - vx2 * vy1;
        }
    }
}