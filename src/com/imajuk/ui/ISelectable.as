package com.imajuk.ui 
{
    import flash.events.IEventDispatcher;
    /**
     * @author shin.yamaharu
     */
    public interface ISelectable extends IEventDispatcher
    {
        function get data():*
        
        function select():void;
        
        function setLabel(data:*):void
    }
}
