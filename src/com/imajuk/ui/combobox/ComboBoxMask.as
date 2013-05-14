package com.imajuk.ui.combobox 
{
    import com.imajuk.ui.scroll.IScrollContainerMask;
    import com.imajuk.motion.TweensyThread;
    import com.imajuk.ui.scroll.view.ScrollMask;

    import org.libspark.thread.ThreadState;

    import flash.geom.Rectangle;

    import fl.motion.easing.Exponential;

    /**
     * コンボボックスの描画エリアを定義するマスク
     * 開閉するScrollMaskとして定義される
     * 
     * @author shin.yamaharu
     */
    internal class ComboBoxMask extends ScrollMask implements IScrollContainerMask
    {
        private var tween : TweensyThread;

        public function ComboBoxMask(rectangle:Rectangle, debug:Boolean = false)         
        {
            super(rectangle, debug);
        }

        internal function close():void
        {
        	if (_closedHeight <= 0)
        	   return;
        	               if (tween && tween.state == ThreadState.TERMINATED && _mask.height == _closedHeight)
        	   return;
            
            if (tween)
                tween.interrupt();
            
            tween = new TweensyThread(_mask, 0, .3, Exponential.easeOut, null, {height:_closedHeight});
            tween.start();
        }
        
        internal function open():void
        {
        	if (tween && tween.state == ThreadState.TERMINATED && _mask.height == _openedHeight)
        	   return;

            if (tween)
                tween.interrupt();

            tween = new TweensyThread(_mask, 0, _openDuration, Exponential.easeOut, null, {height:_openedHeight});
            tween.start();
        }
        
        /**
         * @private
         * 開いたときの高さだけを設定する。ビューはこのタイミングではアップデートされない
         */
        override public function set maskHeight(value:int):void
        {
        	openedHeight = value;
        }

        /**         * コンボボックスが開いたときのマスクの高さ
         */
        private var _openedHeight:int = 100;
        internal function get openedHeight():int
        {
            return _openedHeight;
        }
        internal function set openedHeight(value:int):void
        {
            _openedHeight = value;
        }

        /**
         * コンボボックスが閉じたときのマスクの高さ
         */
        private var _closedHeight:int;
        internal function get closedHeight() : int
        {
            return _closedHeight;
        }
        internal function set closedHeight(value:int):void
        {
            _closedHeight = value;
            _mask.height = _closedHeight;
        }
        
        /**
         * マスクを開く時間
         */
        private var _openDuration : Number = .5;
        internal function set openDuration(value:Number) : void 
        {
        	_openDuration = value;
        }
        internal function quickOpen() : void 
        {
            _mask.height = _openedHeight;
        }
    }
}
