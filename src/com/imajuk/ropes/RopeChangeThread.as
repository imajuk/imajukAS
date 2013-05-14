package com.imajuk.ropes
{
    import flash.events.Event;

    import org.libspark.thread.Thread;

    /**
     * @author shinyamaharu
     */
    public class RopeChangeThread extends Thread
    {
        private var rope : Rope;
        private var duration : Number;
        private var stopAfterChanging : Boolean;
        private var type : int;

        public function RopeChangeThread(rope : Rope, type : int, duration : Number = 0, stopAfterChanging : Boolean = false)
        {
            super();

            this.stopAfterChanging = stopAfterChanging;
            this.type = type;
            this.duration = duration;
            this.rope = rope;
        }

        override protected function run() : void
        {
            rope.change(type, 0, duration);

            event(rope, Event.CHANGE, function() : void
            {
            });
        }

        override protected function finalize() : void
        {
            if (stopAfterChanging)
            // ロープを止めて静止画に
                rope.stop();
        }
    }
}
