package com.imajuk.drawing
{
    import flash.display.BitmapData;

    /**
     * @author shinyamaharu
     */
    public class BezierStyle 
    {
        public var lineColor : int;
        public var lineAlpha : Number;
        public var fillColor : int;
        public var fillAlpha : Number;
        public var drawLine : Boolean;
        public var tickness : Number;
        public var usePattern : Boolean;
        public var patternBitmap : BitmapData;
        public var closedShape : Boolean;

        public function BezierStyle(
        					tickness : Number = 1, 
        					lineColor : int = 0xCCCCCC, 
        					lineAlpha : Number = 1, 
        					closedShape : Boolean = false,
        					fillColor : int = -1, 
        					fillAlpha : Number = 1, 
        					patternBitmap : BitmapData = null
        				) 
        {
            this.tickness = tickness;
            this.lineColor = lineColor;
            this.closedShape = closedShape;
            this.fillColor = fillColor;
            this.fillAlpha = fillAlpha;
            this.lineAlpha = lineAlpha;
            this.patternBitmap = patternBitmap;
            this.drawLine = tickness > 0;
            this.usePattern = patternBitmap != null;
        }
    }
}
