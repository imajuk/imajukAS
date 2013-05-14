package com.imajuk.interfaces 
{
    import flash.display.DisplayObject;
    /**
     * 唯一のDisplayObjectをラップしていることを保証するインターフェイスです.
     * @author shinyamaharu
     */
    public interface IDisplayObjectWrapper extends IDisplayObject
    {
        /**
         * ラップしているアセットを返します
         */
        function get asset() : DisplayObject;
    }
}
