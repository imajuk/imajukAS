package com.imajuk.slideshow 
{
    import flash.utils.Dictionary;
    /**
     * @author shin.yamaharu
     */
    public class ImageContainerModel 
    {
        private static var dicPrevious:Dictionary = new Dictionary(true);        private static var dicCurrent:Dictionary = new Dictionary(true);

        public function ImageContainerModel(className:String, imageIndex:int)         
        {
            dicPrevious[className] = dicCurrent[className];
            dicCurrent[className] = imageIndex;
        }
        
        public static function reset(identify:String):void
        {
        	dicCurrent[identify] = -1;        	dicPrevious[identify] = -1;
        }

        public static function getCurrent(className:String):int
        {
            return (dicCurrent[className] == null) ? -1 : dicCurrent[className];
        }

        public static function getPrevious(className:String):int
        {
            return (dicPrevious[className] == null) ? -1 : dicPrevious[className];
        }
    }
}
