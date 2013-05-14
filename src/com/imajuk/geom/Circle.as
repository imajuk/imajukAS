package com.imajuk.geom 
{
    import flash.geom.Point;	
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
    }
}
