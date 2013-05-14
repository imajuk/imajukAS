package com.imajuk.ui.scroll 
{
	import com.imajuk.ui.IUIView;
    import flash.display.DisplayObject;

    /**
     * IScrollContainerはスクロールコンポネントにおけるコンテントを格納するコンテナです.
     * スクロールコンポネントはIScrollContainerMaskで定義される領域でこのコンテナをマスクします.
     * IScrollContainerのy座標は 0 ~ -a の値をとり決して正の数値にはなりません.（縦スクロールの場合）
     * 
     * @see	IScrollContainerMask
     * @see	/diagram/scroll.ai 
     * @author imajuk
     */
    public interface IScrollContainer extends IUIView
    {
        function get content():DisplayObject;

        function get contentMask():IScrollContainerMask;
    }
}
