package com.imajuk.slideshow 
{
    import com.imajuk.constants.Direction;
    import fl.motion.easing.Exponential;

    import com.imajuk.motion.TweensyThread;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    /**
     * @author shin.yamaharu
     */
    public class SlideImageContainerThread extends AbstractImageContainerThread 
    {
        private var show_destination:int;
        private static var initCheck:Dictionary= new Dictionary(true);
        private var mask : DisplayObject;
        private var hide_destination : int;
        private var direction : String;
        private var isHolizonal : Boolean;

        public function SlideImageContainerThread(
                            identify:String,
                            imagesContainer:Sprite,
                            imageIndex:int,
                            duration:Number = .4,
                            direction:String = Direction.HORIZON)
        {
            super(identify, imagesContainer, imageIndex, duration);

            mask = imagesContainer.mask;
            if(!mask) throw new Error("イメージコンテナにはマスクが設定されている必要があります");
            
            this.direction = direction;
            this.isHolizonal = direction == Direction.HORIZON; 
            if (isHolizonal)
                hide_destination = mask.width;
            else
                hide_destination = mask.height;
        }

        override protected function getShowCurrentThread():Array
        {
            if (!isInitialized())
            {
                if (isHolizonal)
                    show_destination = current.x;
                else
                    show_destination = current.y;
                    
                images.forEach(function(d:DisplayObject, ...param):void
                {
                    if (isHolizonal)
                        d.x = hide_destination*-1;
                    else
                        d.y = hide_destination;    
                });
                initCheck[identify] = true;
            }
        	
            if (isHolizonal)
            {
                if(leftToRight)
                    current.x = hide_destination * -1;
                else
                    current.x = hide_destination;
            }
            else
            {
        	   current.y = -hide_destination;
            }
                       	current.alpha = 0;
        	
            return isHolizonal ? 
                    [new TweensyThread(current, 0, duration, Exponential.easeInOut, null, {x:show_destination, alpha:1})]:
                    [new TweensyThread(current, 0, duration, Exponential.easeInOut, null, {y:show_destination, alpha:1})];
        }

        private function get leftToRight() : Boolean
        {
            return super.getPreviousIndex < super.getCurrentIndex;
        }
        
        override protected function getHidePreviousThread():Array
        {
            return isHolizonal ? 
                    [new TweensyThread(previous, 0, duration, Exponential.easeInOut, null, {x:leftToRight ? hide_destination : hide_destination * -1, alpha:0})] :
                    [new TweensyThread(previous, 0, duration, Exponential.easeInOut, null, {y:hide_destination, alpha:0})];
        }
        
        private function isInitialized():Boolean
        {
            return initCheck[identify];
        }

    }
}
