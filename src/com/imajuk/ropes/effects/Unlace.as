package com.imajuk.ropes.effects
{
    import com.imajuk.geom.Vector2D;
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.shapes.IRopeShape;

    import flash.geom.Point;
    import flash.utils.Dictionary;



    /**
     * Unlaceエフェクトはコントロールポイントを自信のベクトルに垂直にオフセットします.
     * アンカーポイントはコントロールポイントの位置によって補完されます.
     * 
     * @author imajuk
     */
    public class Unlace implements IEffect
    {
        public static const IN_SIDE : String = "IN_SIDE";
        public static const OUT_SIDE : String = "OUT_SIDE";
        public static const BOTH_SIDE : String = "IN_OUT_SIDE";
        public const PRIORITY:int = 0;
        private const HALF_PI : Number = Math.PI * .5;
        
        public var min : Number;
        public var max : Number;
        public var speed : Number;
        
        private var localTime : Dictionary = new Dictionary(true);
        private var point : Point = new Point();
        private var shape : IRopeShape;
        private var mode : String;
        private var effectMask : Vector.<Number>;

        public function Unlace(shape : IRopeShape, min : Number = 2, max : Number = 4, speed : Number = .03, iteration : int = 40, mode : String = BOTH_SIDE, effectMask : Vector.<Number>=null)
        {
            this.shape = shape;
            this.min   = min;
            this.max   = max;
            this.speed = speed;
            this.iteration = iteration;
            this.mode = mode;
            this.effectMask = effectMask;
        }

        public function exec(cp : ControlPoint, shape:IRopeShape) : Point
        {
            if (this.shape !== shape) return cp;
            
            var a : Number, b : Number, t : Number,
                sin : Number, cos : Number,
                size : Number,
                v : Vector2D = Vector2D.createFromPoint(cp, cp.next);

            if (!localTime[cp]) localTime[cp] = 0;

            t = localTime[cp] += speed;

            // update size with range min~max
            size = (Math.cos(t) + 1) * ((max - min) / 2) + min;
            
            // decides movement sizes (-size~size)
            sin = Math.sin(t);
            b = sin * size;
            switch(mode)
            {
                case IN_SIDE:  //offset size to in side
                    b -= size;
                    break;
                case OUT_SIDE: //offset size to out side
                    b += size;
                    break;
            }
            
            //apply mask
            if (effectMask)
                b *= effectMask[cp.id-1];
            
            // decides vertex position
            a = v.angle - HALF_PI;
            sin = Math.sin(a);
            cos = Math.cos(a);
            
            // return updated position
            point.x = cp.x + cos * b;
            point.y = cp.y + sin * b;


            return point;
        }

        /**
         * ロープの始点から終点までのあいだに何往復するか
         */
        private var _iteration : int;
        public function get iteration() : int
        {
            return _iteration;
        }
        public function set iteration(cycle : int) : void
        {
            _iteration = cycle;

            const cntls : Array = shape.getControlPoints(),
                    inc : Number = Math.PI * cycle / shape.getAnchorPoints().length;

            var n : Number = 0;

            for each (var cp : ControlPoint in cntls)
                localTime[cp] = n += inc;
        }

        public function execLoopEndTask() : void
        {
        }

        public function execLoopStartTask() : void
        {
        }
    }
}
