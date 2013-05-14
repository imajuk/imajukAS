package com.imajuk.slideshow 
{
    import com.imajuk.motion.ColorMatrixTweenHelper;
    import com.imajuk.motion.TweensyThread;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    /**
     * @author shin.yamaharu
     */
    public class FadeImageContainerThread extends AbstractImageContainerThread 
    {
        private var brightness : Number;
        
        public function FadeImageContainerThread(
                            identify:String,
                            imagesContainer:Sprite,
                            imageIndex:int,
                            duration:Number = .4,                            duration_off:Number = .4,
                            easing:Function = null,                            easing_hide:Function = null,
                            brightness:Number = NaN
                        )
        {
            super(identify, imagesContainer, imageIndex, duration, duration_off, easing, easing_hide);
            this.brightness = brightness;
        }

        override protected function getShowCurrentThread():Array
        {
        	if(current is Sprite)
        	{
//        		Sprite(current).mouseEnabled = true;
//        		Sprite(current).mouseChildren = true;
        	}
        		
            var a:Array = [];
            
            //TODO DirtyPatch indexに-1をわたすと全部消すようにした（reset()でいいんじゃ？）
            if (!current)
            {
                a = images.map(function(d:DisplayObject, ...param) : Thread
                {
                	return new TweensyThread(d, 0, duration, easing, null, {alpha:0});
                });
            }
            else
            {
                current.visible = true;
                current.alpha = 0;
                
                
                if (isNaN(brightness))
                {
                    a.push(new TweensyThread(current, 0, duration, easing, null, {alpha:1}));                    return a;
                }
                
                ////////// DIRTY PATCH
                current.filters = [];
                var proxy:ColorMatrixTweenHelper = new ColorMatrixTweenHelper(current, null, brightness);
                proxy.amount = 1;
                
                a.push(new TweensyThread(proxy,   0, duration, easing, null, {amount:0}));
                a.push(new TweensyThread(current, 0, duration, easing, null, {alpha:1}, null, null));
            }
            
            return a;            //////////////////////
            
        }
        override protected function getHidePreviousThread():Array
        {
        	if(previous is Sprite)
        	{
//        		Sprite(previous).mouseEnabled = false;
//        		Sprite(previous).mouseChildren = false;
        	}

            var a:Array = [];
              
            //一つ前の画像だけでなくすべての画像を非表示
            images.filter(function(d : DisplayObject, ...param):Boolean
            {
                return d.alpha != 0;
            }).forEach(function(d : DisplayObject, ...param):void
            {
            	a.push(new TweensyThread(d, 0, duration_off, easing_hide, null, {alpha:0}, null, function():void{d.visible=false;}));
            });
            
            if (isNaN(brightness))
                return a;
            ////////// DIRTY PATCH
            previous.filters = [];
            var proxy:ColorMatrixTweenHelper = new ColorMatrixTweenHelper(previous, null, brightness);
            proxy.amount = 0;

            a.push(new TweensyThread(proxy,    0, duration_off, easing_hide, null, {amount:1}));            
            
            return a;            /////////////////////////
        }

        public static function reset(identify : String) : void 
        {
        	AbstractImageContainerThread.reset(identify);
        }
    }
}
