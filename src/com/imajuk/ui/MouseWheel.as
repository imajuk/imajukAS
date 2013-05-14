package com.imajuk.ui 
{
    import com.imajuk.ui.scroll.IScrollCommandFactory;
    import com.imajuk.ui.scroll.ScrollContainer;
    import com.imajuk.utils.ArrayUtil;
    import com.imajuk.utils.StageReference;

    import flash.display.Stage;
    import flash.events.MouseEvent;

    /**
     * @author shin.yamaharu
     */
    public class MouseWheel 
    {
        private static var resisterdScrolls : Array = [];
        private static var isInitialized : Boolean = false;
        private static var stage : Stage;
        private static var active : IScrollCommandFactory;
        public static var sensitive : Number = 1;

        public static function unRegister(scrollThread : IScrollCommandFactory) : void
        {
            resisterdScrolls = ArrayUtil.remove(resisterdScrolls, scrollThread);
        }

        public static function register(scrollThread : IScrollCommandFactory) : void
        {
            if (ArrayUtil.contains(resisterdScrolls, scrollThread))
        	   return;
        	   
            resisterdScrolls.push(scrollThread);
            
			//ホイールは排他的に機能する.最後に登録されたオブジェクトが有効になるがactiveScrollプロパティで有効にするオブジェクトを指定できる        
            active = scrollThread;
			
            if (!isInitialized)
                init();
        }

        private static function init() : void
        {
            isInitialized = true;
            stage = StageReference.stage;
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
        }

        private static function wheelHandler(e : MouseEvent) : void
        {
            if (active.wheelTarget.hitTestPoint(stage.mouseX, stage.mouseY))
                active.wheel(-int(e.delta) * sensitive);
        }

        public static function set activeScroll(id:int) : void
        {
            var wheelTarget : ScrollContainer;
            resisterdScrolls.forEach(function(sc : IScrollCommandFactory, ...param) : void
            {
                wheelTarget = sc.wheelTarget.parent as ScrollContainer;
                if (!wheelTarget) return;
                
                if (wheelTarget.id == id)
                    active = sc;
            });
        }
    }
}
