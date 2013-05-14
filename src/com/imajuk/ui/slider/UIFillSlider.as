package com.imajuk.ui.slider
{
    import com.imajuk.constructions.AssetWrapper;
    import com.imajuk.interfaces.IDisplayObjectWrapper;
    import com.imajuk.interfaces.INormalizer;
    import com.imajuk.ui.IUISlider;
    import com.imajuk.ui.IUIView;
    import com.imajuk.ui.buttons.IButton;
    import flash.display.DisplayObject;
    import flash.display.Sprite;


    /**
     * UISliderは背景ビューとバービュー、カバーグラフィックビューから構成されます.
     * 伸縮タイプのスライダー
     * @author shinyamaharu
     */
    public class UIFillSlider extends AbstractUISlider implements IDisplayObjectWrapper, IUISlider, INormalizer
    {
        private var _cover : Sprite;
        private var _asset : Sprite;
        private var sliderThread : UIFillSliderThread;

        public function UIFillSlider(asset : Sprite, bar:IUIView, backGround:IUIView = null, cover:Sprite = null)
        {
            super(bar, backGround);
            this._asset = addChild(asset) as Sprite;
            
            //=================================
            // cover
            //=================================
            _cover = cover;            //カバーグラフィックをマウスに反応しないようにする
            if (_cover)
                _cover.mouseEnabled = false;

            //=================================
            // model
            //=================================
            _model = new UISliderModel();
            _model.size = 44;
            _model.barSize = 0;
            _model.margine = 0;
            _model.nomalizedValue = 1;
            build(_model);
            
            //=================================
            // controler
            //=================================
            sliderThread = new UIFillSliderThread(this);
            sliderThread.start();
        }

        public function get asset() : DisplayObject
        {
            return _asset;
        }

        public static function create(
                                 asset      : Sprite, 
                                 bar        : IButton, 
                                 backGround : Sprite = null,
                                 cover      : Sprite = null 
                             ) : UIFillSlider 
        {
            return AssetWrapper.wrapAsDisplayObject(
                        UIFillSlider, 
                        asset, 
                        bar, 
                        backGround, 
                        cover
                    ) as UIFillSlider;
        }
        
        override public function build(model : UISliderModel) : void
        {
        	value = model.value;
        }
        
        override protected function refresh() : void 
        {
             IDisplayObjectWrapper(bar).asset.width = _model.value;
        }
        
        override public function reset() : void
        {
        	value = 0;
        }
    }
}
