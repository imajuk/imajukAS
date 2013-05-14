package com.imajuk.ui.window 
{
    import org.libspark.thread.Thread;

    /**
     * @author shin.yamaharu
     */
    public interface IWindowContentBuilder 
    {
        /**
         * ウィンドウコンテントを初期化するThreadを返します
    	 */
        function getInitializeContentThread() : Thread;
		/**
		 * スクロール機能を初期化するThreadを返します
		 */
        function getInitializeScrollThread() : Thread;
        /**
         * ウィンドウのフレームを表示するThreadを返します
         */
        function getShowWindowFrameThread():Thread;
        /**
         * ウィンドウのコンテントを表示するThreadを返します
         */
        function getShowWindowContentThread() : Thread;
        /**
         * ウィンドウに機能がある場合、その機能をスタートするThreadを返します
         */
        function getStartContentThread() : Thread;
		/**
		 * クローズボタンを表示するThreadを返します
		 */
        function getShowCloseBtnThread():Thread;
		/**
		 * スクロール機能をスタートするThreadを返します
		 */
        function getStartScrollThread():Thread;
		/**
		 * ウィンドウが閉じられるまでアイドル状態にするThreadを返します
		 */
        function getIdleThread():Thread;
        /**
         * ウィンドウを非表示にするThreadを返します
         */
        function getHideContentThread() : Thread;
        /**
         * ウィンドウを破棄します
         */
        function dispose() : Thread;
    }
}
