package com.imajuk.sounds
{
    import flash.events.Event;
    import flash.utils.Dictionary;
    import com.imajuk.threads.ThreadUtil;

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
        private static var dispatchQueue : Dictionary = new Dictionary(true);

        /**
         * load sound file and normalize it.
         * 
         * IMPORTANT
         *   SoundNormalizer uses Worker that is latest Flash tecnology.
         *   You need to compile your project with the compiler option 'swf-version=17'.
         *   The project will require the version Flash Player 11.4 or later.
         * 
         * Here's the example how to normilize and play the sound.
         * 
         *  SoundNormalizer.loadAndNormalize("http://imajuk.com/music.mp3");
         *  SoundNormalizer.addEventListener(SoundNormalizerEvent.COMPLETE, function(e : SoundNormalizerEvent) : void
         *  {
         *      // the sound loaded and normalized.
         *      // you can play the binary with SoundBinaryPlayer.
         *      new SoundBinaryPlayer().play(e.soundBinary);
         *   });
         *   
         */
        public static function loadAndNormalize(sound_url : String) : void
        {
            ThreadUtil.initAsEnterFrame();
            
            var soundBinary:ByteArray = new ByteArray();
            soundBinary.shareable = true;
            new SoundNormalizerThread(sound_url, soundBinary, dispatchEvent).start();
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

        public static function addEventListener(eventtype : String, listener : Function) : void
        {
            dispatchQueue[eventtype] = dispatchQueue[eventtype] || new Vector.<Function>; 
            dispatchQueue[eventtype].push(listener);
        }
        
        public static function dispatchEvent(event:Event):void
        {
            var listenrs:Vector.<Function> = dispatchQueue[event.type];
            if (!listenrs) return;
            
            while(listenrs.length > 0)
            {
                listenrs.shift()(event);
            }
        }
    }
}

