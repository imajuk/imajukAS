package com.imajuk.ui.slider 
{
    import org.libspark.thread.Thread;

    /**
     * @author shinyamaharu
     */
    public interface ISliderCommandFactory 
    {
    	//--------------------------------------------------------------------------
        //
        //  for scrolling
        //
        //--------------------------------------------------------------------------
        /**
         * UIの機能を開始するThreadを返します
         */
        function startCommand() : Thread;

        /**
         * UIの機能を破棄するThreadを返します
         */
        function disposeCommand() : Thread;

        //--------------------------------------------------------------------------
        //
        //  methods for scroll UI
        //
        //--------------------------------------------------------------------------

        /**
         * UIを再構築するThreadを返します.
         * コンテナの内容が代わりサイズが変更された場合は、
         * このメソッドを呼び出してスクロールバーをアップデートする必要があります
         */
        function updateScrollbarCommand(autoCalcContentSize : Boolean = true) : Thread;

        /**
         * スクロールUIを初期状態に戻すThreadを返します.
         */
        function resetScrollbarCommand() : Thread;
    }
}
