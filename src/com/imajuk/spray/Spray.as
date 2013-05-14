package com.imajuk.spray 
{
    import flash.display.BlendMode;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    import fl.motion.easing.Quadratic;

    import flash.geom.Matrix;
    import flash.display.BitmapData;

    import com.imajuk.utils.GraphicsUtil;

    import flash.display.Sprite;

    /**
     * @author shinyamaharu
     */
    public class Spray 
    {
        private static const POINT : Point = new Point();
        public static const BOTH : String = "BOTH";
        public static const DARKEN : String = "DARKEN";
        public static const LIGHTEN : String = "LIGHTEN";
        
        private var half : Number;
        private var maxRadius : Number;
        private var center : Number;
        private var maxSize : int;
        private var _spread : Number;
        private var _color : uint;
        private var mode : String;
        private var preRenderAmount : int;
        private var preRenderCounter : int = 0;
        private var brush : BitmapData;
        private var circleBMP : BitmapData;
        private var densities : Array;
        private var alphas : Array;
        private var ram : Array;
        private var p : Point = new Point();        private var p2 : Point = new Point();
        private var m : Matrix = new Matrix();
        private var preBrush : Array = [];
        private var preRenderIndex : Array;
        private var isPreRendered : Boolean = false;
        private var circleBMPRect : Rectangle;

        public function get color() : uint
        {
            return _color;
        }

        public function set color(value : uint) : void
        {
            _color = value;
            if (circleBMP)
            	circleBMP.dispose();
            circleBMP = buildCircle(_color);
            circleBMPRect = circleBMP.rect;
        }

        private var _brushSize : int;

        public function get brushSize() : int
        {
            return _brushSize;
        }

        public function set brushSize(value : int) : void
        {
            if (value == _brushSize)
            	return;
            	
            if (value <= 5)
            	value = 5;
            	
            _brushSize = value;
            
            half = _brushSize * .5;
            maxSize = _brushSize * _spread;
            center = maxSize * .5;
            maxRadius = center;
            
            buildBrush();
            
            color = _color;
        }

        /**
         * 
         */
        public function Spray(
        					size : int,
        					spread : Number = 2,
        					color : uint = 0xFF000000, 
        					mode : String = BOTH) 
        {
            _spread = spread;
            
            this.brushSize = size;
            this.color = color;
            this.mode = mode;
            
            ram = [];
            var time : int = 0;
            while(time++ < 10000)
            {
                ram.push(Math.random());	
            }
        }

        public function destroy() : void
        {
            brush.dispose();
            brush = null;
            
            if (circleBMP)
            	circleBMP.dispose();
            circleBMP = null;
            circleBMPRect = null;
            
            densities = null;
            alphas = null;
            ram = null;
            p = null;
            m = null;
            preBrush = null;
            preRenderIndex = null;
        }

        private function buildBrush() : void
        {
            //pre-calculate
            var duration : Number = (maxSize - _brushSize);
            var time : int = 0;
            densities = [];
            alphas = [];
            while(time++ < duration)
            {
                densities[time] = Quadratic.easeOut(time, .1, .5, duration);  
                alphas[time] = Quadratic.easeInOut(time, 0xFF, -0xFF, duration);
            }
             
            //brush   
            if (brush)
            	brush.dispose();
            brush = new BitmapData(maxSize, maxSize, true, 0);
        }

        private function buildCircle(color : uint) : BitmapData
        {
            var circle : Sprite = new Sprite();
            GraphicsUtil.drawCircle(circle.graphics, _brushSize, color);
            
            var bmp : BitmapData = new BitmapData(_brushSize, _brushSize, true, 0);
            bmp.draw(circle, new Matrix(1, 0, 0, 1, half, half));
            circle.graphics.clear();
            
            return bmp;
        }

        public function drawBrush(canvas : BitmapData, mx : Number, my : Number) : void
        {
            //preRenderされている場合はキャッシュを使う
            brush = (isPreRendered) ? 
            	preBrush[preRenderIndex[preRenderCounter++]] : 
            	getBrush();

            p.x = mx - half;
            p.y = my - half;
            
            //円を描画
            canvas.copyPixels(circleBMP, circleBMP.rect, p, circleBMP, POINT, true);
                
            m.tx = mx - maxRadius;
            m.ty = my - maxRadius;
            
            if (mode == BOTH || mode == DARKEN)            	canvas.draw(brush, m, null, BlendMode.DARKEN);
            if (mode == BOTH || mode == LIGHTEN)
	        	canvas.draw(brush, m, null, BlendMode.LIGHTEN);
        }
        
        public function drawBrush2(
        					canvas : BitmapData,
        					mx : Number,
        					my : Number,
        					maskLayer : BitmapData
        				) : void
        {
        	//preRenderされている場合はキャッシュを使う
            brush = (isPreRendered) ? 
            	preBrush[preRenderIndex[preRenderCounter++]] : 
            	getBrush();

            p.x = mx - half;
            p.y = my - half;
            
            //円を描画
            canvas.copyPixels(circleBMP, circleBMPRect, p, maskLayer, p, true);
            
            p2.x = mx - maxRadius;            p2.y = my - maxRadius;
            
            canvas.copyPixels(brush, brush.rect, p2, maskLayer, p2, true);
        }
        
        private function getBrush() : BitmapData
        {
        	var time : int = 0;
        	var radius : Number = half;
            var rad : Number;
            var c : uint = uint(_color & 0x00FFFFFF);
            var pi : Number = Math.PI;
            var rect : Rectangle = brush.rect; 
	            
            var cnt : int = 0;
            var rcnt : int = 0;
            
        	brush.lock();
            brush.fillRect(rect, 0);
                
            while(radius < maxRadius)
            {
                var density : Number = densities[time];
                var a : Number = alphas[time];
                rad = -pi + ram[rcnt++] * density;
                
                var cl : uint = c | a << 24;
                    
                while (rad < pi)
                {
                    var px : Number = Math.cos(rad) * radius + center;
                    var py : Number = Math.sin(rad) * radius + center;
                    rad += ram[rcnt++] * density;
                    brush.setPixel32(px, py, cl);
                }
                radius += .3;
                     
                time++;
                cnt++;
            }
                
            brush.unlock();
            
            return brush;
        }
        
        public function preRender(amount:int = 10) : void
        {
        	preRenderAmount = amount;
        	preRenderIndex = [];
        	preRenderCounter = 0;
        	isPreRendered = true;
        	
            var c2:int = 0;
        	while(c2++ < 10000)
        	{
                preRenderIndex.push(int(Math.random() * amount));
            }
        	            var c:int = 0;
            while(c++ < amount)
	        {
	        	preBrush.push(getBrush());
	        }	
        }
    }
}
