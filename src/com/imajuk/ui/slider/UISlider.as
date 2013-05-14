package com.imajuk.ui.slider 
{
    import com.imajuk.interfaces.INormalizer;
    import com.imajuk.threads.ThreadUtil;
    import com.imajuk.ui.IUISlider;
    import com.imajuk.ui.IUIView;
    import com.imajuk.ui.UIType;
    import com.imajuk.ui.scroll.view.Bar;
    import com.imajuk.ui.scroll.view.BarBG;
    import com.imajuk.ui.scroll.view.NullArrow;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    



    /**
     * @author shinyamaharu
     */
    public class UISlider extends AbstractUISlider implements IUISlider, INormalizer
    {
    	//--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        public function UISlider(
                            timeline : DisplayObjectContainer, 
                            barClass : Class = null, 
                            barBGClass : Class = null, 
                            arrowClass : Class = null
                        ) 
        {
            this.timeline = timeline;
            
            if (!this._model)
            {
                this._model = new UISliderModel();
                this._model.addEventListener(UISliderEvent.UPDATE, dispatchEvent);
            }
                
            super(
                (barClass == null)   ? new Bar()   : new barClass(), 
                (barBGClass == null) ? new BarBG() : new barBGClass()
            );
            
            addChild(DisplayObject(_bg));
            addChild(DisplayObject(_bar));
            
            //arrow low
            _lowArrow = (arrowClass == null) ? new NullArrow() : new arrowClass();
            _lowArrow.name = "lowArrow";
            addChild(DisplayObject(_lowArrow));
            _model.lowArrowSize = _lowArrow.externalHeight;
            
            //arrow high
            _highArrow = (arrowClass == null) ? new NullArrow() : new arrowClass();
            _highArrow.name = "highArrow";
            Sprite(_highArrow).rotation = 180;
            addChild(DisplayObject(_highArrow));
            _model.highArrowSize = _highArrow.externalHeight;
            
            //同一フレーム内での複数回のrefreshをさける
            addEventListener(Event.ENTER_FRAME, function():void
            {
            	refreshed = false;
            });
            
            refresh();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        protected var command : BasicSliderCommandFactory;
        protected var timeline : DisplayObjectContainer;
        private var thread : Thread;
        private var refreshed : Boolean;


        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------

        public function set barSize(value : int) : void 
        {
            _model.barSize = value;
            refresh();
        }

        public function set bar_bg_margin(value : int) : void 
        {
            _model.margine = value;
        }

        override protected function refresh() : void 
        {
        	//同一フレーム内での複数回のrefreshをさける
        	if (refreshed) return;
        	refreshed = true;
        	   
            //=================================
            // create scroll commands factory
            //=================================
            command = new BasicSliderCommandFactory(timeline, this, _model);
                
            //=================================
            // fire start command
            //=================================
            ThreadUtil.interrupt(thread);
            thread = command.startCommand();
            thread.start();
        }
        
        protected var _lowArrow : IUIView;
        public function get lowArrow() : IUIView
        {
            return _lowArrow;
        }

        protected var _highArrow : IUIView;
        public function get highArrow() : IUIView
        {
            return _highArrow;
        }
        
        public function set arrowAndArrowMargin(value:int) : void
        {
            _model.arrowAndArrowMargin = value;
        }
        
        public function set amount(value:int) : void
        {
            _model.amount = value;
        }
        
        //--------------------------------------------------------------------------
        //
        //  implementation of IUISlider
        //
        //--------------------------------------------------------------------------

        override public function build(model : UISliderModel) : void
        {
            visible = true;
            
            //=================================
            // layout scroll arrow button
            //=================================
            switch(_model.arrowType)
            {
                case UIType.SEPARATED :
                    _lowArrow.y = _lowArrow.externalHeight * .5;
                    _highArrow.y = model.size - _highArrow.externalHeight * .5;
                    _model.barPosMin = _lowArrow.y + _lowArrow.externalHeight * .5; 
                    break;
                    
                case UIType.INTEGRATED :
                    _lowArrow.y = model.size - (_lowArrow.externalHeight * 1.5 + model.arrowAndArrowMargin);
                    _highArrow.y = _lowArrow.y + _lowArrow.externalHeight + model.arrowAndArrowMargin;
                    _model.barPosMin = 0; 
                    break;
                    
                default:
                    throw new Error("未知のarrowTypeです(" + _model.arrowType + ")");
            }
            
            //=================================
            // scroll bar
            // =================================
            if (model.direction == UIType.HORIZONAL)
            {
                _bg.externalWidth  = model.size;
                _bar.externalWidth = model.barSize;
                _bar.x             = model.destMin;            }
            else
            {
                _bg.externalHeight  = model.size;
                _bar.externalHeight = model.barSize;
                _bar.y              = model.destMin;
            }
            
        }
        
        override public function reset() : void 
        {
            command.updateScrollbarCommand().start();
            command.resetScrollbarCommand().start();
        }
    }
}
