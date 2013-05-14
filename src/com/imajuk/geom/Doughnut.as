package com.imajuk.geom 
{
    /**
     * @author yamaharu
     * ドーナッツ形状を表す。
     */
    public class Doughnut extends Circle  implements IGeom
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function Doughnut(x:Number = 0, y:Number = 0, outside:Number = 0, inside:Number = 0)
        {
            super(x, y, outside * 0.5);
            this.outside = new Circle(x, y, outside * 0.5);
            this.inside = new Circle(x, y, inside * 0.5);
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        private var _outside:Circle;
        private var _inside:Circle;

        //--------------------------------------------------------------------------
        //
        //  Overridden properties
        //
        //--------------------------------------------------------------------------

        override public function set x(value:Number):void
        {
            super.x = value;
            _outside.x = value;
            _inside.x = value;
        }

        override public function set y(value:Number):void
        {
            super.y = value;
            _outside.y = value;
            _inside.y = value;
        }

        override public function get size():Number
        {
            return _outside.size;
        }

        override public function set size(value:Number):void
        {
            var t:Number = thickness;
            _outside.size = value;
            _inside.size = (value * 1000 - t * 1000) * 0.001;
            super.size = value;
        }

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        public function get outside():Circle
        {
            return _outside;
        }
        
        public function set outside(value:Circle):void
        {
            _outside = value;
            _outside.x = x;
            _outside.y = y;
        }
        
        public function get inside():Circle
        {
            return _inside;
        }
        
        public function set inside(value:Circle ):void
        {
            _inside = value;
            _inside.x = x;
            _inside.y = y;
        }
        
        public function get thickness():Number
        {
            return (outside.size * 1000 - _inside.size * 1000) * 0.001;
        }
		
        //--------------------------------------------------------------------------
        //
        //  Overridden methods
        //
        //--------------------------------------------------------------------------
        
        override public function toString():String 
        {
            return "Doughnut[x=" + x + ",y=" + y + ",out=" + outside + ",in=" + inside + "]";
        }
        
        /**
         * 任意の点とドーナツ形状が触れているかどうかを返す
         */
        override public function containsPoint(__p:Point2D, __includeOnLine:Boolean = true):Boolean
        {
            return outside.containsPoint(__p, __includeOnLine) && !(_inside.containsPoint(__p, !__includeOnLine));
        }
        
        override public function clone():IGeom
        {
            return new Doughnut(x, y, _outside.size, _inside.size);
        }
        
        override public function equals(doughnut:IGeom):Boolean
        {
            var d:Doughnut = doughnut as Doughnut;
            return (d) ? (_outside.equals(d.outside) && _inside.equals(d.inside) && x == d.x && y == d.y) : false;
        }
    }
}
