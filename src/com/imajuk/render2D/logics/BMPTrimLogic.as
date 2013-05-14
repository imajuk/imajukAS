package com.imajuk.render2D.logics
{
    import com.imajuk.render2D.INodeFactory;
    import com.imajuk.render2D.IRenderLogic;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.Render2DCamrera;

    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;


    /**
     * @author imajuk
     */
    public class BMPTrimLogic implements IRenderLogic
    {
        private var clipRect : Rectangle;
        private var matrix : Matrix;
        private var resource : BitmapData;
        private var previousX : Number = NaN;
        private var previousY : Number = NaN;
        private var previousScale : Number = NaN;
        private var previousRad : Number = NaN;
        private var camera : Render2DCamrera;
        private var render2D : Render2D;

        public function BMPTrimLogic(resource : BitmapData)
        {
            this.resource = resource;
        }

        public function initialize(render2D:Render2D, factory:INodeFactory) : void
        {
            this.render2D = render2D;
            this.camera = render2D.camera;
            clipRect = new Rectangle(0, 0, camera.width, camera.height);
            matrix = new Matrix();
        }

        public function render() : void
        {
        	var vx : Number = camera.x;
            var vy : Number = camera.y;
            var s : Number = camera.scale;
            var rad:Number = camera.rad;
            
            var ns:Boolean = s   != previousScale; 
            var nr:Boolean = rad != previousRad; 
            
            if (vx == previousX && vy == previousY && !ns && !nr)
                return;
            
            var cos : Number = Math.cos(-rad); 
            var sin : Number = Math.sin(-rad);
            var dx : Number = -vx * s;
            var dy : Number = -vy * s;
                
            var tx : Number = dx * cos - dy * sin;
            var ty : Number = dx * sin + dy * cos;

            if (nr)
            {
                matrix = new Matrix();
                matrix.rotate(rad);
                matrix.scale(s, s);
                matrix.translate(tx, ty);
            }
            else
            {
                matrix.a = matrix.d = s;
                matrix.b = matrix.c = 0;
                matrix.tx = tx;
                matrix.ty = ty;
            }
            
            var g:Graphics = render2D.graphics;
            g.clear();
            g.beginBitmapFill(resource, matrix, false, true);
            g.drawRect(0, 0, camera.width, camera.height);
            g.endFill();
            
            previousX = camera.x;
            previousY = camera.y;
            previousScale = camera.scale;
            previousRad = camera.rad;
        }
    }
}
