package com.imajuk.graphics
{
    import com.imajuk.utils.StageReference;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    /**
     * @author imajuk
     */
    public class AlignCalc
    {
    	private static function getCenterV(offsetV:Number):Number
        {
            return (StageReference.stage.stageHeight - AlignTestUtil.globalPixelBounds.height) * .5 + offsetV;
        }

        private static function getCenterH(offsetH:Number):Number
        {
            return (StageReference.stage.stageWidth - AlignTestUtil.globalPixelBounds.width) * .5 + offsetH;
        }

        private static function getRight(offsetH:Number):Number
        {
            return StageReference.stage.stageWidth - AlignTestUtil.globalPixelBounds.width + offsetH;
        }

        private static function getBottom(offsetV:Number):Number
        {
            return StageReference.stage.stageHeight - AlignTestUtil.globalPixelBounds.height + offsetV;
        }

        private static function checkBottom(offsetV:Number, toleranceY:int):Boolean
        {
            var shouldBe : Number = getBottom(offsetV);
            var actual : Number = AlignTestUtil.globalPixelBounds.y;
            return Math.abs(actual - shouldBe) <= toleranceY;
        }

        private static function checkRight(offsetH:Number, toleranceX:int):Boolean
        {
            return Math.abs(getRight(offsetH) - AlignTestUtil.globalPixelBounds.x) <= toleranceX;
        }

        private static function checkTop(offsetV:Number, toleranceY:int):Boolean
        {
//        	trace("checkTop");
            var should : Number =offsetV;
            var actual : Number = AlignTestUtil.globalPixelBounds.y;
//            trace('should: ' + (should));
//            trace('actual: ' + (actual));
//            trace(Math.abs(actual - should) <= toleranceY);
            return Math.abs(actual - should) <= toleranceY;
        }

        private static function checkLeft(offsetH:Number, toleranceX:int):Boolean
        {
//        	trace("checkLeft");
        	var should:Number = offsetH;
            var actual : Number = AlignTestUtil.globalPixelBounds.x;
//            trace('should: ' + (should));
//            trace('actual: ' + (actual));
//            trace(Math.abs(should - actual) <= toleranceX);
            return Math.abs(should - actual) <= toleranceX;
        }

        private static function checkCenterH(offsetH:Number, toleranceX:int):Boolean
        {
            //ターゲットのあるべき値
            var shouuldBe:Number = getCenterH(offsetH);
            //実際の値
            var actual:Number = AlignTestUtil.globalPixelBounds.x;
//            trace('shouuldBe: ' + (shouuldBe));
//            trace('actual: ' + (actual));
            
            return Math.abs(shouuldBe - actual) <= toleranceX;
        }

        private static function checkCenterV(offsetV:Number, toleranceY:int):Boolean
        {
            return Math.abs(AlignTestUtil.globalPixelBounds.y - getCenterV(offsetV)) <= toleranceY;
        }

        ////////////////////////////////////////////////////////////////////////////////////////////
        internal static function testT(offsetH:Number = 0, offsetV:Number = 0, toleranceX:int = 1, toleranceY:int = 0):Boolean
        {
            return  checkCenterH(offsetH, toleranceX) && checkTop(offsetV, toleranceY);
        }

        internal static function testTR(offsetH:Number = 0,offsetV:Number = 0, toleranceX:int = 1, toleranceY:int = 0):Boolean
        {
            return  checkRight(offsetH, toleranceX) && checkTop(offsetV, toleranceY);
        }

        internal static function testTL(offsetH:Number = 0,offsetV:Number = 0, toleranceX:int = 1, toleranceY:int = 0):Boolean
        {
            return  checkLeft(offsetH, toleranceX) && checkTop(offsetV, toleranceY);
        }

        internal static function testCL(offsetH:Number = 0,offsetV:Number = 0, toleranceX:int = 0, toleranceY:int = 1):Boolean
        {
            return  checkLeft(offsetH, toleranceX) && checkCenterV(offsetV, toleranceY);
        }

        internal static function testC(offsetH:Number = 0,offsetV:Number = 0, toleranceX:int = 1, toleranceY:int = 1):Boolean
        {
            return  checkCenterH(offsetH, toleranceX) && checkCenterV(offsetV, toleranceY);
        }

        internal static function testCR(offsetH:Number = 0,offsetV:Number = 0, toleranceX:int = 1, toleranceY:int = 1):Boolean
        {
            return  checkRight(offsetH, toleranceX) && checkCenterV(offsetV, toleranceY);
        }

        internal static function testB(offsetH:Number = 0,offsetV:Number = 0, toleranceX:int = 1, toleranceY:int = 0):Boolean
        {
            return  checkCenterH(offsetH, toleranceX) && checkBottom(offsetV, toleranceY);
        }

        internal static function testBL(offsetH:Number = 0,offsetV:Number = 0, toleranceX:int = 0,toleranceY:int = 0):Boolean
        {
            return checkLeft(offsetH, toleranceX) && checkBottom(offsetV, toleranceY);
        }

        internal static function testBR(offsetH:Number = 0,offsetV:Number = 0, toleranceX:int = 1, toleranceY:int = 0):Boolean
        {
            return checkRight(offsetH, toleranceX) && checkBottom(offsetV, toleranceY);
        }

        internal static function testTR_local(coordinateSpaceTarget:DisplayObjectContainer, toleranceX:int = 1, toleranceY:int = 0):Boolean
        {
            var a:Number = coordinateSpaceTarget.x + 400 - AlignTestUtil.globalPixelBounds.width; 
            return Math.abs(a - AlignTestUtil.globalPixelBounds.x) <= toleranceX && Math.abs(coordinateSpaceTarget.y - AlignTestUtil.globalPixelBounds.y) <= toleranceY;
        }

        internal static function testTL_local(coordinateSpaceTarget:DisplayObjectContainer, toleranceX:int = 1, toleranceY:int = 0):Boolean
        {
            var r:Rectangle = AlignTestUtil.globalPixelBounds;
            var result:Boolean = Math.abs(coordinateSpaceTarget.x - r.x) <= toleranceX && Math.abs(coordinateSpaceTarget.y - r.y) <= toleranceY;
            if (!result)
                trace(r, coordinateSpaceTarget.x, coordinateSpaceTarget.y);
                 
            return result;
        }

        internal static function testT_local(coordinateSpaceTarget:DisplayObjectContainer, displayObject:Sprite, container2:DisplayObjectContainer = null, toleranceX:int = 1, toleranceY:int = 0):Boolean
        {
            var cx:Number = (container2) ? container2.x * .5 : 0 ;
            var actual:Rectangle = AlignTestUtil.globalPixelBounds;
            var shouldBe:Number = coordinateSpaceTarget.x + (400 + cx - actual.width) * .5;
            trace('shouldBe: ' + (shouldBe), coordinateSpaceTarget.x, cx);
            trace('actual: ' + (actual));
            var b:Boolean = !container2 || (container2 && container2.contains(displayObject));
            //1pxの誤差は許す 
            return Math.abs(shouldBe - actual.x) <= toleranceX && Math.abs(coordinateSpaceTarget.y - actual.y) <= toleranceY && b;
        }
    }
}
