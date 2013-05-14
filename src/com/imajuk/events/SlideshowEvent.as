package com.imajuk.events 
{
    import flash.events.Event;
    /**
     * @author yamaharu
     */
    public class SlideshowEvent extends Event 
    {
        public static const UPDATE_MODEL:String = "slideshowModelUpdate";
        /**
         * Viewerのアップデートが開始された         */
        public static const UPDATE_VIEW:String = "slideshowUpdateView";
        /**
         * Viewerのアップデートが完了した.
         */
        public static const UPDATING_VIEW_FINISHED:String = "slideshowViewUpdatingFinished";
        public static const START:String = "slideshowStart";

        public function SlideshowEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
