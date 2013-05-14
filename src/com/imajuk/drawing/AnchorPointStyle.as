package com.imajuk.drawing
{

    /**
     * @author shinyamaharu
     */
    public class AnchorPointStyle 
    {
        public static const SQUEAR : String = "SQUEAR";
        public static const CIRCLE : String = "CIRCLE";
        public var size : Number ;
        public var color : int ;
        public var leftHandleStyle : AnchorPointStyle ;
        public var rightHandleStyle : AnchorPointStyle;
        public var type : String;
        public var lineColor : int;
        public var lineAlpha : Number;

        /**
         * コンストラクタ
         * @param color             このポイントを描画するカラーです
         * @param lineColor         このポイントの法線のカラーです.
         *                          ハンドルのスタイル場合はハンドルのラインカラーです.
         * @param lineAlpha         このポイントの法線の透明度です.
         *                          ハンドルのスタイルの場合はハンドルの透明度です.
         * @param size              このポイントを描画する際の点のサイズです.
         *                          ハンドルのスタイルの場合はハンドルの点のサイズです.
         * @param type              このポイントをどんな形で描画するか指定します.
         * @param leftHandleStyle   このAnchorPointの左ハンドルのスタイルです.         * @param rightHandleStyle  このAnchorPointの右ハンドルのスタイルです.
         */
        public function AnchorPointStyle(
                            color : int = 0x0000FF, 
                            lineColor : int = 0,                            lineAlpha : Number = 1,
                            size : Number = 1.5, 
                            type : String = SQUEAR, 
                            leftHandleStyle : AnchorPointStyle = null,
                            rightHandleStyle : AnchorPointStyle = null
                        ) 
        {
            this.color = color;
            this.size = size;            this.type = type;
            this.lineColor = lineColor;            this.lineAlpha = lineAlpha;
            
            if (this is DefaultAnchorPointStyle)
                return;
                            this.leftHandleStyle = leftHandleStyle || new DefaultAnchorPointStyle();            this.rightHandleStyle = rightHandleStyle || new DefaultAnchorPointStyle();
        }

        public function toString() : String 
        {
            return "AnchorPointStyle[color:#" + color.toString(16) + ", lineAlpha:" + lineAlpha + "]";
        }
    }
}

import com.imajuk.drawing.AnchorPointStyle;

class DefaultAnchorPointStyle extends AnchorPointStyle
{
    public function DefaultAnchorPointStyle(
                        color : int = 0x0000FF, 
                        lineColor : int = 0,
                        lineAlpha : Number = 1,
                        size : Number = 1.5, 
                        type : String = SQUEAR
                        ) 
    {
        super(color, lineColor, lineAlpha, size, type);
    }
}
