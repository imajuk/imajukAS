package com.imajuk.ropes.effects
{
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.shapes.IRopeShape;
    import com.imajuk.utils.MathUtil;

    import flash.geom.Point;



    /**
     * @author imajuk
     */
    public class Noise implements IEffect
    {
        public const PRIORITY:int = 0;

        private var point : Point = new Point();
        private var shape : IRopeShape;
        public var min : Number;
        public var max : Number;

        public function Noise(shape : IRopeShape, min : Number = 1, max : Number = 3)
        {
            this.shape = shape;
            this.min = min;
            this.max = max;
        }

        public function exec(cp : ControlPoint, shape:IRopeShape) : Point
        {
            if (this.shape !== shape) return cp;
            
            var a : Number, b : Number;

            b = MathUtil.random(min, max);
            a = MathUtil.random(-Math.PI, Math.PI);

            point.x = cp.x + Math.cos(a) * b;
            point.y = cp.y + Math.sin(a) * b;

            return point;
        }

        public function execLoopEndTask() : void
        {
        }

        public function execLoopStartTask() : void
        {
        }
    }
}
