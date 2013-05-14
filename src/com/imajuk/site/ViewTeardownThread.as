package com.imajuk.site
{
    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;

    /**
     * Viewのhide()を呼び出し、終わったらremoveChild()、Viewのinit()を呼び出す     * @author shinyamaharu     */
    internal class ViewTeardownThread extends Thread
    {
        private var view : *;
        private var callBack : Function;

        /**
         * 
         */
        public function ViewTeardownThread(view : DisplayObject, callBack:Function = null)
        {
            super();

            this.view = view;
            this.callBack = callBack;
        }

        override protected function run() : void
        {
            if (!view)
                return;
                
        	var hide:Function = view["hide"];
        	if (hide == null)
        	   throw new Error(view + "にはhide()メソッドがありません.");
        	   
            // start to hide index page
            var t : Thread = hide();
            if (t)
            {
                t.start();
                t.join();
            }
            next(
                function() : void
                {
                    //note:ステージからtemporary viewを取り除くのはframeworkの仕事
                    
                    if (view.hasOwnProperty("init"))
                        view.init();
                    if (callBack != null)
                        callBack();
                }
            );
        }

        override protected function finalize() : void
        {
        }
    }
}