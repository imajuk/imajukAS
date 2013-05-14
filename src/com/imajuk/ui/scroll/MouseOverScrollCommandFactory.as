package com.imajuk.ui.scroll 
{
    import com.imajuk.threads.InvorkerThread;
    import com.imajuk.ui.ScrollLock;
    import flash.display.DisplayObject;
    import org.libspark.thread.Thread;



    /**
     * @author shinyamaharu
     */
    public class MouseOverScrollCommandFactory implements IScrollCommandFactory 
    {
        private var itemContainer : MouseOverScrollContainer;
        private var scrollLock : ScrollLock;
        private var scroll : Thread;
        private var hitAreaSize : int;

        public function MouseOverScrollCommandFactory(itemContainer : MouseOverScrollContainer, scrollLock : ScrollLock, hitAreaSize:int)         
        {
            this.scrollLock = scrollLock;
            this.itemContainer = itemContainer;
            this.hitAreaSize = hitAreaSize;
        }

        public function startCommand() : Thread
        {
            scroll = new MouseOverScrollThread(itemContainer, 5, scrollLock, hitAreaSize);             return scroll;
        }

        public function disposeCommand() : Thread
        {
            return new InvorkerThread(function():void
            {
            	if (scroll)
            	   scroll.interrupt();
            });
        }
        
        public function updateScrollbarCommand(autoCalcContentSize : Boolean = true) : Thread
        {
        	//このクラスでは実装しない            return null;
        }

        public function resetScrollbarCommand() : Thread
        {
        	//このクラスでは実装しない
            return null;
        }

        public function wheel(value : int) : void
        {        	//TODO 未実装
        }

        public function get wheelTarget() : DisplayObject
        {
        	//TODO 未実装
            return null;
        }
        
        public function autoScroll() : void
        {        	//このクラスでは実装しない
        }
        
        public function get model() : UIScrollBarModel
        {
        	//このクラスでは実装しない
            return null;
        }
    }
}
