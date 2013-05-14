package com.imajuk.drawing 
{
    import flash.geom.Point;

    /**
     * @author shinyamaharu
     */
    public class BezierSegment 
    {
        public var a : Point;
        public var b : Point;
        public var c : Point;
        public var d : Point;
        private var _length : Number = NaN;

        public function BezierSegment(a : Point,b : Point,c : Point,d : Point) 
        {
            this.d = d;
            this.c = c;
            this.b = b;
            this.a = a;
        }

        public function toString() : String 
        {
            return "BezierSegment[" + length + "]";
        }

        public function getValue(t : Number) : Point 
        {
            if (t < 0) t = 0;            if (t > 1) t = 1;
            var t2:Number = 1 - t;            var tp3 : Number  = t * t * t;            var tp2 : Number  = t * t;            var t2p3 : Number = t2 * t2 * t2;
            var t2p2 : Number = t2 * t2;
            return new Point(
                    t2p3*a.x + 3*t2p2*t*b.x + 3*t2*tp2*c.x + tp3*d.x,
                    t2p3*a.y + 3*t2p2*t*b.y + 3*t2*tp2*c.y + tp3*d.y);
        }

        public function get length() : Number 
        {
            if (isNaN(_length))
            {
                var l : Number = 0;
                var pre : Point = a;                var cur : Point;
                var sensitive : Number = .01;                for (var t : Number = sensitive;t <= 1;t += sensitive) 
                {
                    cur = getValue(t);
                    var dx : Number = pre.x - cur.x;
                    var dy : Number = pre.y - cur.y;
                    l += Math.sqrt(dx * dx + dy * dy);
                    pre = cur;
                }
                _length = l;
            }
            return _length;
        }

        public function equals(bezier : BezierSegment) : Boolean 
        {
            return a.equals(bezier.a) && b.equals(bezier.b) && c.equals(bezier.c) && d.equals(bezier.d);
        }
    }
}
