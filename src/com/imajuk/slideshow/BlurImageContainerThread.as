package com.imajuk.slideshow 
{
    import fl.motion.easing.Exponential;

    import com.imajuk.motion.BlurTweenHelper;
    import com.imajuk.motion.TweensyThread;

    import flash.display.Sprite;
    /**
     * @author shin.yamaharu
     */
    public class BlurImageContainerThread extends AbstractImageContainerThread 
    {
        private var direction:int = 15;
        private var blur:int = 6;

        public function BlurImageContainerThread(
                            identify:String,
                            imagesContainer:Sprite,
                            imageIndex:int,
                            duration:Number = .4)
        {
            super(identify, imagesContainer, imageIndex, duration);
        }

        override protected function getShowCurrentThread():Array
        {
            current.visible = true;
            current.alpha = 0;
            current.y = 0;
            
            var blurProxy_current:BlurTweenHelper = new BlurTweenHelper(current, 0, blur);
            blurProxy_current.amount = 1;
            
            var a : Array = [];
            a.push(new TweensyThread(current, 0, duration, Exponential.easeInOut, null, {alpha:1}));
            a.push(new TweensyThread(blurProxy_current, 0, duration, Exponential.easeInOut, null, {amount:0}));
            return a;
            
//            var t:ParallelExecutor = new ParallelExecutor();
//            t.addThread(new TweensyThread(current, 0, duration, Exponential.easeInOut, null, {alpha:1}));
//            t.addThread(new TweensyThread(blurProxy_current, 0, duration, Exponential.easeInOut, null, {amount:0}));
            //            return t;
        }

        override protected function getHidePreviousThread():Array
        {//            var t:ParallelExecutor = new ParallelExecutor();
        	 
            var blurProxy_previous:BlurTweenHelper = new BlurTweenHelper(previous, 0, blur);
            blurProxy_previous.amount = 0;
            
            var a:Array = [];
            a.push(new TweensyThread(previous, 0, duration, Exponential.easeInOut, null, {alpha:0}));
            a.push(new TweensyThread(previous, 0, duration, Exponential.easeInOut, null, {y:previous.y + direction}));
            a.push(new TweensyThread(blurProxy_previous, 0, duration, Exponential.easeOut, null, {amount:1}));
            return a;
//            t.addThread(new TweensyThread(previous, 0, duration, Exponential.easeInOut, null, {alpha:0}));//            t.addThread(new TweensyThread(previous, 0, duration, Exponential.easeInOut, null, {y:previous.y + direction}));//            t.addThread(new TweensyThread(blurProxy_previous, 0, duration, Exponential.easeOut, null, {amount:1}));
                
//            return t;
        }

        override protected function finalize():void
        {
            if(previous)
               previous.visible = false;
               
        	super.finalize();
        }
    }
}
