package
com.imajuk.service{
    import flash.events.Event;

    /**
     * @author imajuk
     */
    public class AjaxEvent extends Event
    {
        public static const SUCCESS : String = "SUCCESS";
        public static const ACCESS_WAS_SUCCESS_BUT_ERROR_IN_CALLBACK : String = "ACCESS_WAS_SUCCESS_BUT_ERROR_IN_CALLBACK";
        public static const ACCESS_WAS_ERROR : String = "ACCESS_WAS_ERROR";
        public static const ACCESS_WAS_ERROR_ALSO_ERROR_IN_CALLBACK : String = "ACCESS_IS_ERROR_ALSO_ERROR_IN_CALLBACK";
        public static const ACCESS_WAS_TIMEOUT : String = "ACCESS_WAS_TIMEOUT";
        public static const ACCESS_WAS_TIMEOUT_AND_ERROR_IN_CALLBACK : String = "ACCESS_WAS_TIMEOUT_AND_ERROR_IN_CALLBACK";
        
        public function AjaxEvent(type : String)
        {
            super(type, true, false);
        }
    }
}
