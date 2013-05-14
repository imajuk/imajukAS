package com.imajuk.sounds
{
    import org.libspark.thread.Thread;

    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.Shape;
    import flash.display.Stage;
    import flash.utils.ByteArray;

    /**
     * @author imajuk
     */
    public class SoundNormalizer
    {
        public static var isDebug       : Boolean;
        private static var display_level : Shape;
        private static var bin : ByteArray;
        

        public static function normalize(result : ByteArray) : Thread
        {
            return new NormalizeSoundThread(result);
        }

        internal static function drawDebugDisplay() : void
        {
            const   fromBinary : Vector.<Object> = bin.readObject(),
                  graphicsData : Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
            
            var     o : Object,
                gdata : IGraphicsData;
                
            for (var i : int = 0, l : int = fromBinary.length; i < l; i++)
            {
                o = fromBinary[i];

                if (o.hasOwnProperty("thickness"))
                    gdata = new GraphicsStroke(o.thickness, o.pixelHinting, o.scaleMode, o.caps, o.joints, o.miterLimit, new GraphicsSolidFill(o.fill.color, o.fill.alpha));
                else if (o.hasOwnProperty("winding"))
                    gdata = new GraphicsPath(o.commands, o.data, o.winding);

                graphicsData.push(gdata);
            }

            display_level.graphics.drawGraphicsData(graphicsData);
        }

        internal static function resetDebugDisplay() : void
        {
            display_level.graphics.clear();
            display_level.graphics.beginFill(0xeeeeee);
            display_level.graphics.drawRect(0, -100, 1000, 200);

            display_level.graphics.beginFill(0xddddff);
            display_level.graphics.drawRect(0, 100, 1000, 200);
            display_level.graphics.endFill();
        }

        public static function setDebugDisplay(stage : Stage, x : int = 0, y : int = 0) : void
        {
            isDebug = true;
            
            display_level = stage.addChild(new Shape()) as Shape;
                
            display_level.x = x;
            display_level.y = y + 100;
        }

        public static function getGraphicsData() : ByteArray
        {
            bin = new ByteArray();
            bin.shareable = true;
            return bin;
        }
    }
}
