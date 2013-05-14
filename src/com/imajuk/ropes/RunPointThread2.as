package com.imajuk.ropes
{
    import com.imajuk.ropes.models.ControlPoint;
    import flash.display.DisplayObject;
    import org.libspark.thread.Thread;



    /**
     * @author shinyamaharu
     */
    public class RunPointThread2 extends Thread
    {
        private var controls : Array;
        private var guide : DisplayObject;

        public function RunPointThread2(controls : Array, guide : DisplayObject)
        {
            super();
            this.controls = controls;
            this.guide = guide;
        }

        override protected function run() : void
        {
            // =================================
            // 0番目はガイドを追いかける
            // n番目はn-1番目を追いかける
            // =================================
            var prev : ControlPoint;
            var target : *;

            controls.forEach(function(cp : ControlPoint, ...param) : void
            {
                target = prev || guide;

                var dx : Number = target.x - cp.x;
                var dy : Number = target.y - cp.y;

                cp.x += dx * (prev ? .1 : 1);
                cp.y += dy * (prev ? .1 : 1);

                prev = cp;
            });

            next(run);
        }

        override protected function finalize() : void
        {
        }
    }
}
