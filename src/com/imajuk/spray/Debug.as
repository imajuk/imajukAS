package com.imajuk.spray 
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.utils.StageReference;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;




    /**
     * @author imajuk
     */
    public class Debug 
    {
        private static var bx : Number = 0;
        private static var by : Number = 50;

        public static function draw(material : BitmapData) : void 
        {
            var bmp : DisplayObject = DocumentClass.container.addChild(new Bitmap(material));
            bmp.x = bx;
            bmp.y = by;
            bx += material.width; 
            if (bx > StageReference.stage.stageWidth)
            { 
                bx = 0;
                by += material.height;
            }
        }
    }
}
