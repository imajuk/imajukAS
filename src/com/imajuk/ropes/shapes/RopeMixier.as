package com.imajuk.ropes.shapes
{
    import com.imajuk.interfaces.IMotionGuide;
    import com.imajuk.ropes.models.PointQuery;
    import flash.geom.Point;


    /**
     * @author imajuk
     */
    public class RopeMixier implements IRopeShape
    {
        public var currentShape : IRopeShape;
        public var previousShape : IRopeShape;
        private var shapes : RopeShapes;

        public function initialize(shapes : RopeShapes) : void
        {
            this.shapes = shapes;
            var a : IRopeShape = shapes.getShape(0);
            var b : IRopeShape = shapes.getShape(1);
            currentShape = a;
            previousShape = b || a;
        }

        public function change(type : int) : void
        {
            var shape : IRopeShape = shapes.getShape(type);
            if (currentShape == shape)
                return;

            previousShape = currentShape;
            currentShape = shape;
        }

        /**
         * ２つのモーションガイドをミックスしたt時間目の位置を返す.
         */
        public function getPoint(q : PointQuery) : Point
        {
            var mix : Number = q.mix;
            var prev : Point = previousShape.getPoint(q);
            var curr : Point = currentShape.getPoint(q);
            var px : Number = prev.x * (1 - mix) + curr.x * mix;
            var py : Number = prev.y * (1 - mix) + curr.y * mix;
            return new Point(px, py);
        }

        public function get shape() : IRopeShape
        {
            return currentShape;
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
            return false;
        }

        public function set closed(value : Boolean) : void
        {
        }

        public function get isInitialized() : Boolean
        {
            return false;
        }
    }
}
