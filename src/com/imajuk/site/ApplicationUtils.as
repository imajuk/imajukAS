package com.imajuk.site
{
    /**
     * @author imajuk
     */
    internal class ApplicationUtils
    {
        private static var application : Application;
        public static function initialize(application : Application) : void
        {
            ApplicationUtils.application = application;
        }
        
    	[inject]
        public var chk_inject:Object;
        internal static function checkMetaTag() : void
        {
        	var analzer:ApplicationMetaDataAnalyzer = new ApplicationMetaDataAnalyzer(ApplicationUtils);
        	var result:Array = analzer.getMetaDataInfo(MetaData.INJECT) as Array;
        	if (result && result.length > 0)
        	   return;
        	   
        	throw ApplicationError.create(ApplicationError.LACK_OF_COMPILER_OPTION);
        }
    }
}
