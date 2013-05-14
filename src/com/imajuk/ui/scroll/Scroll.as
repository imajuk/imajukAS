package com.imajuk.ui.scroll 
{
    import com.imajuk.ui.MouseWheel;
    import com.imajuk.ui.scroll.view.ScrollMask;

    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;

    /**
     * スクロール機能生成のショートカット
     * @author shinyamaharu
     */
    public class Scroll extends Sprite
    {
        public static const BAR_POSITION_RIGHT : String = "BAR_POSITION_RIGHT";
        public static const BAR_POSITION_LEFT : String = "BAR_POSITION_LEFT";
        private static var sid : int;
        private var _id : Number;
        public function get id() : Number
        {
            return _id;
        }
        public var uiScrollBar : UIScrollBar;
        private var scrollContainer : ScrollContainer;
        private var maskWidth : int;
        private var maskHeight : int;

        public function Scroll(
                            content : DisplayObject, 
                            width : int, 
                            height : int, 
                            barClass : Class = null, 
                            bgClass : Class = null, 
                            arrowClass : Class = null,
                            debug:Boolean = false
                        ) : void 
        {
            _id = sid++;
            
            maskWidth = width;            maskHeight = height;
        	
            //=================================
            // create view
            //=================================
            scrollContainer = new ScrollContainer(
                                        content, 
                                        new ScrollMask(
                                            new Rectangle(0, 0, width, height),
                                            debug
                                        ),
                                        debug
                                    );
            scrollContainer._id = _id;
            uiScrollBar     = new UIScrollBar(scrollContainer, barClass, bgClass, arrowClass);

            //=================================
            // positioning and display
            //=================================
            scrollBarPosition = _scrollBarPosition;
            addChild(scrollContainer);
        }
        
        override public function toString() : String
        {
            return "Scroll[" + _id + "]";
        }
        
        public static function set activeScroll(id:int) : void
        {
            MouseWheel.activeScroll = id;
        }

        /**
         * スクロールバー全体のサイズです
         */
        public function set scrollBarSize(value : int) : void 
        {
        	uiScrollBar.size = value;
        }

        /**
         * スクロールバーがコンテナに対してどの位置に配置されるかを表すプロパティです
         */
        private var _scrollBarPosition : String = BAR_POSITION_RIGHT;
        public function get scrollBarPosition() : String
        {
            return _scrollBarPosition;
        }
        public function set scrollBarPosition(value : String) : void 
        {
            switch(value)
            {                case BAR_POSITION_RIGHT:                    uiScrollBar.x = maskWidth + uiScrollBar.container_scrollbar_margin;                    break;
                case BAR_POSITION_LEFT:
                    uiScrollBar.x = -uiScrollBar.container_scrollbar_margin;                    break;
                default :
                    throw new Error("不正なpositionです.", value);
            }
            
            _scrollBarPosition = value;
        }

        /**
         * スクロールバー内のバーと背景のマージンです
         * TODO Arrowをsepにた場合、マージンにArrowのサイズを含めないと行けないので、Arrowのサイズを含めなくていいようにする
         */
        public function set bar_bg_margin(value:int) : void 
        {
            uiScrollBar.bar_bg_margin = value;
        }

        /**
         * スクロールバーとコンテナとのマージンです
         */
        public function set container_scrollbar_margin(value:int) : void 
        {
            uiScrollBar.container_scrollbar_margin = value;
            scrollBarPosition = _scrollBarPosition;
        }
        
        /**
         * スクロール機能を開始します
         */
        public function start() : void 
        {
        	uiScrollBar.start();
            MouseWheel.activeScroll = _id;
        }

        /**
         * スクロール機能を破棄します
         */
        public function dispose() : void 
        {
            uiScrollBar.dispose();
        }

        /**
         * コンテナとスクロールバーを0の位置にリセットします
         */
        public function reset() : void 
        {
            uiScrollBar.reset();
        }

        /**
         * コンテナのサイズを指定します
         * この値を指定するとコンテナのサイズの自動計算は行われません
         */
        public function forceContentSizeAs(value : int) : void
        {
        	uiScrollBar.autoCalcContentSize = false;
        	scrollContainer.actualHeight = value;
        }

        /**
         * Arrowボタンをどのように配置するかを決定します.
         * TODO まとめる場合、コンテントの表示サイズとscrollBarSizeが同じだとArrowがマスク外に行ってしまうのできちんと収まるようにする 
         */
        public function set arrowtype(value:String) : void
        {
        	uiScrollBar.arrowType = value;
        }
        
        /**
         * スクロールバーのハンドルサイズ。
         * 0より大きい値を指定するとハンドルサイズは固定されます。
         * 0または指定しないとハンドルはスクロール可能範囲を表すように自動的に伸縮します
         */        
        public function set handleSize(value : int) : void
        {
            uiScrollBar.handleSize = value;
        }

        public function set barAndArrowSeparateMargin(value : int) : void
        {
            uiScrollBar.barAndArrowSeparateMargin = value;
        }

        public function set arrowAndArrowMargin(value:int) : void
        {
            uiScrollBar.arrowAndArrowMargin = value;
        }

        public function set amount(value:int) : void
        {
            uiScrollBar.amount = value;
        }
    }
}
