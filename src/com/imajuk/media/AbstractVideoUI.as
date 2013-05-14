package com.imajuk.media
{
    import flash.geom.Rectangle;

    import fl.motion.easing.Exponential;

    import com.imajuk.motion.ColorMatrixTweenHelper;
    import com.imajuk.motion.TweensyThread;
    import com.imajuk.ui.buttons.IButton;
    import com.imajuk.ui.slider.AbstractUISlider;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.geom.Point;
    /**
     * @author shinyamaharu
     */
    public class AbstractVideoUI  extends Sprite implements IVideoUI
    {
        protected var _barHolder : DisplayObjectContainer;
        protected var _progressbar : DisplayObject;
        protected var _loadingProgressbar : DisplayObject;
        private var proxy : ColorMatrixTweenHelper;
        private var _autoVisibleManagement : Boolean;
        private var _isHeadDragging : Boolean;
        private var playheadInitX : Number;
        private var _getDraggableArea : Rectangle;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        public function AbstractVideoUI(asset : Sprite, autoVisibleManagement : Boolean = true)
        {
            this.asset = addChild(asset) as Sprite;
            this._autoVisibleManagement = autoVisibleManagement;
            
            proxy = new ColorMatrixTweenHelper(this, null, -255);
            proxy.amount = 0;
            
            createInterface();
            
            _progressbar.scaleX = 0;
            _loadingProgressbar.scaleX = 0;
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        protected var asset : Sprite;
       
        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        protected var _soundUI : AbstractUISlider;
        
        public function get soundUI() : AbstractUISlider
        {
            return _soundUI;
        }

        protected var _playHead : IButton;
        
        public function get playHead() : Sprite
        {
            return Sprite(_playHead);
        }

        protected var _playButton : DisplayObject;
        
        public function get playButton() : DisplayObject
        {
            return _playButton;
        }

        protected var _full : DisplayObject;
        public function get fullscreenUI() : DisplayObject
        {
            return _full;
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------

        private function createInterface() : void
        {
            //=================================
            // playButton
            //=================================
            _playButton = 
                asset.addChild(createPlayBtn());
            
            //=================================
            // volume slider
            //=================================
            var sui:DisplayObject = createSoudSlider();
            if (sui)
            {
                _soundUI = 
                    asset.addChild(sui) as AbstractUISlider;
                _soundUI.name = "_soundSlider_";
            }
            
            //=================================
            // loading & progress bar
            //=================================
            _barHolder = createBarHolder();            _progressbar = createProgressBar();
            _loadingProgressbar = createLoadingBar();
            
            //=================================
            // playHead
            //=================================
            var ph:DisplayObject = createPlayHead();
            if (ph) 
            {
                _playHead = asset.addChild(ph) as IButton;
                playheadInitX = _playHead.x;
                _getDraggableArea = new Rectangle(_barHolder.x, _playHead.y, _barHolder.x + _barHolder.width, 0);
            }

            //=================================
            // full screen button
            //=================================
            var full:DisplayObject = createFull();
            if (full)
            {
                _full = asset.addChild(full);
            }

        }

        protected function createLoadingBar() : DisplayObject 
        {
            throw new Error("createLoadingBar is a abstract method.");
            return null;
        }

        protected function createProgressBar() : DisplayObject 
        {
            throw new Error("createProgressBar is a abstract method.");
            return null;
        }

        protected function createBarHolder() : DisplayObjectContainer 
        {
            throw new Error("createBarHolder is a abstract method.");
            return null;
        }

        protected function createPlayBtn() : DisplayObject
        {
        	throw new Error("createPlayBtn is a abstract method.");
        	return null;        }
        protected function createSoudSlider() : AbstractUISlider 
        {
        	throw new Error("createSoudSlider is a abstract method.");
        	return null;        }

        protected function createPlayHead() : DisplayObject
        {
        	throw new Error("createPlayHead is a abstract method.");
        	return null;
        }

        protected function createFull() : DisplayObject
        {
            throw new Error("createFull is a abstract method.");
            return null;
        }

        public function get hiddingBehavior() : Thread 
        {
        	var p:ParallelExecutor = new ParallelExecutor();
        	p.addThread(new TweensyThread(this, 0, 1, Exponential.easeOut, null, {alpha:0}));
        	p.addThread(new TweensyThread(proxy, 0, 1, Exponential.easeOut, null, {amount:1}));
        	return p;
        }
        
        public function get showingBehavior() : Thread 
        {
            var p:ParallelExecutor = new ParallelExecutor();
            p.addThread(new TweensyThread(this, 0, 1, Exponential.easeOut, null, {alpha:1}));
            p.addThread(new TweensyThread(proxy, 0, 1, Exponential.easeOut, null, {amount:0}));
            return p;
        }

        public function layout(videoWidth:int) : void 
        {
            throw new Error("abstract method");
        }

        public function get autoVisibleManagement() : Boolean
        {
            return _autoVisibleManagement;
        }
        public function set autoVisibleManagement(available:Boolean) : void
        {
            _autoVisibleManagement = available;
        }

        public function updatePlayHead(value:Number) : void
        {
            if (!_playHead)
                return;
                
            //=================================
            // プログレスバーの右端にヘッドの位置をあわせる
            //=================================
            //プログレスバーの左端の座標（barHolder座標系）
            var p : Point = new Point(_progressbar.x + _progressbar.width, 0);
            //そのグローバル座標
            p = _progressbar.parent.localToGlobal(p);
            //videoUI座標系での座標
            p = globalToLocal(p);
            //ヘッダの位置をアップデート
            _playHead.x = p.x;
        }

        public function updateProgressBar(value : Number) : void
        {
        	_progressbar.scaleX = value;
        	
        	if(!_isHeadDragging)
        	   updatePlayHead(value);
        }
        
        public function updateLoadingView(value : Number) : void
        {
        	_loadingProgressbar.scaleX = value;
        }
        
        public function get isHeadDragging() : Boolean
        {
            return _isHeadDragging;
        }
        
        public function set isHeadDragging(value : Boolean) : void
        {
            _isHeadDragging = value;
        }
        
        public function getPlayheadPosition() : Number
        {
            return (_playHead.x - playheadInitX) / _barHolder.width; 
        }
        
        public function getDraggableArea() : Rectangle
        {
            return _getDraggableArea;
        }
    }
}
