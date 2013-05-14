package com.imajuk.spray 
{
    import com.imajuk.utils.PerformanceChecker;
    import com.imajuk.utils.MathUtil;
    import com.imajuk.color.ColorTone;

    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.display.BlendMode;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.display.Sprite;
    import flash.display.Bitmap;

    import com.bit101.components.PushButton;

    /**
     * @author shinyamaharu
     */
    public class SplaySample extends Sprite 
    {
        //=================================
        // view
        //=================================
        private var artBoard : Sprite;
        private var canvas : BitmapData;
        //=================================
        // drawing
        //=================================
        public var drawingMaterial : Brush;
        private var brushes : Array;
        private var cursor : Point = new Point();
        //=================================
        // coloring
        //=================================
        private var hue : Number = 0;
        private var tone : String;
        private var time : Number = 0;
        private var bIndex : int = 0;
        private var tIndex : Dictionary = new Dictionary(true);
        private var palette : Dictionary;
        private var palette1 : Array = [ ColorTone.LIGHT, ColorTone.BRIGHT, ColorTone.SOFT ];
        private var palette2 : Array = [ ColorTone.PALE, ColorTone.LIGHT ];
        //=================================
        // effect
        //=================================
        private var resetTone : Function;

        public function SplaySample()
        {
            //=================================
            // stage setting
            //=================================
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            var sw:int = stage.stageWidth;            var sh:int = stage.stageHeight;

            //=================================
            // background
            //=================================
            var loader : Loader = addChild(new Loader()) as Loader;
            loader.load(new URLRequest("wall0.png"));

            //=================================
            // canvas
            //=================================
            canvas = new BitmapData(sw, sh, true, 0);
            
            artBoard = addChild(new Sprite()) as Sprite;            artBoard.addChild(new Bitmap(canvas)).blendMode = BlendMode.MULTIPLY;
            
            //=================================
            // drawing materials
            //=================================
            var spray : Brush  = new Brush(10, 40, .9, BlendMode.NORMAL, null, "spray");
            var crayon : Brush = new Brush(20, 30, .3,  BlendMode.NORMAL, null, "crayon");
            brushes = [ crayon, spray ];
            
            //=================================
            // palette
            //=================================
            palette = new Dictionary(true);
            palette[spray] = palette1;
            palette[crayon] = palette2;
            resetTone = function():void
            {
                tIndex[spray] = 0;                tIndex[crayon] = 0;
            };
            resetTone();

            //=================================
            // drawing material
            //=================================             
            var me : SplaySample = this;
            drawingMaterial = spray;
            drawingMaterial.addEventListener(Event.INIT, function():void
            {
                drawingMaterial = brushes[0];
                new SprayCanvasInteraction(artBoard, me, cursor);
                var clear:PushButton = addChild(new PushButton(stage, sw - 55, sh-25, "clear", clearCanvas)) as PushButton;
                clear.setSize(50, 20);
            });
            
            
            addEventListener(Event.ENTER_FRAME, function():void
            {
                if (!drawingMaterial || !drawingMaterial.initialized)
                   return;
                
                changeColor();
                moveCursor();
                drawBrush();
            });
            
            PerformanceChecker.instance.initialize(this);
        }

        private function drawBrush() : void 
        {
            drawingMaterial.drawTo( canvas, cursor.x, cursor.y, true);
        }

        private function clearCanvas(...param) : void 
        {
            canvas.fillRect(canvas.rect, 0);
            resetTone();
            bIndex = 0;
        }

        public function changeDrawingMaterial() : void 
        {
            bIndex++;
            if (bIndex >= brushes.length)
                bIndex = 0;
            drawingMaterial = brushes[bIndex];
            drawingMaterial.changeBrushSizeTo(MathUtil.random(drawingMaterial.minBrushSize, drawingMaterial.maxBlushSize), 2);
        }

        public function changeTone() : void
        {
            var tones : Array = palette[drawingMaterial]; 
            tIndex[drawingMaterial] ++;
            if (tIndex[drawingMaterial] >= tones.length)
                tIndex[drawingMaterial] = 0;
                
            tone = tones[tIndex[drawingMaterial]];
            trace(drawingMaterial, tone);
        }

        private function changeColor() : void 
        {
            if (!tone)
                return;
                
            time += .001;
            drawingMaterial.color = ColorTone.getToneAs2(tone, hue += .2, Math.sin(time)).argb;
            if (hue >= 360)
                hue -= 360;        }

        private function moveCursor() : void 
        {            var vx : Number = mouseX - cursor.x;
            var vy : Number = mouseY - cursor.y;            cursor.x += vx * .1;
            cursor.y += vy * .1;
        }
    }
}
