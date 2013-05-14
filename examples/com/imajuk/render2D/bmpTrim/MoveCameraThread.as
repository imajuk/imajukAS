package com.imajuk.render2D.bmpTrim
{
    import com.imajuk.render2D.Render2DCamrera;
    import com.imajuk.utils.MathUtil;

    import org.libspark.thread.Thread;

    import flash.geom.Matrix;

    /**
     * @author shinyamaharu
     */
    public class MoveCameraThread extends Thread 
    {
        private var camera : Render2DCamrera;
        private var time : Number = 0;
        private var v : Number;
        private var sx : Number;
        private var sy : Number;
        private var ss : Number;

        public function MoveCameraThread(camera:Render2DCamrera)
        {
            super();

            this.camera = camera;
            
            sx = camera.x;
            sy = camera.y;
            ss = camera.scale;
            
            
            v = MathUtil.random(.005, .01);
        }

        override protected function run() : void
        {
            if (isInterrupted)
            	return;
            
            time += v;
            
            var s : Number = Math.sin(time) * 0.4 + ss;
            s = camera.scale / s;
            
            var rx : Number = camera.x + camera.width * .5;
            var ry : Number = camera.y + camera.height * .5;
            var m : Matrix = new Matrix(1/camera.scale, 0, 0, 1/camera.scale, camera.x, camera.y);            m.translate(-rx, -ry);
            m.scale(s, s);
            m.translate(rx, ry);
            
            camera.x = m.tx;
            camera.y = m.ty;
            camera.scale = 1/m.a;
            camera.rad = Math.sin(time) * .1;
                        next(run);
        }


        override protected function finalize() : void
        {
            trace(this + " : finalize " + []);
        }
    }
}
