package com.imajuk.media
{
    import flash.display.Sprite;
    /**
     * @author shin.yamaharu
     */
    public class AbstractBufferingAlert implements IBufferingAlert
    {
        private var asset : Sprite;

        public function AbstractBufferingAlert(asset : Sprite)
        {
            this.asset = asset;
        }

        public function alertBuffering(bufferLength : Number, bufferTime : Number, per : Number) : void
        {
//            Logger.info(3, "buffering..  " + bufferLength + " / " + bufferTime + " " + int(per * 100) + " %"); 
            
            asset.alpha = 1;
        }

        public function invisibleBufferingAlert() : void
        {
//            Logger.info(3, "buffered."); 
            
            asset.alpha = 0;
        }
    }
}
