package com.imajuk.media
{
    /**
     * @author shin.yamaharu
     */
    public interface IBufferingAlert
    {
        //バッファリング中に呼び出されます
        function alertBuffering(bufferLength : Number, bufferTime : Number, per : Number) : void;
        //バッファリング終了時に呼び出されます
        function invisibleBufferingAlert() : void;
    }
}
