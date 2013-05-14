package com.imajuk.ropes.shapes
{
    /**
     * @author imajuk
     */
    public class RopeShapes
    {
        private var shapes : Array = [];

        public function add(shape : RopeShape) : void
        {
            shapes.push(shape);
        }

        public function getShape(i : int) : IRopeShape
        {
            return shapes[i];
        }
    }
}
