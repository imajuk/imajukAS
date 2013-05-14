package com.imajuk.ui.window 
{
    import com.imajuk.logs.Logger;
    import com.imajuk.motion.TweensyThread;
    import com.imajuk.threads.InvorkerThread;
    import com.imajuk.ui.buttons.IButton;
    import com.imajuk.ui.scroll.Scroll;
    import com.imajuk.utils.DisplayObjectUtil;
    import fl.motion.easing.Exponential;
    import flash.display.Sprite;
    import org.libspark.thread.Thread;




    /**
     * Windowのコンテントになる抽象クラスです.
     * 
     * ウィンドウのコンテントを構築するためにWindowThreadからの各要求に応えます.
     * WindowThreadは以下の順番でこのクラスのメソッドを呼び出します.
     * 	getInitializeContentThread()
     * 	getInitializeScrollThread();
     * 	getShowFrameThread()
     * 	getShowContentThread()
     * 	getStartContentThread();
     * 	getShowCloseBtnThread()
     * 	getStartScrollThread()
     * 	getIdleThread()
     * 	getHideContentThread()
     * 	dispose()
     * 各メソッドの役割についてはIWindowContentBuilderを参照してください
     * 
     * @author shin.yamaharu
     */
    public class AbstractWindowContent implements IWindowContentBuilder
    {
        protected var windowAsset :Sprite;
        protected var closeBtn : IButton;
        protected var scroll : Scroll;        protected var identifier : String;

        /**
		 * コンストラクタ
		 * @param windowAsset	ウィンドウのアセットです.
		 * 						多くの場合、ウィンドウのフレームやコンテントとなるアセットをこれに含めます
		 */
        public function AbstractWindowContent(windowAsset:Sprite, identifier:String)
        {
            super();

            this.windowAsset = windowAsset;
            this.identifier = identifier;
        }

        /**
         * build close button
         * if you want a close button in the window, 
         * should implements buildCloseButton() in concrete class.
         */
        protected function buildCloseButton() : IButton
        {
            return null;
        }

        /**
         * ウィンドウコンテントを初期化するThreadを返します.
         * 具象クラスで必ず実装する必要があります
         */
        public function getInitializeContentThread() : Thread
        {
			throw new Error("you have to implement getContentInitializeThread() method.");            
            return null;
        }
        
        public function getInitializeScrollThread() : Thread
        {
            return new Thread();
        }
        
        public function getShowWindowFrameThread() : Thread
        {
            return new TweensyThread(windowAsset, 0, 1, Exponential.easeInOut, null, {alpha:1});
        }        
        public function getShowWindowContentThread() : Thread
        {
        	return new Thread();
        }
        
        public function getStartContentThread() : Thread
        {
            return new Thread();
        }
        
        public function getShowCloseBtnThread() : Thread
        {
        	this.closeBtn = buildCloseButton();
            if (closeBtn)
            	return new TweensyThread(closeBtn, 0, 1, Exponential.easeInOut, null, {alpha:1});
            else
            	return new Thread();
        }
        
        public function getStartScrollThread() : Thread
        {
            if (scroll)
            	return new InvorkerThread(function():void{scroll.start();});
            else            	return new Thread();
        }
        
        public function getIdleThread() : Thread
        {
        	Logger.debug(this);
            return new WindowIdleThread(closeBtn as Sprite);
        }
        
        public function getHideContentThread() : Thread
        {
        	if (windowAsset)
	            return new TweensyThread(windowAsset, 0, .5, Exponential.easeInOut, null, {alpha:0});
	        else
            	return new Thread();
        }
        
        public function dispose() : Thread
        {
        	DisplayObjectUtil.removeChild(windowAsset);
            if (scroll)
                return new InvorkerThread(function():void{scroll.dispose();});            else
                return new Thread();
        }
    }
}
