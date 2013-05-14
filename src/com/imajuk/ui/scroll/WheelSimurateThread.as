package com.imajuk.ui.scroll{    import org.libspark.thread.Thread;    /**     * @author shinyamaharu     */    public class WheelSimurateThread extends Thread     {        private var scrollInvoker : IScrollCommandFactory;        private var count : int = 0;        private var repeat : int;
        private var direction : int;
        private var amount : Number;
        public function WheelSimurateThread(scrollInvoker : IScrollCommandFactory, direction : int, repeat : int)        {            super();            this.scrollInvoker = scrollInvoker;            this.direction = direction;
            this.amount = repeat / 5;
            this.repeat = 5;        }        override protected function run() : void        {            if (count++ < repeat)				next(run);				            scrollInvoker.wheel(direction * amount);        	        }        override protected function finalize() : void        {        }    }}