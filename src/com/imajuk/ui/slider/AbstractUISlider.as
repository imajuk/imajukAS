package com.imajuk.ui.slider 
{
    import com.imajuk.interfaces.INormalizer;
    import com.imajuk.ui.IUISlider;
    import com.imajuk.ui.IUIView;

    import flash.display.Sprite;

    /**
     * @author shinyamaharu
     */
    public class AbstractUISlider extends Sprite implements IUISlider, INormalizer 
    {
        public function AbstractUISlider(barInstance : IUIView, backgroundInstance : IUIView) 
        {
            //=================================
            // bar
            //=================================
            _bar = barInstance;
            
            //=================================
            // background
            //=================================
            _bg = backgroundInstance;
        }

        protected var _model : UISliderModel;
    	
    	//--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        public function set size(value : int) : void 
        {
            _model.size = value;
            refresh();
        }
    	
    	//--------------------------------------------------------------------------
        //
        //  implementation of IUISlider
        //
        //--------------------------------------------------------------------------
        protected var _bar : IUIView;
        public function get bar() : IUIView
        {
            return _bar;
        }

        protected var _bg : IUIView;
        public function get backGround() : IUIView
        {
            return _bg;
        }
        
        public function reset() : void
        {
        }
        
        //--------------------------------------------------------------------------
        //
        //  implementation of INormalizer
        //
        //--------------------------------------------------------------------------
        
        public function get value() : Number
        {
            return _model.value;
        }
        public function set value(value : Number) : void
        {
            _model.value = value;
            refresh();
        }

        public function get nomalizedValue() : Number
        {
            return _model.nomalizedValue;
        }
        public function set nomalizedValue(value : Number) : void
        {
            _model.nomalizedValue = value;
            refresh();
        }
        
        //--------------------------------------------------------------------------
        //
        //  implementation of IUIView
        //
        //--------------------------------------------------------------------------
        
        public function get actualHeight() : int
        {
            return height;
        }

        public function get externalHeight() : int
        {
            return _model.size;
        }

        public function get externalWidth() : int
        {
            return width;
        }
        
        public function set externalWidth(value : int) : void
        {
            size = value;
        }

        public function get externalX() : int
        {
            return x;
        }
        
        public function get externalY() : int
        {
            return y;
        }

        public function set actualHeight(value : int) : void
        {
            height = value;
        }

        public function set externalHeight(value : int) : void
        {
            size = value;
        }
        
        public function build(model : UISliderModel) : void
        {
        	throw new Error("abstract");        }
        
        public function invisible() : void 
        {
            visible = false;
        }
        
        protected function refresh() : void 
        {
        	throw new Error("abstract");
        }

        public function get direction() : String
        {
            return _model.direction;
        }
        
        public function set direction(value:String) : void
        {
            _model.direction = value;
        }
        
        public function set arrowType(value:String) : void
        {
            _model.arrowType = value;
        }
        
        /**
         * スライダーのハンドルサイズ。
         * 0より大きい値を指定するとハンドルサイズは固定されます。
         * 0または指定しないとハンドルはスクロール可能範囲を表すように自動的に伸縮します
         */ 
        public function set handleSize(value : int) : void
        {
            _model.barSize = value;
            _model.isFlexibleHandle = (value <= 0);
        }

        public function set barAndArrowSeparateMargin(value:int) : void
        {
            _model.barAndArrowSeparateMargin = value;
        }
    }
}
