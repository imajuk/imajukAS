package com.imajuk.render2D.plugins.bmptiles 
{
    import com.imajuk.render2D.plugins.tile.AbstractTileNode;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import flash.geom.Point;


    /**
     * @author shinyamaharu
     */
    public class BmpNode extends AbstractTileNode 
    {
        private static const POINT : Point = new Point();
        protected var canvas : BitmapData;
        
        public function BmpNode(
        					sx : Number,
        					sy : Number,
        					nodeWidth : int,
        					nodeHeight : int,
        					cols : int,
        					rows : int
        				)
        {
            super(sx, sy, cols, rows);

            canvas = new BitmapData(nodeWidth + 1, nodeHeight + 1, true, 0);
            var bmp : Bitmap = new Bitmap(canvas, PixelSnapping.AUTO, true);
            addChild(bmp);
        }

        public function setCanvas(b : BitmapData) : void
        {
            canvas.copyPixels(b, b.rect, POINT);
        }

        public function getCanvas() : BitmapData
        {
            return canvas;
        }
    }
}
