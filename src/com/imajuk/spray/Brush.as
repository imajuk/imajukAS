package com.imajuk.spray 
{
    import flash.filters.BlurFilter;
    import com.imajuk.motion.TweensyThread;
    import com.imajuk.utils.MathUtil;

    import org.libspark.thread.EnterFrameThreadExecutor;
    import org.libspark.thread.Thread;

    import flash.geom.Point;
    import flash.events.EventDispatcher;
    import flash.geom.Rectangle;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    import flash.display.BlendMode;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.ColorTransform;
    import flash.display.BitmapData;

    import fl.motion.easing.Exponential;

    /**
     * @author shinyamaharu
     */
    public class Brush extends EventDispatcher 
    {
        private static const POINT : Point = new Point();
        public var initialized : Boolean = false;
        private var name : String = "unnamed";
        private var mat : Vector.<BitmapData>;
        private var materialCanvas : BitmapData;
        private var growBrushSize : TweensyThread;
        private var spread : Number;
        private var blend : String;
        private var blur : BlurFilter;

        private var _minBrushSize : int;
        
        public function get minBrushSize() : int
        {
            return _minBrushSize;
        }
        
        private var _maxBlushSize : int;
        
        public function get maxBlushSize() : int
        {
            return _maxBlushSize;
        }

        private var _blushSize : Number = 0;
        
        public function get blushSize() : Number
        {
            return _blushSize;
        }

        public function set blushSize(value : Number) : void
        {
            if (value > _maxBlushSize)
            	return;
            	
            _blushSize = value;
        }

        private var _color : ColorTransform = new ColorTransform();

        public function set color(value : uint) : void
        {
            _color.color = value;
        }

        public function Brush(
                            minBrushSize : int,
        					maxBlushSize : int,
        					spread : Number = .9, //顔料の広がり (値が大きいほど広い　.1 ~ .9)
        					blend : String = BlendMode.NORMAL,
        					blur : BlurFilter = null,
        					name : String = ""
        			    )
        {
            if (maxBlushSize <= 0)
        		throw new Error("the max size of brush should be more than 1");
            
            this._minBrushSize = minBrushSize;
            this._maxBlushSize = maxBlushSize;
            this.spread = spread;
            this.blend = blend;
            this.blur = blur;
            this.name = (name == "") ? this.name : name;
            
            if (!Thread.isReady)
                Thread.initialize(new EnterFrameThreadExecutor());
           
            build();
        }

        override public function toString() : String 
        {
            return "Brush[" + name + "(" + spread + ")]";
        }

        private function build() : void
        {
            materialCanvas = new BitmapData(400, 400);            
            if (mat)
            	return;
            	
            //preare material
            mat = Vector.<BitmapData>([ new BitmapData(1, 1, true, 0) ]);            
            var bs : int = 1;
            var intval : uint = 
                setInterval(
                    function():void
                    {
                        //一拭き分の素材を生成                        var material : BitmapData = getBrushMaterial(bs);
                        mat.push(material);
                            
                        //                Debug.draw(material);
            
                        if (++bs > _maxBlushSize)
                        {
                            initialized = true;
                            clearInterval(intval);
                            dispatchEvent(new Event(Event.INIT));
                        }
                    }, 10);        }

        private function getBrushMaterial(size : int) : BitmapData
        {
            var rad : Number = 0;
            var dis : Number = 0;
            
            //center of Bitmap
            var cx : Number = materialCanvas.width * .5;
            var cy : Number = materialCanvas.height * .5;
            
            //密度
            var density : Number = Exponential.easeIn(spread, 0.01, .1, 1);
            
            materialCanvas.lock();
            materialCanvas.fillRect(materialCanvas.rect, 0);
            while(dis < size)
            {
                rad += MathUtil.random(.05, .35);                dis += (size / maxBlushSize) * density;                var alp : Number = MathUtil.random(0x22, 0xCC);
                var t : Number = 0;
                while(alp > .3)                {
                    t += .8;                    drawPixel(materialCanvas, rad, dis + t, cx, cy, alp << 24);                    alp *= spread;                }
            }
            materialCanvas.unlock();
            
            if (blur)
                materialCanvas.applyFilter(materialCanvas, materialCanvas.rect, POINT, blur);
            
            var bounce : Rectangle = materialCanvas.getColorBoundsRect(0xFF000000, 0x00000000, false);
            var trimed : BitmapData = new BitmapData(bounce.width, bounce.height, true, 0);
            trimed.copyPixels(materialCanvas, bounce, POINT);
            
            return trimed;
        }

        private function drawPixel(
                            target : BitmapData, 
                            rad : Number, 
                            dis : Number, 
                            x : int, 
                            y : int, 
                            cl : uint
                        ) : void
        {
            x += Math.cos(rad) * dis;
            y += Math.sin(rad) * dis;
            target.setPixel32(x, y, cl);
        }

        /**
         * draw spray effect
         * @param cx			center x
         * @param cy			center y
         * @param instability	instability brush size (never over max brush size)
         */
        public function drawTo(
                            canvas : BitmapData, 
                            cx : int, 
                            cy : int, 
                            instable : Boolean = true
                        ) : void
        {
            if (!initialized)
        		throw new Error("not initialized still.");
        		
            if (_blushSize <= 1)
            	 return;
            	 
            if (mat.length <= _blushSize)
                return;
            	 
            
            var brushMaterial : BitmapData = (instable) ? mat[int(Math.random() * _blushSize)] : mat[mat.length - 1]; 
            var m : Matrix = new Matrix();
            m.translate(-brushMaterial.width * .5, -brushMaterial.height * .5);
            m.rotate(MathUtil.random(-Math.PI, Math.PI));
            m.translate(brushMaterial.width * .5, brushMaterial.height * .5);
            m.translate(cx - brushMaterial.width * .5, cy - brushMaterial.height * .5);            canvas.draw(brushMaterial, m, _color, blend);
        }

        public function changeBrushSizeTo(size : Number, duration:Number = .4, easing : Function = null) : void 
        {
            if (easing == null)
                easing = Exponential.easeOut;
                
            if (growBrushSize)
                growBrushSize.interrupt();
            
            growBrushSize = new TweensyThread(this, 0, duration, easing, null, {blushSize:size});
            growBrushSize.start();
        }
        
    }
}
