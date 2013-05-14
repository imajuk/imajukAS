package com.imajuk.ropes.models
{
    import flash.geom.Point;

    /**
     * @author imajuk
     */
    public class ControlPoint extends Point
    {
        public var next : ControlPoint;
        public var ap : APoint = new APoint(new Point(), new Point());
        public var pointQuery : PointQuery = new PointQuery();

        private var _id : int;
        public function get id() : int
        {
            return _id;
        }
        
        private var _initX : Number;
        public function get initX() : Number
        {
            return _initX;
        }

        private var _initY : Number;
        public function get initY() : Number
        {
            return _initY;
        }
        
        public function ControlPoint(id : int, x : Number = 0, y : Number = 0, rate : Number = 0)
        {
            super(x, y);

            _id = id;
            pointQuery.rate = rate;

            _initX = x;
            _initY = y;
        }

        override public function toString() : String
        {
            return  "ControlPoint[id:" + _id + 
                    " init(" + _initX + "," + _initY + ")" + 
                    " now("  + x + "," + y + ")" + 
                    " rate:" + pointQuery.rate + 
                    " next:" + (next ? next._id : "null") + 
                    "]";
        }

        public function reset() : void
        {
            x = _initX;
            y = _initY;
        }


    }
}
