package com.imajuk.ropes.shapes
{
    import com.imajuk.drawing.BezierSegment;
    import com.imajuk.geom.Segment;
    import com.imajuk.geom.Vector2D;
    import com.imajuk.interfaces.IMotionGuide;
    import com.imajuk.ropes.models.APoint;
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.models.PointAnimateInfo;

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
        private static var sid : int;
        private var _name : String;
        private var _controls : Array;
        private var _anchors : Array;
        private var _segments : Vector.<IMotionGuide>;
        private var _isInitialized : Boolean;
        private var _length : Number;
        private var _id : int;
        private var _amount : int;
        
        public function RopeShape(a : Array, name : String)
        {
            _id = sid++;
            _name = name;
            _controls = a;
            _anchors = RopeShapeUtils.createAnchorsFromControlPoint(a);
            _amount = _controls.length;
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
            return "RopeShape[ " + 
                        (_id) +
                        " "+_name + 
                   " ]";
        }

        /**
         * このシェイプが持つ曲線の任意の1点を返します.
         * @param q
         */
        public function getPoint(q : PointAnimateInfo) : Point
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
        
        /**
         * このシェイプに定義されているコントロールポイントを結ぶ直線上の任意の1点を返します.
         */
        public function getPointOnControlPointsLocus(q : PointAnimateInfo) : Point
        {
            const  len : Number = 1 / (_segments.length-1);
            var   time : Number = q.time,
                   seg : IMotionGuide;

            if (time < 0)
                return Segment(_segments[0]).begin;

            if (time > 1)
                time %= 1;
                
            seg = _segments[int(time / len)];

            return seg.getValue((time % len) / len);
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

        public function get amount() : int
        {
            return _amount;
        }

        // TODO closed未実装
        public function set amount(value : int) : void
        {
            if (_amount == value) return;

            var cp : ControlPoint;

            // trim
            if (_amount > value)
            {
                cp = _controls[value];
                cp.next = null;
                _controls.length = value;
            }
            // add
            else if (_amount < value)
            {
                const diff : int = value - _amount;
                var temp : ControlPoint,
                       i : int;
                while (i++ < diff)
                {
                    cp = _controls[_controls.length - 1];
                    temp = new ControlPoint(value, cp.x, cp.y);
                    cp.next = temp;
                    _controls.push(temp);
                }
            }

            // レートを再設定
            const delta : Number = 1 / (value-1);
            var rate : Number = 0;
            cp = _controls[0];
            while (cp)
            {
                cp.pointQuery.rate = rate;
                rate += delta;
                cp = cp.next;
            }
            // アンカーポイントを再作成
            _anchors = RopeShapeUtils.createAnchorsFromControlPoint(_controls);

            _amount = _controls.length;
        }
        
        public function representH(x1 : int, x2:int) : void
        {
            var cp : ControlPoint;
            for (var i : int = 0, l:int=_controls.length; i < l; i++)
            {
                cp = _controls[i];
                cp.resetXTo(x1 + (x2-x1) * (i / l));
            }

            _anchors = RopeShapeUtils.createAnchorsFromControlPoint(_controls);
            updateSegment();
            updateLength();
        }
    }
}
