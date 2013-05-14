package com.imajuk.commands.loading
{
    /**
     * @author shin.yamaharu
     */
    public interface ILoadComponent
    {
        /**
         * ロード終了を通知する際に、ロードされたアセットの初期化を待つかどうか（Event.INITを待つかどうか）設定できます.
         */
        function get waitInitialize():Boolean;
        function set waitInitialize(value:Boolean) : void;
    }
}
