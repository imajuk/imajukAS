package com.imajuk.ui.scroll 
{
    import com.imajuk.ui.slider.UISliderModel;

    /**
     * UIScrollBarのモデル
     * @author shinyamaharu
     */
    public class UIScrollBarModel extends UISliderModel
    {
    	//コンテントコンテナのサイズを自動計算するかどうか
        public var autoCalcContentSize : Boolean = true;
        
        //コンテナとスクロールバーのマージン
        public var container_scrollbar_margin : int = 10;
        
        public function get needScrollbar() : Boolean
        {
            return !(noNeedScroll || noSizeBar);
        }

        private function get noSizeBar() : Boolean 
        {
            return _barSize == 0;
        }

        private function get noNeedScroll() : Boolean 
        {
            return _size < _barSize;
        }
    }
}
