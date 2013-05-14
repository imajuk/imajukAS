package com.imajuk.ui 
{
    import com.imajuk.interfaces.IDisplayObject;

    /**
     * @author imajuk
     */
    public interface IUIView extends IDisplayObject
    {
    	/**
         * 本当の高さを設定します.
         * 本当の高さとは、コンテナの原点から子供の最南端までのピクセル数の合計です.
         * つまり、スクロールすることで見渡すことができるピクセル数の合計になります.
         * externalHeightとの違いに注意してください.
         * 手動での設定のほか、自動でピクセル数を計算することもできます.
         * @param value 設定する見た目の高さ
         *              -1を指定すると自動的にレンダリングされているピクセルの高さを設定します.
         */
        function get actualHeight():int;
        function set actualHeight(value:int):void
    	/**
         * 見た目の高さを取得または取得します.
         * 見た目の高さとは実際にレンダリングされているピクセルの高さです.
         * 例えばマスクされているディスプレイオブジェクトはheightプロパティと見た目の高さが
         * 一致するとは限りません.このためIUIViewは見た目の高さを設定する必要がある場合があります.
         * 
         * @param value	設定する見た目の高さ
         * 				-1を指定すると自動的にレンダリングされているピクセルの高さを設定します.
         */
    	function get externalHeight():int;
    	function set externalHeight(value:int):void    	/**
         * 見た目のを取得または取得します.
         * 見た目の高さとは実際にレンダリングされているピクセルの高さです.
         * 例えばマスクされているディスプレイオブジェクトはheightプロパティと見た目の高さが
         * 一致するとは限りません.このためIUIViewは見た目の高さを設定する必要がある場合があります.
         * 
         * @param value 設定する見た目の高さ
         *              -1を指定すると自動的にレンダリングされているピクセルの高さを設定します.
         */
        function get externalWidth():int;
    	function set externalWidth(value:int):void
    	
    	function get externalX() : int;    	function get externalY() : int;
    }
}
