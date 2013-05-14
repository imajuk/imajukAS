package com.imajuk.render2D.bitmapNode
{
    import com.imajuk.render2D.Render2DCamrera;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.Render2DWorld;

    import org.libspark.thread.Thread;


    /**
     * @author shinyamaharu
     */
    public class MoveWallThread extends Thread 
    {
        private var camera : Render2DCamrera;
        private var _x : Number;
        private var render2D : Render2D;
        private var _rotation : Number;
        private var _scale : Number;
        private var world : Render2DWorld;

        public function MoveWallThread(render2D : Render2D, world:Render2DWorld)
        {
            super();

            this.render2D = render2D;
            this.camera = render2D.camera;
            this.world = world;
            
            _x = camera.x;
            _rotation = camera.rad;
            _scale = camera.scale;
        }

        override protected function run() : void
        {
            if (isInterrupted)
            	return;
            
            x += 10;

            var cycle:Number = world.worldWidth - camera.width; 
            if (x > cycle)
            	x %= cycle;
            	
            next(run);
        }

        public function get x() : Number
        {
            return _x;
        }

        public function set x(value : Number) : void
        {
            _x = value;
            camera.x = _x;
            render2D.render();
        }

        public function get rotation() : Number
        {
            return _rotation;
        }

        public function set rotation(value : Number) : void
        {
            _rotation = value;
            camera.rad = _rotation;
            render2D.render();
        }

        public function get scale() : Number
        {
            return _scale;
        }

        public function set scale(value : Number) : void
        {
            _scale = value;
            camera.scale = _scale;
            render2D.render();
        }

        override protected function finalize() : void
        {
            trace(this + " : finalize " + []);
        }
    }
}
