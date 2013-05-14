package com.imajuk.ui.slider
{
    import com.imajuk.ui.IUISlider;
    import com.imajuk.ui.UIType;

    import org.libspark.thread.Thread;
    /**     * @author shinyamaharu     */    public class UISliderResetThread extends Thread     {        private var uiSlider : IUISlider;        public function UISliderResetThread(uiSlider : IUISlider)        {            super();            this.uiSlider = uiSlider;        }        override protected function run() : void        {            uiSlider.alpha = 0;                        if (uiSlider.direction == UIType.HORIZONAL)                uiSlider.bar.x = 0;
             else                uiSlider.bar.y = 0;        }        override protected function finalize() : void        {        }    }}