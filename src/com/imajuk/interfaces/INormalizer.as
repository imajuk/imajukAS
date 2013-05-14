package com.imajuk.interfaces 
{
    import flash.events.IEventDispatcher;
    /**
     * 値と正規化された値をもつオブジェクトのインターフェイスです
     * @author shinyamaharu
     */
    public interface INormalizer extends IEventDispatcher
    {
    	function get value() : Number; 
        function set value(value:Number):void;
        function get nomalizedValue():Number;
        function set nomalizedValue(value:Number):void;
    }
}
