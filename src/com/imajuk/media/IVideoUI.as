package com.imajuk.media 
{
    import flash.geom.Rectangle;

    import com.imajuk.interfaces.IDisplayObject;
    import com.imajuk.ui.slider.AbstractUISlider;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    /**
     * ビデオのUIを定義するにはこのインターフェイスを実装します.
     * @author shinyamaharu
     */
    public interface IVideoUI extends IDisplayObject 
    {
    	//--------------------------------------------------------------------------
    	//
    	//  UIエレメント
    	//
    	//--------------------------------------------------------------------------
    	/**
         * ビデオの再生、または停止を制御するビューです
         */
        function get playButton():DisplayObject;
        /**
         * ビデオの再生位置を表すビューです.
         */
        function get playHead():Sprite;
        /**
         * ビデオの音量を制御するビューです.
         */
        function get soundUI():AbstractUISlider;
        
        function get fullscreenUI():DisplayObject;
        
        //--------------------------------------------------------------------------
        //
        //  mediation
        //
        //--------------------------------------------------------------------------
    	/**
    	 * ビデオのロード状況を表すビューをアップデートします.
    	 * ビデオのロード中に0~1の値がこのセッターに渡されます.
    	 * 実装クラスはの必要に応じてビューをアップデートできます.
    	 */
        function updateLoadingView(value:Number) : void;
    	/**
    	 * ビデオの再生状況を表すビュー（プログレスバー）をアップデートします.
         * ビデオの再生中に0~1の値がこのセッターに渡されます.
         * 実装クラスはの必要に応じてビューをアップデートできます.    	 */
        function updateProgressBar(value : Number) : void;
        /**
         * ビデオの再生状況を表すビュー（再生ヘッド）をアップデートします.
         * ビデオの再生中に0~1の値がこのセッターに渡されます.
         * 実装クラスはの必要に応じてビューをアップデートできます.
         */
        function updatePlayHead(value : Number) : void;
            	//--------------------------------------------------------------------------
    	//
    	//  レイアウト
    	//
    	//--------------------------------------------------------------------------
    	/**
    	 * UIをレイアウトします
    	 * フレームワークから一度だけ呼ばれます.
    	 * 引数にビデオのサイズが渡されるので、サイズにフィットするようにUIをレイアウトできます.
    	 */
        function layout(videoWidth : int):void;

        //--------------------------------------------------------------------------
        //
        //  表示と非表示
        //
        //--------------------------------------------------------------------------
        /**
         * UIを自動的に隠すかどうかの設定です.
         * trueを指定するとライブラリによりUIのロールオーバで表示
         * ロールアウトで非表示になります.
         * 表示、非表示の振る舞いはshowingBehaviorまたはhiddingBehaviorで定義します.
         */
        function get autoVisibleManagement() : Boolean;
        function set autoVisibleManagement(available:Boolean) : void;
        /**
         * UIを表示状態にする時のビヘイビアを返します.
         */
    	function get showingBehavior():Thread;
        /**
         * UIを非表示状態にする時のビヘイビアを返します.
         */
    	function get hiddingBehavior():Thread;

        //=================================
        // 再生ヘッドドラッグシーキング
        //=================================
        /**
         * 再生ヘッドをドラッグ中かどうか
         */
        function get isHeadDragging() : Boolean;        function set isHeadDragging(value:Boolean) : void;
        /**
         * 再生ヘッドの移動可能範囲
         */
        function getDraggableArea() : Rectangle;
        /**
         * 再生ヘッドの移動可能範囲に対する再生ヘッドの位置（0~1）
         */
        function getPlayheadPosition() : Number;
    }
}
