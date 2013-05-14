package com.imajuk.site
{
    import org.libspark.thread.Thread;

    import flash.utils.getQualifiedClassName;
    /**
     * コントローラ（）のファクトリー
     * @author shin.yamaharu
     */
    internal class ApplicationControlerFactory
    {
    	/**
    	 * @param isState  このコントローラがStateかどうか（CommonControlerの場合もあり得る）
    	 */
        public static function create(klass : Class, application:Application, isState:Boolean = true) : Thread
        {
            try
            {
                var controler : Thread = new klass();
                if (controler is ReferencableViewThread) 
                {
                    ReferencableViewThread(controler).application = application;
                    ReferencableViewThread(controler).isState = isState;                }
            }
            catch(e : Error)
            {
            	throw ApplicationError.create(ApplicationError.CONSTRUCTION_PROBLEM, getQualifiedClassName(klass), e.message);
            }
            
            return controler;
        }
    }
}
