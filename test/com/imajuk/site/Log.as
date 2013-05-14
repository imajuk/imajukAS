package com.imajuk.site 
{

    /**
     * @author shinyamaharu
     */
    public class Log 
    {
        public static var logs : String = "";

        public static function clear() : void
        {
            logs = "";   
        }

        public static function getLog() : String
        {
        	return logs;
        }
    }
}
