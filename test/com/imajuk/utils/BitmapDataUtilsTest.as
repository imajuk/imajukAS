package com.imajuk.utils
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.display.Bitmap;
    import flash.events.EventDispatcher;
    import com.imajuk.geom.Segment;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    
    import org.libspark.as3unit.after;
    import org.libspark.as3unit.assert.*;
    import org.libspark.as3unit.before;
    import org.libspark.as3unit.test;
    use namespace test;
    use namespace before;
    use namespace after;
    
    internal class BitmapDataUtilsTest extends Sprite
    {
        private static const BORDER_COLOR : uint = 0xff0000;
        private static const EMPTY_COLOR : uint = 0xCCCCCC;
        private static const FILL_COLOR : int = 0x0000ff;
        private var b : BitmapData;
        private var b2 : BitmapData;
        private var b3 : BitmapData;
        private var b4 : BitmapData;
        
        before function setup () : void
        {
            var a:Array, row:int, col:int;
            //■□□□■
            b = new BitmapData(5, 1, false, 0);
            b.setPixel(0, 0, BORDER_COLOR);
            b.setPixel(1, 0, EMPTY_COLOR);
            b.setPixel(2, 0, EMPTY_COLOR);
            b.setPixel(3, 0, EMPTY_COLOR);
            b.setPixel(4, 0, BORDER_COLOR);
            //■□■□■
            b2 = new BitmapData(5, 1, false, 0);
            b2.setPixel(0, 0, BORDER_COLOR);
            b2.setPixel(1, 0, EMPTY_COLOR);
            b2.setPixel(2, 0, BORDER_COLOR);
            b2.setPixel(3, 0, EMPTY_COLOR);
            b2.setPixel(4, 0, BORDER_COLOR);
            //1222000001
            a = [
                [1,2,2,2,0,0,0,0,0,1],
            ];
            b4 = new BitmapData(a[0].length, a.length, false, 0);
            for (row = 0; row < a.length; row++) {
                for (col = 0; col < a[row].length; col++) {
                    b4.setPixel(col, row, 
                        a[row][col] == 1 ? BORDER_COLOR : a[row][col] == 2 ? FILL_COLOR : EMPTY_COLOR
                    );
                }
            }
            
            
            //1111111111
            //1000000001
            //1001111001
            //1001001001
            //1001001001
            //1111111111
            a = [
                [1,1,1,1,1,1,1,1,1,1],
                [1,0,0,0,0,0,0,0,0,1],
                [1,0,0,1,1,1,1,0,0,1],
                [1,0,0,1,0,0,1,0,0,1],
                [1,0,0,1,0,0,1,0,0,1],
                [1,1,1,1,1,1,1,1,1,1]
            ];
            b3 = new BitmapData(a[0].length, a.length, false, 0);
            for (row = 0; row < a.length; row++) {
                for (col = 0; col < a[row].length; col++) {
                    b3.setPixel(col, row, a[row][col]==1?BORDER_COLOR:EMPTY_COLOR);
                }
            }
        }
        
        test function fill_1 ():void
        {
            var paint:EventDispatcher = BitmapDataUtil.fillByScanLine(b3, new Point(2, 4),EMPTY_COLOR);
            paint.addEventListener(Event.COMPLETE, async(function():void{
                var a:Array, row:int, col:int;
                a = [
                    [1,1,1,1,1,1,1,1,1,1],
                    [1,2,2,2,2,2,2,2,2,1],
                    [1,2,2,1,1,1,1,2,2,1],
                    [1,2,2,1,0,0,1,2,2,1],
                    [1,2,2,1,0,0,1,2,2,1],
                    [1,1,1,1,1,1,1,1,1,1]
                ];
                for (row = 0; row < a.length; row++) {
                    for (col = 0; col < a[row].length; col++) {
                        assertEquals( a[row][col] == 1 ? BORDER_COLOR : a[row][col] == 2 ? FILL_COLOR : EMPTY_COLOR, b3.getPixel(col, row));
                    }
                }
            }));
        }
        test function fill_2 ():void
        {
            var paint:EventDispatcher = BitmapDataUtil.fillByScanLine(b3, new Point(4, 4),EMPTY_COLOR);
            paint.addEventListener(Event.COMPLETE, async(function():void{
                var bmp:DisplayObject = StageReference.stage.addChild(new Bitmap(b3));
                bmp.scaleX = bmp.scaleY = 10;
                var a:Array, row:int, col:int;
                a = [
                    [1,1,1,1,1,1,1,1,1,1],
                    [1,0,0,0,0,0,0,0,0,1],
                    [1,0,0,1,1,1,1,0,0,1],
                    [1,0,0,1,2,2,1,0,0,1],
                    [1,0,0,1,2,2,1,0,0,1],
                    [1,1,1,1,1,1,1,1,1,1]
                ];
                for (row = 0; row < a.length; row++) {
                    for (col = 0; col < a[row].length; col++) {
                        assertEquals( a[row][col] == 1 ? BORDER_COLOR : a[row][col] == 2 ? FILL_COLOR : EMPTY_COLOR, b3.getPixel(col, row));
                    }
                }
            }));
        }

        /**
         * 左方向
         */
        // 起点が既に境界ならエラー
        test function scanLine_left () : void
        {
            try
            {
                BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(0, 0), -1, false);
                fail();
            }
            catch(e:Error)
            {
                assertEquals("seed point is not empty color.", e.message);
            }
            try
            {
                BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(4, 0), -1, false);
                fail();
            }
            catch(e:Error)
            {
                assertEquals("seed point is not empty color.", e.message);
            }
        }
        //塗りなし
        test function scanLine_left_nofill () : void
        {
            assertEquals(1, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(1, 0), -1, false));
            assertEquals(1, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(2, 0), -1, false));
            assertEquals(1, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(3, 0), -1, false));
            assertEquals(BORDER_COLOR, b.getPixel(0, 0));
            assertEquals(EMPTY_COLOR, b.getPixel(1, 0));
            assertEquals(EMPTY_COLOR, b.getPixel(2, 0));
            assertEquals(EMPTY_COLOR, b.getPixel(3, 0));
            assertEquals(BORDER_COLOR, b.getPixel(4, 0));
        }
        //塗り
        test function scanLine_left_fill_1 () : void
        {
            assertEquals(1, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(1, 0), -1, true, FILL_COLOR));
            assertEquals(BORDER_COLOR, b.getPixel(0, 0));
            assertEquals(FILL_COLOR,   b.getPixel(1, 0));
            assertEquals(EMPTY_COLOR,   b.getPixel(2, 0));
            assertEquals(EMPTY_COLOR,   b.getPixel(3, 0));
            assertEquals(BORDER_COLOR, b.getPixel(4, 0));
        }
        test function scanLine_left_fill_2 () : void
        {
            assertEquals(1, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(2, 0), -1, true, FILL_COLOR));
            assertEquals(BORDER_COLOR, b.getPixel(0, 0));
            assertEquals(FILL_COLOR, b.getPixel(1, 0));
            assertEquals(FILL_COLOR, b.getPixel(2, 0));
            assertEquals(EMPTY_COLOR, b.getPixel(3, 0));
            assertEquals(BORDER_COLOR, b.getPixel(4, 0));
        }
        test function scanLine_left_fill_3 () : void
        {
            assertEquals(1, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(3, 0), -1, true, FILL_COLOR));
            assertEquals(BORDER_COLOR, b.getPixel(0, 0));
            assertEquals(FILL_COLOR, b.getPixel(1, 0));
            assertEquals(FILL_COLOR, b.getPixel(2, 0));
            assertEquals(FILL_COLOR, b.getPixel(3, 0));
            assertEquals(BORDER_COLOR, b.getPixel(4, 0));
        }
        
        
        /**
         * 右方向
         */
        // 起点が既に境界ならエラー
        test function scanLine_right () : void
        {
            try
            {
                BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(0, 0), 1, false);
                fail();
            }
            catch(e:Error)
            {
                assertEquals("seed point is not empty color.", e.message);
            }
            try
            {
                BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(4, 0), 1, false);
                fail();
            }
            catch(e:Error)
            {
                assertEquals("seed point is not empty color.", e.message);
            }
        }
        //塗りなし
        test function scanLine_right_nofill () : void
        {
            assertEquals(3, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(1, 0), 1, false));
            assertEquals(3, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(2, 0), 1, false));
            assertEquals(3, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(3, 0), 1, false));
            assertEquals(BORDER_COLOR, b.getPixel(0, 0));
            assertEquals(EMPTY_COLOR,  b.getPixel(1, 0));
            assertEquals(EMPTY_COLOR,  b.getPixel(2, 0));
            assertEquals(EMPTY_COLOR,  b.getPixel(3, 0));
            assertEquals(BORDER_COLOR, b.getPixel(4, 0));
        }
        //塗り
        test function scanLine_right_fill_1 () : void
        {
            assertEquals(3, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(1, 0), 1, true, FILL_COLOR));
            assertEquals(BORDER_COLOR, b.getPixel(0, 0));
            assertEquals(FILL_COLOR,   b.getPixel(1, 0));
            assertEquals(FILL_COLOR,   b.getPixel(2, 0));
            assertEquals(FILL_COLOR,   b.getPixel(3, 0));
            assertEquals(BORDER_COLOR, b.getPixel(4, 0));
        }
        test function scanLine_right_fill_2 () : void
        {
            assertEquals(3, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(2, 0), 1, true, FILL_COLOR));
            assertEquals(BORDER_COLOR, b.getPixel(0, 0));
            assertEquals(EMPTY_COLOR, b.getPixel(1, 0));
            assertEquals(FILL_COLOR, b.getPixel(2, 0));
            assertEquals(FILL_COLOR, b.getPixel(3, 0));
            assertEquals(BORDER_COLOR, b.getPixel(4, 0));
        }
        test function scanLine_right_fill_3 () : void
        {
            assertEquals(3, BitmapDataUtil.scanLine(b, EMPTY_COLOR, new Point(3, 0), 1, true, FILL_COLOR));
            assertEquals(BORDER_COLOR, b.getPixel(0, 0));
            assertEquals(EMPTY_COLOR, b.getPixel(1, 0));
            assertEquals(EMPTY_COLOR, b.getPixel(2, 0));
            assertEquals(FILL_COLOR, b.getPixel(3, 0));
            assertEquals(BORDER_COLOR, b.getPixel(4, 0));
        }
        test function scanLine_right_fill_4 () : void
        {
            //1222000001
            assertEquals(8, BitmapDataUtil.scanLine(b4, EMPTY_COLOR, new Point(3, 0), 1, true, FILL_COLOR));
            assertEquals(BORDER_COLOR, b4.getPixel(0, 0));
            assertEquals(FILL_COLOR, b4.getPixel(1, 0));
            assertEquals(FILL_COLOR, b4.getPixel(2, 0));
            assertEquals(FILL_COLOR, b4.getPixel(3, 0));
            assertEquals(FILL_COLOR, b4.getPixel(4, 0));
            assertEquals(FILL_COLOR, b4.getPixel(5, 0));
            assertEquals(FILL_COLOR, b4.getPixel(6, 0));
            assertEquals(FILL_COLOR, b4.getPixel(7, 0));
            assertEquals(FILL_COLOR, b4.getPixel(8, 0));
            assertEquals(BORDER_COLOR, b4.getPixel(9, 0));
        }

        
        
        test function findAllBorders_ptn1 ():void
        {
            //■□□□■
            var a:Array;
            a = BitmapDataUtil.findAllBorders(b, Segment.createFromPoint(new Point(0, 0), new Point(4, 0)), EMPTY_COLOR);
            assertEquals(1, a.length);
            assertEquals(3, a[0]);
            a = BitmapDataUtil.findAllBorders(b, Segment.createFromPoint(new Point(1, 0), new Point(4, 0)), EMPTY_COLOR);
            assertEquals(1, a.length);
            assertEquals(3, a[0]);
            a = BitmapDataUtil.findAllBorders(b, Segment.createFromPoint(new Point(0, 0), new Point(3, 0)), EMPTY_COLOR);
            assertEquals(1, a.length);
            assertEquals(3, a[0]);
            a = BitmapDataUtil.findAllBorders(b, Segment.createFromPoint(new Point(1, 0), new Point(3, 0)), EMPTY_COLOR);
            assertEquals(1, a.length);
            assertEquals(3, a[0]);
            a = BitmapDataUtil.findAllBorders(b, Segment.createFromPoint(new Point(1, 0), new Point(2, 0)), EMPTY_COLOR);
            assertEquals(1, a.length);
            assertEquals(2, a[0]);
        }
        test function findAllBorders_ptn2 ():void
        {
            //■□■□■
            var a:Array;
            a = BitmapDataUtil.findAllBorders(b2, Segment.createFromPoint(new Point(0, 0), new Point(4, 0)), EMPTY_COLOR);
            assertEquals(2, a.length);
            assertEquals(1, a[0]);
            assertEquals(3, a[1]);
            a = BitmapDataUtil.findAllBorders(b2, Segment.createFromPoint(new Point(1, 0), new Point(4, 0)), EMPTY_COLOR);
            assertEquals(2, a.length);
            assertEquals(1, a[0]);
            assertEquals(3, a[1]);
            a = BitmapDataUtil.findAllBorders(b2, Segment.createFromPoint(new Point(0, 0), new Point(3, 0)), EMPTY_COLOR);
            assertEquals(2, a.length);
            assertEquals(1, a[0]);
            assertEquals(3, a[1]);
            a = BitmapDataUtil.findAllBorders(b2, Segment.createFromPoint(new Point(1, 0), new Point(3, 0)), EMPTY_COLOR);
            assertEquals(2, a.length);
            assertEquals(1, a[0]);
            assertEquals(3, a[1]);
            a = BitmapDataUtil.findAllBorders(b2, Segment.createFromPoint(new Point(1, 0), new Point(2, 0)), EMPTY_COLOR);
            assertEquals(1, a.length);
            assertEquals(1, a[0]);
        }
        
        
        

        after function teardown () : void
        {
        }
    }
}