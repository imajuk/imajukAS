package com.imajuk.geom 
{
    import flash.geom.Point;
    import flash.geom.Rectangle;
    /**
     * @author yamaharu
     * 円を表現するクラス
     */
    public class Circle extends Point2D implements IGeom
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function Circle(x:Number = 0, y:Number = 0, radius:Number = 0) 
        {
            super(x, y);
            this.radius = radius;
        }

        //--------------------------------------------------------------------------
        //
        //  Overridden properties
        //
        //--------------------------------------------------------------------------

        override public function get width():Number
        {
            return size;
        }

        override public function set width(value:Number):void
        {
            size = value;
        }

        override public function get height():Number
        {
            return size;
        }

        override  public function set height(value:Number):void
        {
            size = value;
        }

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------

        protected var _radius:Number;

        public function get radius():Number
        {
            return _radius;
        }

        public function set radius(value:Number):void
        {
            _radius = value;
        }

        public function get size():Number
        {
            return _radius * 2;
        }

        public function set size(value:Number):void
        {
            _radius = value * 0.5;
        }

        public function get center() : Point
        {
            return _p.clone();
        }

        public function get bounds() : Rectangle
        {
            return new Rectangle(x - _radius, y - _radius, _radius * 2, _radius * 2);
        }

        //--------------------------------------------------------------------------
        //
        //  Overridden methods
        //
        //--------------------------------------------------------------------------

        override public function toString():String 
        {
            return "Circle[x=" + x + ",y=" + y + ",radius=" + _radius + "]";
        }

        override public function clone():IGeom
        {
            return new Circle(x, y, radius);
        }

        override public function equals(circle:IGeom):Boolean
        {
            var c:Circle = circle as Circle;
            return (c) ? (radius == c.radius && x == c.x && y == c.y) : false;
        }

        override public function containsPoint(point:Point2D, includeOnLine:Boolean = true):Boolean
        {
            var p1:Point = new Point(x, y);
            p1.x *= 1000;
            p1.y *= 1000;
            var p2:Point = new Point(point.x, point.y);
            p2.x *= 1000;
            p2.y *= 1000;
            var d:Number = Point.distance(p1, p2) * 0.001;
            return (includeOnLine) ? _radius >= d : _radius > d;
        }

        public function containsCircle(circle : Circle) : Boolean
        {
            return Math.abs(Point.distance(center, circle.center)) + circle._radius <= _radius;
        }

        public function intersectionCircle(circle : Circle) : Boolean
        {
            return Math.abs(Point.distance(center, circle.center)) < _radius + circle.radius;
        }

        public function containsRect(rect : Rect) : Boolean
        {
            return bounds.containsRect(rect.toRectangle());
        }
        
        public function intersectionRect(rect : Rect) : Boolean
        {
            if(intersectionWithSegment(Segment.createFromPoint(rect.tl, rect.tr))) return true; //top
            if(intersectionWithSegment(Segment.createFromPoint(rect.bl, rect.br))) return true; //bottom
            if(intersectionWithSegment(Segment.createFromPoint(rect.tl, rect.bl))) return true; //left
            if(intersectionWithSegment(Segment.createFromPoint(rect.tr, rect.br))) return true; //right
            return false;
        }

        //参考：http://marupeke296.com/COL_2D_No5_PolygonToCircle.html
        public function intersectionWithSegment(seg : Segment) : Boolean
        {
            //d = |S×A| / |S|
            const a : Segment = Segment.createFromPoint(seg.begin, center);
            const d : Number = Math.abs(seg.vector.crossProduct(a.vector)) / seg.length;
            if (d > _radius) return false;
            
            // Dot(A, S) * Dot( B, S ) ≦ 0 : collision
            const b : Segment = Segment.createFromPoint(seg.end, center);
            const n : Number = a.vector.dotProduct(seg.vector) * b.vector.dotProduct(seg.vector);
            if (n <= 0) return true;
            
            //r > |A| or r > |B|なら衝突
            return _radius > a.length || _radius > b.length;
        }


    }
}
