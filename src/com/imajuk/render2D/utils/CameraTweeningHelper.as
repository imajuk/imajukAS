package com.imajuk.render2D.utils 
{
    import com.imajuk.render2D.Render2DCamrera;
    import com.imajuk.render2D.Render2D;
    /**
     * @author shinyamaharu
     */
    public class CameraTweeningHelper 
    {
        private var camera : Render2DCamrera;
        private var render2D : Render2D;
        private var _x : Number;
        private var _y : Number;
        private var _radians : Number;
        private var _scale : Number;
        private var _render : int;

        public function CameraTweeningHelper(render2D : Render2D)         
        {
            this.render2D = render2D;
            this.camera = render2D.camera;
            _x = camera.x;
            _y = camera.y;
            _radians = camera.rad;
            _scale = camera.scale;
            _render = 0;
        }

        public function get x() : Number
        {
            return _x;
        }

        public function set x(value : Number) : void
        {
            _x = value;
            camera.x = _x;
        }

        public function get y() : Number
        {
            return _y;
        }

        public function set y(value : Number) : void
        {
            _y = value;
            camera.y = _y;
        }

        public function get radians() : Number
        {
            return _radians;
        }

        public function set radians(value : Number) : void
        {
            _radians = value;
            camera.rad = _radians;
        }

        public function get scale() : Number
        {
            return _scale;
        }

        public function set scale(value : Number) : void
        {
            _scale = value;
            camera.scale = _scale;
        }

        public function get render() : int
        {
            return _render;
        }

        public function set render(value : int) : void
        {
            _render = value;
            render2D.render();
        }
    }
}
