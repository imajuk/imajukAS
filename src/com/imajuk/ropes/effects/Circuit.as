package com.imajuk.ropes.effects
{
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.models.PointQuery;
    import com.imajuk.ropes.shapes.IRopeShape;

    import flash.geom.Point;


    /**
     * @author imajuk
     */
    public class Circuit implements IEffect
    {
        public const PRIORITY:int = 1;
        public var speed : Number;
        private var t : Number = 0;
        private var shape : IRopeShape;

        public function Circuit(shape : IRopeShape, speed : Number = 0)
        {
            this.shape = shape;
            this.speed = speed;
        }

        public function exec(cp : ControlPoint, shape:IRopeShape) : Point
        {
            if (this.shape !== shape) return cp;
            
            var q : PointQuery = cp.pointQuery;
            q.time = q.rate + t;

            return shape.getPoint(q);
        }

        public function execLoopEndTask() : void
        {
            t += speed;
        }

        public function execLoopStartTask() : void
        {
        }
    }
}
