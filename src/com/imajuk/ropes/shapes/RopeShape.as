package com.imajuk.ropes.shapes
{
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.drawing.BezierSegment;
    import com.imajuk.geom.Segment;
    import com.imajuk.geom.Vector2D;
    import com.imajuk.interfaces.IMotionGuide;
    import com.imajuk.ropes.models.PointQuery;
    import com.imajuk.ropes.models.APoint;

    import flash.geom.Point;



    /**
     * RopeShapeはロープのシェイプを定義する頂点（ガイドポイント）と直線のセットです.
     * 
     * @author imajuk
     */
    public class RopeShape implements IRopeShape
    {
        private static const POINT : Point = new Point();
        private static const BEZIER_FOR_CALC : BezierSegment = new BezierSegment(POINT, POINT, POINT, POINT);
        private var _name : String;
        private var _controls : Array;
        private var _anchors : Array;
        private var _segments : Vector.<IMotionGuide>;
        private var _isInitialized : Boolean;
        private var _length : Number;
        
        public function RopeShape(a : Array, name : String)
        {
            _name = name;
            _controls = a;
            _anchors = RopeShapeUtils.createAnchorsFromControlPoint(a);
            updateSegment();
            updateLength();
            _isInitialized = true;
        }
        
        
        private var _closed : Boolean = false;
        public function get closed() : Boolean
        {
            return _closed;
        }
        public function set closed(value : Boolean) : void
        {
            if (!_isInitialized) throw new Error("unInitialized");
            if (_closed == value) return;

            _closed = value;
            
            if (_closed)
            {
                // open -> close
                _controls.push(_controls[0]);
            }
            else
            {
                // close -> open
                _controls.pop();
            }

            // =================================
            // ガイドポイントを補完してアンカーポイントを作る
            // =================================
            _anchors = RopeShapeUtils.createAnchorsFromControlPoint(_controls);
        }

        public function toString() : String
        {
            return "RopeShape[" + _name + "]";
        }

        public function getPoint(q : PointQuery) : Point
        {
            var time : Number = q.time;
                
            if (time < 0)
                return Segment(_segments[0]).begin;
            else if (time > 1) 
                time %= 1;
            
            const          aps : int = _anchors.length - 1,
                           idx : int = time * aps,
                          rate : Number = 1 / aps,
                    local_time : Number = (time - idx * rate) / rate,
                            ap : APoint = _anchors[idx],
                          ctrl : ControlPoint = ap.control,
                         ap_nx : APoint = ap.next;
                         
            BEZIER_FOR_CALC.a = new Point(ap.x, ap.y);
            BEZIER_FOR_CALC.b = new Point(ctrl.x, ctrl.y);
            BEZIER_FOR_CALC.c = new Point(ctrl.x, ctrl.y);
            BEZIER_FOR_CALC.d = ap_nx ? new Point(ap_nx.x, ap_nx.y) : POINT;
            
            return BEZIER_FOR_CALC.getValue(local_time);
        }

        public function getVector(time : Number) : Vector2D
        {
            if (time < 0)
                return Vector2D.create(-Math.PI * .5);

            time %= 1;
            var u : Number = 1 / _segments.length;
            var s : IMotionGuide = _segments[int(time / u)];
            return Segment(s).vector;
        }

        public function get length() : Number
        {
            return _length;
        }

        public function getControlPoints() : Array
        {
            return _controls;
        }

        public function getSegments() : Vector.<IMotionGuide>
        {
            return _segments;
        }

        public function getAnchorPoints() : Array
        {
            return _anchors;
        }

        public function get isInitialized() : Boolean
        {
            return _isInitialized;
        }

        public function updateSegment() : void
        {
            _segments = RopeShapeUtils.createSegments(_controls);
        }
        
        public function updateLength():void
        {
            _length = 0;
            _segments.forEach(function(s : Segment, ...param) : void
            {
                _length += s.length;
            });
        }
    }
}
