package com.imajuk.utils
{
    import flash.geom.Matrix;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.external.ExternalInterface;
    import flash.geom.Rectangle;

    /**
     * @author imajuk
     */
    public class DODoctor
    {
        //--------------------------------------------------------------------------
        //  Static Variables
        //--------------------------------------------------------------------------
        /**
         * Diagnostic Results 
         */
        internal static const NO_PROBLEM         : String = "detected no problem. the DisplayObject [ # ] should be display on Stage.";
        internal static const VISIBILITY_FALSE   : String = "the 'visible' property is 'false'.";
        internal static const TRANSPARENT        : String = "the 'alpha' property is 0.";
        internal static const NOT_IN_DISPLAYLIST : String = "the DisplayObject [ # ] doesn't exist in display list.";
        internal static const OUT_OF_STAGE       : String = "the DisplayObject [ # ] is out of stage";
        internal static const ZERO_SIZE          : String = "the 'width' or 'height' property may be 0, otherwise the 'scaleX' or 'scaleY' property is 0";
        internal static const ZERO_SIZE_MASK     : String = "the the DisplayObject [ # ] is completely masked by own mask object.";
        internal static const BLENDED_INTO_BG    : String = "the the DisplayObject [ # ] may be blended into the background.";
        internal static const COVERED_BY_OTHER_OBJECT : String = "COVERED_BY_OTHER_OBJECT";
        /**
         * For Output 
         */
        private static const PREFIX  : String = "/--------------------------------------------------------\n |\n |   Diagnostic Result About #\n |\n |   ";
        private static const POSTFIX : String = "\n |\n -------------------------------------------------------/";
        private static var stage : Stage;
        private static var trc : Function = trace;
        
        //--------------------------------------------------------------------------
        //  Static API
        //--------------------------------------------------------------------------
        /**
         * initialize DODoctor.
         * this method muse be called once before using DODoctor.
         * @param stage reference of stage 
         */
        public static function initialize(stage : Stage) : void
        {
            DODoctor.stage = stage;
        }
        /**
         * Ask DODoctor 'Why not?' if you can't see your DisplayObject on stage contrary to your expectations.
         * DODoctor try to answer why the DisplayObject is invisible.
         * @param dObj  target for diagnosis
         */
        public static function whyNot(dObj : DisplayObject) : DODoctor
        {
            if (!stage) throw new Error("DODoctor must be initialized once. call Diagnostic.initialize() method.");
            
            var result    : Array = [],
                pbounce   : Rectangle = getPixelBounce(dObj),
                stRect    : Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight),
                visible   : Boolean = dObj.visible,
                opaque    : Boolean = dObj.alpha > 0,
                hasWidth  : Boolean = dObj.width > 0,
                hasHeight : Boolean = dObj.height > 0,
                mask      : DisplayObject = dObj.mask;
            
            if (!dObj.stage) result.push(NOT_IN_DISPLAYLIST);
            if (!visible) result.push(VISIBILITY_FALSE);
            if (!opaque) result.push(TRANSPARENT);
            
            //------------------------
            // not renderd
            //------------------------
            if (!pbounce.containsRect(stRect) && !pbounce.intersects(stRect))
            {
                if (!hasWidth || !hasHeight) result.push(ZERO_SIZE);
                if (mask && (mask.width == 0 || mask.height == 0)) result.push(ZERO_SIZE_MASK);
                
                if (visible && opaque && hasWidth && hasHeight)
                    if (stage.align != "") result.push(OUT_OF_STAGE);
            }
            
            if (dObj.stage && visible && opaque && dObj.parent && hasWidth && hasHeight)
            {
                //------------------------
                // blending into BG
                //------------------------
                if (analyzePixels(compound(dObj, dObj.parent, true), "==")) result.push(BLENDED_INTO_BG);
                //------------------------
                // covered by other object
                //------------------------
                if (analyzePixels(compound(dObj, stage, false), "!=")) result.push(COVERED_BY_OTHER_OBJECT);
            }
            
            return new DODoctor(result.length == 0 ? [NO_PROBLEM] : result, dObj.name);
        }
        /**
         * @private
         */
        private static function compound(dObj:DisplayObject, eObj : DisplayObject, includeTargetInEnvironment:Boolean) : BitmapData
        {
            var bmpd : BitmapData = new BitmapData(dObj.width, dObj.height, false, stage.color),
                m    : Matrix = new Matrix();

            m.tx = -dObj.x;
            m.ty = -dObj.y;
            
            //------------------------
            // draw environment
            //------------------------
            if (includeTargetInEnvironment) dObj.visible = false;
            bmpd.draw(eObj, m, null, null, null, true);
            dObj.visible = true;
            
            //------------------------
            // draw target
            //------------------------
            bmpd.draw(dObj, null, dObj.transform.colorTransform, BlendMode.DIFFERENCE, null, true);
            
            return bmpd;
        }
        /**
         * @private
         */
        private static function analyzePixels(bmpd : BitmapData, expression : String) : Boolean
        {
            var result : Boolean = true,
                w : int = bmpd.width, h : int = bmpd.height,
                i : int, j : int;
            
            for (i = 0; i < h; i++)
            {
                for (j = 0; j < w; j++)
                {
                    switch(expression)
                    {
                        case "==":
                            result = result && (bmpd.getPixel32(j, i) == 0xFF000000);
                            break;
                        case "!=":
                            result = result && (bmpd.getPixel32(j, i) != 0xFF000000);
                            break;
                    }
                    if (!result) break;
                }
                if (!result) break;
            }

//            var bmp:Bitmap = new Bitmap(bmpd);
//            bmp.x = bmp.y = 200;
//            stage.addChild(bmp);
            bmpd.dispose();

            return result;
        }
        /**
         * @private
         */
        private static function getPixelBounce(dObj : DisplayObject) : Rectangle
        {
            var pbounce:Rectangle = dObj.transform.pixelBounds;
            
            //BitmapはpixelBoundsで正しいサイズが取得できない
            if (dObj is Bitmap)
            {
                pbounce.width = dObj.width;
                pbounce.height = dObj.height;
            }
            return pbounce;
        }
        //--------------------------------------------------------------------------
        //  Instance variables
        //--------------------------------------------------------------------------
        private var result : Array;
        private var name : String;
        //--------------------------------------------------------------------------
        //  Constructor
        //--------------------------------------------------------------------------
        public function DODoctor(result : Array, name : String)
        {
            this.name = name;
            this.result = result;
        }
        //--------------------------------------------------------------------------
        //  Instance API
        //--------------------------------------------------------------------------
        public function toString() : String {
            return (PREFIX
                   + result.join("\n |   ")
                   + POSTFIX)
                   .split("#").join(name);
        }
        /**
         * for test use
         */
        public function test(type : String) : Boolean
        {
            return  result.length == 1 && 
                    result.some(function(res:String, ...param) : Boolean
                    {
                        return res == type;
                    });
        }
        /**
         * output results to Flash standard output.
         */
        public function trace() : void
        {
            trc(this);
        }
        /**
         * output results to web browser's standard output. (console.log)
         */
        public function console() : void
        {
            if (!ExternalInterface.available) return;
            
            ExternalInterface.call(
                '(function(){if(console != null && console.log != null)console.log("' + 
                toString().split("'").join("\'").split("\n").join("\\n") + 
                '");})'
            );
        }

        public function alert() : void
        {
            if (!ExternalInterface.available) return;
            
            ExternalInterface.call(
                '(function(){alert("' + 
                toString().split("'").join("\'").split("\n").join("\\n") + 
                '");})');
        }

        public function func(f : Function) : void
        {
            if (f != null) f(this);
        }
    }
}
