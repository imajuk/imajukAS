package com.imajuk.utils
{
    import flash.geom.Point;
    import flash.display.BlendMode;
    import flash.display.Bitmap;
    import org.libspark.as3unit.assert.assertEquals;
    import org.libspark.as3unit.after;
    import org.libspark.as3unit.before;
    import org.libspark.as3unit.test;

    import flash.display.BitmapData;
    import flash.display.Sprite;

    /**
     * @author imajuk
     */
    public class BitmapDataUtilsTest4 extends Sprite
    {
        private var b : BitmapData;
        private var b2 : BitmapData;
        private var bmp : Bitmap;
        private var bmp2 : Bitmap;
        private var container : Sprite;

        before function setup() : void
        {
            container = new Sprite();
            container.scaleX = container.scaleY = 10;
            b = new BitmapData(5, 5, true, 0);
            b.setPixel32(0, 4, 0xffff3333);
            b.setPixel32(1, 4, 0xffff3333);
            b.setPixel32(2, 4, 0xffff3333);
            b.setPixel32(3, 4, 0xffff3333);
            b.setPixel32(4, 4, 0xffff3333);
            b.setPixel32(4, 0, 0xffff3333);
            b.setPixel32(4, 1, 0xffff3333);
            b.setPixel32(4, 2, 0xffff3333);
            b.setPixel32(4, 3, 0xffff3333);
            b.setPixel32(4, 4, 0xffff3333);
            b2 = new BitmapData(5, 5, false, 0x6666AA);
            bmp = new Bitmap(b);
            bmp2 = new Bitmap(b2);
            bmp2.blendMode = BlendMode.MULTIPLY;
            container.addChild(bmp);
            container.addChild(bmp2);
            container.graphics.lineStyle(.1, 0xcccccc);
            container.graphics.moveTo(0, 0);
            container.graphics.lineTo(5, 0);
            container.graphics.moveTo(0, 1);
            container.graphics.lineTo(5, 1);
            container.graphics.moveTo(0, 2);
            container.graphics.lineTo(5, 2);
            container.graphics.moveTo(0, 3);
            container.graphics.lineTo(5, 3);
            container.graphics.moveTo(0, 4);
            container.graphics.lineTo(5, 4);
            container.graphics.moveTo(0, 0);
            container.graphics.lineTo(0, 5);
            StageReference.stage.addChild(container);
            
        }
        
        test function nohit():void
        {
            var bx : int,by : int;
            
            bx = -5;
            by = 0;
            bmp2.x = bx;
            bmp2.y = by;
            
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }

        test function hit1px() : void
        {
            var bx : int,by : int;

            bx = -4;
            bmp2.x = bx;

            by = 4;
            bmp2.y = by;
            assertEquals('TR', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 3;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 2;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 1;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 0;
            bmp2.y = by;
            assertEquals('BR', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -1;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -2;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -3;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -4;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }

        test function hit2px() : void
        {
            var bx : int,by : int;
            bx = -3;
            bmp2.x = bx;

            by = 4;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 3;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 2;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 1;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 0;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -1;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -2;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -3;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -4;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }

        test function hit3px() : void
        {
            var bx : int,by : int;
            bx = -2;
            bmp2.x = bx;

            by = 4;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 3;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 2;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 1;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 0;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -1;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -2;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -3;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -4;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }
        
        test function hit4px() : void
        {
            var bx : int,by : int;
            bx = -1;
            bmp2.x = bx;

            by = 4;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 3;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 2;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 1;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 0;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -1;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -2;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -3;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -4;
            bmp2.y = by;
            assertEquals('NO_HIT', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }
        
        test function hit5px() : void
        {
            var bx : int,by : int;
            bx = 0;
            bmp2.x = bx;

            by = 4;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 3;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 2;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 1;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 0;
            bmp2.y = by;
            assertEquals('W', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -1;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -2;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -3;
            bmp2.y = by;
            assertEquals('R', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -4;
            bmp2.y = by;
            assertEquals('BR', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }
        
        test function hit4mpx() : void
        {
            var bx : int,by : int;
            bx = 1;
            bmp2.x = bx;

            by = 4;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 3;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 2;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 1;
            bmp2.y = by;
            assertEquals('TL', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 0;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -1;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -2;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -3;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -4;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }

        test function hit3mpx() : void
        {
            var bx : int,by : int;
            bx = 2;
            bmp2.x = bx;

            by = 4;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 3;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 2;
            bmp2.y = by;
            assertEquals('TL', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 1;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 0;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -1;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -2;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -3;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -4;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }

        test function hit2mpx() : void
        {
            var bx : int,by : int;
            bx = 3;
            bmp2.x = bx;

            by = 4;
            bmp2.y = by;
            assertEquals('T', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 3;
            bmp2.y = by;
            assertEquals('TL', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 2;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 1;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 0;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -1;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -2;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -3;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -4;
            bmp2.y = by;
            assertEquals('B', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }

        test function hit1mpx() : void
        {
            var bx : int,by : int;
            bx = 4;
            bmp2.x = bx;

            by = 4;
            bmp2.y = by;
            assertEquals('TL', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 3;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 2;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 1;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = 0;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -1;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -2;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -3;
            bmp2.y = by;
            assertEquals('L', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));

            by = -4;
            bmp2.y = by;
            assertEquals('BL', BitmapDataUtil.hitTest2(b, new Point(), b2, new Point(bx, by)));
        }

        after function teardown () : void
        {
            DisplayObjectUtil.removeChild(container);
        }
    }
}
