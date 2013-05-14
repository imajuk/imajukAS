package com.imajuk.ui.scroll 
{
    import com.imajuk.utils.DisplayObjectUtil;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    /**
     * スクロールコンテナ
     * 以下のエレメントで構成されます.
     * # _container_
     * # _mask_
     * # _hitArea_
     * 
     * @author imajuk
     */
    public class ScrollContainer extends Sprite implements IScrollContainer
    {
        internal var _id : Number;
        public function get id() : Number
        {
            return _id;
        }
        
        private var _externalWidth : Number;
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         * @param contentHitArea    スクロールバーを使用しないコンテナに必要
         */
        public function ScrollContainer(
                            content        : DisplayObject,
                            contentMask    : IScrollContainerMask,
                            debug:Boolean = false
                        )
        {
            _content = addChild(content);

            _contentMask = addChild(DisplayObject(contentMask)) as IScrollContainerMask;
            _contentMask.name = "_mask_";
            
            if (debug)
                return;
                
            //mask asset
            _content.mask = DisplayObject(_contentMask);
        }
        
        override public function toString() : String {
            return "ScrollContainer[" + _id + "]";
        }

        //--------------------------------------------------------------------------
        //
        //  inprementation of IScrollContainer
        //
        //--------------------------------------------------------------------------
        /**
         * このコンテナが内包するDisplayObjectです
         */
        protected var _content : DisplayObject;
        public function get content() : DisplayObject
        {
            return  _content;
        }

        /**
         * コンテナに適用されたマスクです
         */
        protected var _contentMask : IScrollContainerMask;
        public function get contentMask() : IScrollContainerMask
        {
            return _contentMask;
        }

        //--------------------------------------------------------------------------
        //
        //  inprementation of IView
        //
        //--------------------------------------------------------------------------
        /**
         * @copy IScrollContainer#actualHeight
         */
        private var _actualHeight : int = -1;
        public function get actualHeight() : int
        {
        	if (_actualHeight == -1)
        	   actualHeight = -1;
        	   
            return  _actualHeight;
        }
        public function set actualHeight(value : int) : void
        {
            if (value == -1)
            {	
                var actialBounce : Rectangle;
                try
                {
                    actialBounce = getActualBounce();
                }
                catch(e : Error)
                {
                	trace("warning : actualHeightを取得しようとしましたがBitmapDataのサイズ制限を超えました.widht, heightプロパティを使用します.");
                    trace(e, width, height);
                    actialBounce = new Rectangle(0, 0, width, height);
                }
                _actualHeight = actialBounce.height;
            }
            else
            {                _actualHeight = value;
            }
        }

        /**
         * @copy IUIView#externalHeight
         */
        private var _externalHeight : int = -1;
        public function get externalHeight() : int
        {
            return  _externalHeight;
        }
        public function set externalHeight(value : int) : void
        {
            _externalHeight = (value == -1) ? getExternalBounce().height : value;
        }

        /**
         * @copy IScrollContainer#externalY
         */
        private var _externalY : Number = -1;
        public function get externalY() : int
        {
            if (_externalY == -1)
        	   _externalY = getExternalBounce().y; 
        	
            return _externalY;
        }
        
        private var _externalX : Number = -1;
        public function get externalX() : int
        {
            if (_externalX == -1)
               _externalX = getExternalBounce().x; 
            
            return _externalX;
        }
        
        /**
         * @copy IScrollContainer#externalWidth
         */
        public function get externalWidth() : int
        {
            return _externalWidth;
        }
        
        public function set externalWidth(value : int) : void
        {
            _externalWidth = (value == -1) ? getExternalBounce().width : value;
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: calcuration of actual and external size
        //
        //--------------------------------------------------------------------------
        //コンテンツが置かれた座標系におけるpixelBounceを返します.これはコンテンツの見かけ上のバウンディングボックスです
        private function getExternalBounce() : Rectangle
        {
        	return DisplayObjectUtil.getPixelBounce(_content);
        }

        private function getActualBounce() : Rectangle
        {
            var temp : DisplayObject = _content.mask;
            var tempX : Number = _content.x;            var tempY : Number = _content.y;
            _content.mask = null;
            _content.x = 0;            _content.y = 0;            var bounce:Rectangle = getExternalBounce();
            _content.mask = temp;
            _content.x = tempX;            _content.y = tempY;
            return bounce;
        }
    }
}
