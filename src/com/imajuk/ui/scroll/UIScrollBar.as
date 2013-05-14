package com.imajuk.ui.scroll 
{
    import com.imajuk.ui.IUISlider;
    import com.imajuk.ui.slider.UISlider;

    import flash.display.Sprite;

    /**
     * @author shin.yamaharu
     */
    public class UIScrollBar extends UISlider implements IUISlider
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        public function UIScrollBar(
                            timeline : Sprite, 
                            barClass : Class = null, 
                            barBGClass : Class = null, 
                            arrowClass : Class = null
                        )
        {
            _model = new UIScrollBarModel();
            
            super(timeline, barClass, barBGClass, arrowClass);
        }
    	
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        private var isStarted : Boolean = false;
    	       
        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        public function get container_scrollbar_margin() : int 
        {
            return UIScrollBarModel(_model).container_scrollbar_margin;
        }
        public function set container_scrollbar_margin(value : int) : void 
        {
            UIScrollBarModel(_model).container_scrollbar_margin = value;
        }
    	        
        //--------------------------------------------------------------------------
        //
        //  Overridden Methods
        //
        //--------------------------------------------------------------------------
        override protected function refresh() : void 
        {
            //=================================
            // create scroll commands factory
            //=================================
            command = new BasicScrollCommandFactory(IScrollContainer(timeline), this, UIScrollBarModel(_model));
                
            //=================================
            // fire start command
            //=================================
            if (isStarted)
                start();
        }

        //--------------------------------------------------------------------------
        //
        //  original API
        //
        //--------------------------------------------------------------------------
        public function start() : void 
        {
            isStarted = true;            command.startCommand().start();
        }

        public function dispose() : void 
        {
            isStarted = false;
            command.disposeCommand().start();
        }

        public function set autoCalcContentSize(value:Boolean) : void
        {
            UIScrollBarModel(_model).autoCalcContentSize = value;
        }
    }
}
