package com.imajuk.ropes.models
{
    import flash.geom.Point;

    import com.imajuk.interfaces.IMotionGuide;
    import com.imajuk.ropes.shapes.IRopeShape;
    import com.imajuk.ropes.shapes.RopeMixier;
    import com.imajuk.ropes.shapes.RopeShape;
    import com.imajuk.ropes.shapes.RopeShapes;
    import com.imajuk.utils.MathUtil;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.easing.Back;
    import org.libspark.betweenas3.tweens.ITween;



    /**
     * @author imajuk
     */
    public class Model implements IRopeShape
    {
        private static var id : int;
        private var _id : int;
//        public var anchorPoints : Array;
//        public var guidePoints : Array;
        public var shape : IRopeShape;
        public var currentShape : int;
        private var _amount : int = -1;
        private var _shapes : RopeShapes;
        private var _isInitialized : Boolean;
//        public var isInitialized : Boolean;

        public function Model(shape : IRopeShape)
        {
            this.shape = shape;
            _id = id++;
        }
        
        public function toString() : String {
            return "com.imajuk.ropes.models.Model[" + _id + "]";
        }

        /**
         * @param amount ポイント数
         */
        public function initialize(s : RopeShapes, amount : int, closed : Boolean = false) : void
        {
            _isInitialized = true;
            _amount = amount;

            this.shapes = s;

//            var origin        : Array = shape.getGuidePoints(),
//                origin_amount : uint = origin.length - 1,
//                origin_cp     : ControlPoint,
//                idx           : int;
//            
//            //----------------------------
//            // 指定された量のガイドポイントを生成
//            //----------------------------
//            guidePoints = [];
//            var c : int = amount;
//            var temp : ControlPoint;
//            var rate : Number = 1;
//            var v : Number = 1 / c;
//            var x : int = c * 10;
//            while (c > 0)
//            {
//                idx = (c-1) / (amount-1) * origin_amount;
//                origin_cp = origin[idx];
//                var cp : ControlPoint = new ControlPoint(c, origin_cp.initX, origin_cp.initY, rate);
//                cp.next = temp;
//                temp = cp;
//                guidePoints.unshift(cp);
//                c--;
//                x -= 10;
//                rate -= v;
//            }
//
            shape.closed = closed;
//
//            //-------------------------------------
//            // ガイドポイントを補完してアンカーポイントを作る
//            //-------------------------------------
//            anchorPoints = RopeShapeUtils.createAnchorsFromControlPoint(guidePoints);
        }

        public function change(type : int, duration : Number = 0, callback : Function = null) : void
        {
            if (currentShape == type)
                return;

            var tweens : Array = [];
            var cp : ControlPoint = shape.getControlPoints()[0];
            while (cp)
            {
                tweens.push(BetweenAS3.delay(BetweenAS3.tween(cp.pointQuery, {mix:1}, {mix:0}, duration + MathUtil.random(.8, .9), Back.easeOut), cp.id * .0005));

                cp = cp.next;
            }
            var twn : ITween = BetweenAS3.parallelTweens(tweens);
            if (callback != null)
                twn.onComplete = callback;
            twn.play();

            RopeMixier(shape).change(type);

            currentShape = type;
        }

        public function get amount() : int
        {
            return _amount;
        }

        // TODO closed未実装
        public function set amount(value : int) : void
        {
            //TODO 後で実装
//            if (_amount == value)
//                return;
//
//            var cp : ControlPoint;
//
//            // trim
//            if (_amount > value)
//            {
//                ControlPoint(shape.getGuidePoints()[value]).next = null;
//                shape.getGuidePoints().length = value;
//            }
//            // add
//            else if (_amount < value)
//            {
//                var diff : int = value - _amount;
//                var i : int;
//                while (i++ < diff)
//                {
//                    cp = shape.getGuidePoints()[shape.getGuidePoints().length - 1];
//                    var temp : ControlPoint = new ControlPoint(value, cp.x, cp.y);
//                    cp.next = temp;
//                    shape.getGuidePoints().push(temp);
//                }
//            }
//
//            // レートを再設定
//            var rate : Number = 0;
//            var v : Number = 1 / value;
//            cp = shape.getGuidePoints()[0];
//            while (cp)
//            {
//                cp.pointQuery.rate = rate;
//                rate += v;
//                cp = cp.next;
//            }
//            // アンカーポイントを再作成
//            shape.getAnchorPoints() = RopeShapeUtils.createAnchorsFromControlPoint(shape.getGuidePoints());
//
//            _amount = shape.getGuidePoints().length;
        }


        //TODO RopeShapeに移動. ModelはShapeにこのプロパティを移譲する
//        private var _closed : Boolean = false;
//        public function get closed() : Boolean
//        {
//            return _closed;
//        }
//        public function set closed(value : Boolean) : void
//        {
//            if (!isInitialized) throw new Error("unInitialized");
//            if (_closed == value) return;
//
//            _closed = value;
//            
//            if (_closed)
//            {
//                // open -> close
//                guidePoints.push(guidePoints[0]);
//            }
//            else
//            {
//                // close -> open
//                guidePoints.pop();
//            }
//
//            // =================================
//            // ガイドポイントを補完してアンカーポイントを作る
//            // =================================
//            anchorPoints = RopeShapeUtils.createAnchorsFromControlPoint(guidePoints);
//        }

        public function set shapes(shapes : RopeShapes) : void
        {
            _shapes = shapes;
            //シェイプのコレクション中の最初のシェイプでRopeShapeを初期化する
//            shape.initialize(shapes);
            shape = _shapes.getShape(0);
        }

        public function get length() : Number
        {
            return shape.length;
        }

        public function getPoint(q : PointQuery) : Point
        {
            return shape.getPoint(q);
        }

        public function getControlPoints() : Array
        {
            return shape.getControlPoints();
        }

        public function getSegments() : Vector.<IMotionGuide>
        {
            return shape.getSegments();
        }

        public function getAnchorPoints() : Array
        {
            return shape.getAnchorPoints();
        }

        public function get closed() : Boolean
        {
            return shape.closed;
        }

        public function set closed(value : Boolean) : void
        {
            shape.closed = value;
        }

        public function get isInitialized() : Boolean
        {
            return shape.isInitialized;
        }
    }
}
