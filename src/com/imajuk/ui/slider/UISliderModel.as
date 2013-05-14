package com.imajuk.ui.slider 
{
    import com.imajuk.interfaces.INormalizer;
    import com.imajuk.ui.UIType;

    import flash.events.EventDispatcher;
    import flash.geom.Rectangle;

    /**
     * UISliderのモデル
     * UISliderは背景ビューとバービューから構成されます.
     * バーが指す値を返します。正規化された値を返す事もできます
     * @author shinyamaharu
     */
    public class UISliderModel extends EventDispatcher implements INormalizer
    {
        private var _barSpace : int;
        
        public var amount : int = 20;
        
        //統合アロー時のアローとバーのマージン
        private var _barAndArrowSeparateMargin : int = 0;
        internal function set barAndArrowSeparateMargin(value : int) : void
        {
            _barAndArrowSeparateMargin = value;
            calc();        }
        
        //統合アロー時のアロー同士のマージン
        private var _arrowAndArrowMargin : int = 0;
        internal function get arrowAndArrowMargin() : int
        {
            return _arrowAndArrowMargin;
        }
        internal function set arrowAndArrowMargin(value : int) : void
        {
            _arrowAndArrowMargin = value;
            calc();
        }
        
        //スライダーの方向
        internal var direction : String = UIType.VERTICAL;
        
        //値が0の時のバーの位置
        private var _destMin : int;
        public function get destMin() : int
        {
            return _destMin;
        }

        //値が1の時のバーの位置
        private var _destMax : Number;
        public function get destMax() : Number
        {
            return _destMax;
        }
        
    	//スライダー全体のサイズ
        protected var _size : int;
    	public function get size() : int
        {
            return _size;
        }
        public function set size(size : int) : void
        {
            _size = size;
            calc();        }

    	//バーのサイズ
        protected var _barSize : int;
        public function get barSize() : int
        {
            return _barSize;
        }
        public function set barSize(value : int) : void
        {
            _barSize = value;
            calc();        }
        
        //バーが値0または1の位置にきた時のバーと背景のマージン
        protected var _margine : int = 0;
        internal function set margine(value : int) : void
        {
            _margine = value;
            calc();        }
        
        //値が0の時のマージンを含まないバーの位置
        protected var _barPosMin : int;
        internal function set barPosMin(value : int) : void
        {
            _barPosMin = value;
            calc();        }
        
        //アローのレイアウトタイプ
        internal var arrowType : String = UIType.SEPARATED;
        
        //ハンドルが伸縮タイプかどうか
        protected var _isFlexibleHandle : Boolean = true;
        public function get isFlexibleHandle() : Boolean
        {
            return _isFlexibleHandle;
        }
        public function set isFlexibleHandle(isFrexible : Boolean) : void
        {
            _isFlexibleHandle = isFrexible;
        }
        
        //マイナスアローのサイズ
        protected var _lowArrowSize : int;
        internal function set lowArrowSize(value : int) : void
        {
            _lowArrowSize = value;
            calc();        }
        
        //プラスアローのサイズ
        protected var _highArrowSize : int;
        internal function set highArrowSize(value : int) : void
        {
            _highArrowSize = value;
            calc();
        }
        
        //バーの可動量        public function get barSpace() : Number
        {
        	return _barSpace;
        }
        
        //バーの可動範囲
        public function getBarRange() : Rectangle 
        {
        	if (direction == UIType.HORIZONAL)
                return new Rectangle(_destMin, 0, _barSpace, 0);
            else
                return new Rectangle(0, _destMin, 0, _barSpace);        }

        /**
         * 現在スライダーが指す値です
         */
        private var _value : Number;
        public function get value() : Number 
        {
            return _value;        }
        public function set value(value:Number):void
        {
        	_value = Math.max(_destMin, Math.min(value, _destMax));
        	
        	dispatchEvent(new UISliderEvent(UISliderEvent.UPDATE, value));
        }
        
        /**
         * 現在スライダーが指す正規化された値です
         */
        public function get nomalizedValue():Number
        {
            return _value / _barSpace;
        }
        public function set nomalizedValue(value:Number):void
        {
            this.value = _barSpace * value;
        }
        
        private function calc() : void
        {
            if (arrowType == UIType.SEPARATED)
                _barSpace = _size - _barSize - _margine * 2 - (_lowArrowSize + _highArrowSize);
            else
                _barSpace = _size - _barSize - _margine * 2 - (_lowArrowSize + _highArrowSize + _barAndArrowSeparateMargin + _arrowAndArrowMargin);
                
//            trace('_barSpace: ' + (_barSpace));
//            trace('------------');
//            trace('_size: ' + (_size));
//            trace('_barSize: ' + (_barSize));
//            trace('_margine: ' + (_margine));
//            trace('_lowArrowSize: ' + (_lowArrowSize));
//            trace('_highArrowSize: ' + (_highArrowSize));
//            trace('_barAndArrowSeparateMargin: ' + (_barAndArrowSeparateMargin));
//            trace('_arrowAndArrowMargin: ' + (_arrowAndArrowMargin));
            
                
            _destMin = _barPosMin + _margine;
            _destMax = _destMin + _barSpace;
        }
        
        public function get arrowSpace() : Number
        {
            return _lowArrowSize + _highArrowSize + _barAndArrowSeparateMargin + _arrowAndArrowMargin;
        }
    }
}
