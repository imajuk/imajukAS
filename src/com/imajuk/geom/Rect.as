package com.imajuk.geom 
{
    import flash.geom.Rectangle;	
    import flash.geom.Point;	
    /**
     * @author yamaharu
     * flash.geom.Rectangleを、IGeomの実装クラスとして振る舞わせるAdapter
     */
    public class Rect implements IGeom
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function Rect(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) 
        {
            _r = new Rectangle(x, y, width, height);
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        private var _r:Rectangle;
    	
        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        public function get x():Number
        {
            return _r.x;
        }
        
        public function set x(value:Number):void
        {
            _r.x = value;
        }

        public function get y():Number
        {
            return _r.y;
        }

        public function set y(value:Number):void
        {
            _r.y = value;
        }
        
        public function get width():Number
        {
            return _r.width;
        }

        public function set width(value:Number):void
        {
            _r.width = value;
        }
        
        public function get height():Number
        {
            return _r.height;
        }
        
        public function set height(value:Number):void
        {
            _r.height = value;
        }

        public function get size():Point
        {
            return _r.size;
        }
    	
        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------
    	
        public function toString():String 
        {
            return "Rect[x=" + x + ", y=" + y + ", width=" + width + ", height=" + height + "]";
        }

        public function clone():IGeom
        {
            return new Rect(_r.x, _r.y, _r.width, _r.height);
        }
        
        public function equals(rectangle:IGeom):Boolean
        {
            var r:Rect = rectangle as Rect;
            return (r) ? _r.equals(new Rectangle(r.x, r.y, r.width, r.height)) : false;
        }
        
        public function containsPoint(point:Point2D, includeOnLine:Boolean = true):Boolean
        {
            includeOnLine;
            return _r.containsPoint(new Point(point.x, point.y));
        }

        public function get left() : Number
        {
            return _r.left;
        }

        public function get right() : Number
        {
            return _r.right;
        }

        public function get top() : Number
        {
            return _r.top;
        }

        public function get bottom() : Number
        {
            return _r.bottom;
        }
    }
}
