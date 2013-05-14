package com.imajuk.ui.slider
{
    import flash.geom.Rectangle;    import fl.motion.easing.Quadratic;

    import com.imajuk.motion.TweensyThread;
    import com.imajuk.ui.IUIView;
    import com.imajuk.ui.UIType;

    import org.libspark.thread.Thread;    /**     * @author shinyamaharu     */    public class UIScrollBarSlideBarThread extends Thread     {        private static var moving : Thread;        private var bar : IUIView;        private var model : UISliderModel;
        private var value : Number;        private var useEasing : Boolean;
        public function UIScrollBarSlideBarThread(bar : IUIView, model:UISliderModel, value:Number, useEasing:Boolean = true)        {            super();                        this.bar = bar;            this.model = model;            this.value = value;            this.useEasing = useEasing;        }        override protected function run() : void        {        	if (value == 0)
                return;                
            var destination : int;            var prop:Object;            var noEasing:Function;            if (model.direction == UIType.HORIZONAL)
            {
                destination = bar.externalX + value;
                prop = {"x":destination};
                noEasing = function():void{bar.x = destination;};
            }
            else
            {
                destination = validate("y", bar.externalY + value);
                prop = {"y":destination};                noEasing = function():void{bar.y = destination;};
            }
            var destMin:int = model.destMin;            var destMax:int = model.destMax;
                     	if (destMin > destination)
                destination = destMin;            else if (destMax < destination)
        	   destination = destMax;        	           	               if (moving)                moving.interrupt();                            if (useEasing)            {                moving = new TweensyThread(bar, 0, .3, Quadratic.easeOut, null, prop);                moving.start();                moving.join();            }            else            {            	noEasing();            }
        }

        private function validate(prop : String, d : int) : int
        {
        	var range1:Rectangle = model.getBarRange();        	var range2:Number = range1[prop];
            d = Math.max(range2, d);
            d = Math.min(range2 + range1.height, d);
            return d;
        }
        override protected function finalize() : void        {        }    }}