package com.imajuk.utils 
{
    import com.imajuk.geom.Rect;
    import com.imajuk.geom.Circle;
    import com.imajuk.geom.IGeom;
    import com.imajuk.color.Color;
    import com.imajuk.geom.Doughnut;
    import com.imajuk.geom.Segment;
    import com.imajuk.interfaces.IMotionGuide;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.LineScaleMode;
    import flash.display.PixelSnapping;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageQuality;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * @author yamaharu
     */
    public class GraphicsUtil 
    {
        public static function getRoundRect(
                                    width:int,
                                    height:int,
                                    fillColor:Color,
                                    ellipseWidth:Number,
                                    lineTickness:Number,
                                    lineColor:Color):DisplayObject
        {
        	var spr:Sprite = new Sprite();
            var g:Graphics = spr.graphics;
            
            if (lineTickness > 0)
                g.lineStyle(lineTickness, lineColor.rgb, lineColor.alpha, true, LineScaleMode.NONE);
                
            g.beginFill(fillColor.rgb, fillColor.alpha);
            g.drawRoundRect(0, 0, width, height, ellipseWidth);
            g.endFill();
            
            return spr;
        }
        
        /**
         * 図形が描画されたビットマップを返す
    	 */
        public static function getRoundRectAsBitmap(
                                    width:int,
                                    height:int,
                                    fillColor:Color,
                                    ellipseWidth:int,
                                    lineTickness:Number,
                                    lineColor:Color,
                                    linePixelSnapping:Boolean):DisplayObject
        {
            var spr:Sprite = new Sprite();
            var g:Graphics = spr.graphics;
            
            if (lineTickness > 0)
                g.lineStyle(lineTickness, lineColor.rgb, lineColor.alpha, linePixelSnapping, LineScaleMode.NONE);
                
            g.beginFill(fillColor.rgb, fillColor.alpha);
            g.drawRoundRect(0, 0, width, height, ellipseWidth);
            g.endFill();
            var b:BitmapData = new BitmapData(width + lineTickness*2, height + lineTickness*2, true, 0);
            var s:Stage = StageReference.stage; 
            var temp:String = s.quality; 
            s.quality = StageQuality.BEST;
            b.draw(spr, new Matrix(1, 0, 0, 1, lineTickness, lineTickness));
            s.quality = temp;
            
            return new Bitmap(b, PixelSnapping.AUTO, true);
        }
        
        /**
         * p1~p2にラインを引く
         */
        public static function drawSegment(canvas:Graphics, p1:Point, p2:Point, color:uint = 0x00FF00, alpha:Number = 1):void
        {
            canvas.moveTo(p1.x, p1.y);
            canvas.lineStyle(1, color, alpha);
            canvas.lineTo(p2.x, p2.y);
            canvas.endFill();
        }

        /**
         * 点を描く
         */
        public static function drawPoint(canvas:Graphics, p:Point, color:uint = 0, alpha:Number = 1):void
        {
            canvas.beginFill(color, alpha);
            canvas.drawCircle(p.x, p.y, 2.5);
            canvas.endFill();
        }
        /**
         * 円を描く
         */
        public static function drawCircle(canvas : Graphics, size : int, color : uint = 0, x : Number = 0, y : Number = 0) : void
        {
            canvas.beginFill(color);
            canvas.drawCircle(x, y, size*.5);
            canvas.endFill();
        }

        /**
         * ドーナツ形状を描く
         */
        public static function drawDoughnut(canvas:Graphics, daughnut:Doughnut, color:uint = 0):void
        {
            canvas.beginFill(color);
            canvas.drawCircle(daughnut.x, daughnut.y, daughnut.outside.radius);            canvas.drawCircle(daughnut.x, daughnut.y, daughnut.inside.radius);
            canvas.endFill();
        }
        /**
         * 四角形を描く
         */        public static function drawRect(canvas:Graphics, rect:Rectangle, color:uint = 0, alpha:Number = 1):void        {
            canvas.beginFill(color, alpha);
            canvas.drawRect(rect.x, rect.y, rect.width, rect.height);
            canvas.endFill();
        }
		/**
		 * 四角形が描画されたSpriteを返す
		 */
        public static function getRectSprite(rect:Rectangle, color:uint = 0, alpha:Number = 1):Sprite
        {
            var s:Sprite = new Sprite();
            drawRect(s.graphics, rect, color, alpha);
            return s;
        }

        public static function drawCross(canvas : Graphics, p : Point, color : int = 0x0, size : int = 2, thickness:Number = 1, alpha : Number = 1) : void
        {
            canvas.lineStyle(thickness, color, alpha);
            canvas.moveTo(p.x - size, p.y - size);
            canvas.lineTo(p.x + size, p.y + size);
            canvas.moveTo(p.x + size, p.y - size);
            canvas.lineTo(p.x - size, p.y + size);
            canvas.endFill();
        }

        public static function drawSegments(g : Graphics, seg : Vector.<IMotionGuide>, fillColor : uint, lineColor : uint) : void
        {
            if (lineColor > 0)
                g.lineStyle(1, uint(lineColor & 0x00FFFFFF), uint(lineColor >> 24) / 0xFF);
            if (fillColor > 0)
                g.beginFill(uint(fillColor & 0x00FFFFFF), uint(fillColor >> 24) / 0xFF);
                
            seg.forEach(function(s : Segment, ...param) : void
            {
                g.moveTo(s.begin.x, s.begin.y);
                g.lineTo(s.end.x, s.end.y);
            });
            g.endFill();
        }

        public static function drawGeom(geom : IGeom, graphics : Graphics, fill : Color, line : Color = null, tickness : Number = 0) : void
        {
            if (fill)
                graphics.beginFill(fill.rgb, isNaN(fill.alpha) ? 1 : fill.alpha / 255);
            if (line)
                graphics.lineStyle(tickness, line.rgb, isNaN(line.alpha) ? 1 : line.alpha / 255);

            if (geom is Circle)
                graphics.drawCircle(geom.x, geom.y, Circle(geom).radius);
            else if (geom is Rect)
                graphics.drawRect(geom.x, geom.y, geom.width, geom.height);
        }
        
        public static function setGraphicsStyle(canvas : Graphics, fill : Color, line : Color, tickness : int) : void
        {
            if (fill)
                canvas.beginFill(fill.rgb, isNaN(fill.alpha) ? 1 : fill.alpha / 255);
            if (line)
                canvas.lineStyle(tickness, line.rgb, isNaN(line.alpha) ? 1 : line.alpha / 255);
        }
    }
}
