package com.imajuk.ui.scroll 
{
	import com.imajuk.ui.slider.ISliderCommandFactory;
    import flash.display.DisplayObject;

    /**
     * @author imajuk
     */
    public interface IScrollCommandFactory extends ISliderCommandFactory
    {
        //--------------------------------------------------------------------------
        //
        //  for scrolling
        //
        //--------------------------------------------------------------------------

        function wheel(value : int) : void;

        function autoScroll() : void;

        //--------------------------------------------------------------------------
        //
        //  methods for scroll UI
        //
        //--------------------------------------------------------------------------
        /**
         * スクロールUI制御のためのモデル
         */
        function get model() : UIScrollBarModel;

        /**
         * ホイールのヒットエリアとなるDisplayObject
         */
        function get wheelTarget() : DisplayObject;
    }
}
