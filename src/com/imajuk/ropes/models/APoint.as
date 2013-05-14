package com.imajuk.ropes.models
{
    import flash.geom.Point;

    /**
     * @author imajuk
     */
    public class APoint extends Point
    {
        public var id : int;
        private var p1 : Point;
        private var p2 : Point;
        public var control : ControlPoint;
        public var next : APoint;
        public var prev : APoint;

        public function APoint(p1 : Point, p2 : Point)
        {
            super();

            this.p2 = p2;
            this.p1 = p1;

            calc();
        }

        override public function toString() : String
        {
            return "APoint[" + id + " / (" + int(x) + "," + int(y) + ")" + "control:" + (control ? control.id : "") + "/next:" + (next ? next.id : "") + "]";
        }

        public function calc() : void
        {
            x = p1.x + (p2.x - p1.x) * .5;
            y = p1.y + (p2.y - p1.y) * .5;
        }

        public function reset() : void
        {
            control.reset();
            calc();
        }
    }
}
