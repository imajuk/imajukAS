package com.imajuk.spray 
{
    import com.imajuk.utils.MathUtil;

    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.filters.BlurFilter;
    import flash.display.BitmapData;

    /**
     * @author shinyamaharu
     */
    public class Stencil 
    {
        private static var data : String = "082004400fe01bb03ff82fe8282806c0";
        public static  function getStencil(b : BitmapData, width : int, height : int) : BitmapData 
        {
            var data2 : String = MathUtil.hexToBinary(data);
            
            var b2 : BitmapData = new BitmapData(b.width, b.height, true, 0);
            var w:int = 16;            var h:int = 8;
            var size : int = 18;
            var px : int = 0;
            var py : int = 0;
            var sx : int = (b.width - size * w) * .5;
            var sy : int = (b.height - size * h) * .5;
            b2.fillRect(new Rectangle(0, 0, sx, height), 0xFF000000);
            b2.fillRect(new Rectangle(width - sx, 0, sx, height), 0xFF000000);
            b2.fillRect(new Rectangle(0, 0, width, sy), 0xFF000000);
            b2.fillRect(new Rectangle(0, height - sy, width, sy), 0xFF000000);
            var c : int = 0;
            while(py < h)
            {
                while(px < w)
                {
                    var cl : uint;
                    switch(data2.charAt(c++))
                    {
                        case "0" :
                            cl = int(MathUtil.random(0xEE, 0xAA)) << 24;
                            break;
                        case "1" :                            cl = int(Math.random() * 0x15) << 24;
                            break;
                    }
                    b2.fillRect(new Rectangle(sx + px * size, sy + py * size, size, size), cl);
                    px++;
                }
                px = 0;
                py++;
            }
            b2.applyFilter(b2, b2.rect, new Point(), new BlurFilter(8, 8));
            
            return b2;
        }
    }
}
