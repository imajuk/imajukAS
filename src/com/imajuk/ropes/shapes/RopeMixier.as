package com.imajuk.ropes.shapes
{
    import com.imajuk.interfaces.IMotionGuide;
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.models.PointAnimateInfo;
    import com.imajuk.utils.MathUtil;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.easing.Back;
    import org.libspark.betweenas3.tweens.ITween;

    import flash.geom.Point;


    /**
     * @author imajuk
     */
    public class RopeMixier implements IRopeShape
    {
        public var currentShape : IRopeShape;
        public var previousShape : IRopeShape;
        private var shapes : RopeShapes;
        private var _isInitialized : Boolean;

        public function initialize(shapes : RopeShapes) : void
        {
            this.shapes = shapes;
            var a : IRopeShape = shapes.getShape(0);
            var b : IRopeShape = shapes.getShape(1);
            currentShape = a;
            previousShape = b || a;
            
            _isInitialized = true;
        }

        public function change(type : int, duration : Number = 0, callback : Function = null) : void
        {
            const targetShape:IRopeShape = shapes.getShape(type);
            if (currentShape === targetShape)
                return;

            previousShape = currentShape;
            currentShape = targetShape;

            const tweens : Array = [];
            
            var  cp : ControlPoint = currentShape.getControlPoints()[0],
                twn : ITween;
            while (cp)
            {
                tweens.push(
                    BetweenAS3.delay(
                        BetweenAS3.tween(
                            cp.pointQuery, {mix:1}, {mix:0}, duration + MathUtil.random(.8, .9), Back.easeOut
                        ), 
                    cp.id * .0005)
                );
                cp = cp.next;
            }
            
            twn = BetweenAS3.parallelTweens(tweens);
            if (callback != null) twn.onComplete = callback;
            twn.play();
        }

        /**
         * ２つのモーションガイドをミックスしたt時間目の位置を返す.
         */
        public function getPoint(q : PointAnimateInfo) : Point
        {
            const  mix : Number = q.mix,
                  prev : Point = previousShape.getPoint(q),
                  curr : Point = currentShape.getPoint(q),
                    px : Number = prev.x * (1 - mix) + curr.x * mix,
                    py : Number = prev.y * (1 - mix) + curr.y * mix;
                    
            return new Point(px, py);
        }
        
        public function getPointOnControlPointsLocus(q : PointAnimateInfo) : Point
        {
            const  mix : Number = q.mix,
                  prev : Point = previousShape.getPointOnControlPointsLocus(q),
                  curr : Point = currentShape.getPointOnControlPointsLocus(q),
                    px : Number = prev.x * (1 - mix) + curr.x * mix,
                    py : Number = prev.y * (1 - mix) + curr.y * mix;
                    
            return new Point(px, py);
        }

        public function getControlPoints() : Array
        {
            return currentShape.getControlPoints();
        }

        public function get length() : Number
        {
            return currentShape.length;
        }

        public function getSegments() : Vector.<IMotionGuide>
        {
            return currentShape.getSegments();
        }

        public function getAnchorPoints() : Array
        {
            return currentShape.getAnchorPoints();
        }

        public function get closed() : Boolean
        {
            return currentShape.closed;
        }

        public function set closed(value : Boolean) : void
        {
            currentShape.closed = value;
        }

        public function get isInitialized() : Boolean
        {
            return _isInitialized;
        }

        public function get amount() : int
        {
            return currentShape.amount;
        }

        public function set amount(value : int) : void
        {
            currentShape.amount = value;
        }
    }
}
