package com.imajuk.graphics {
    import flash.display.DisplayObject;
        /**
     * @author yamaharu
     */
    public interface IALignAction     {
        function execute(target:DisplayObject, coordinateSpace:AlignCoordinateSpace, applyDirection : String = null):void;        function set offsetH(value:Number):void;        function set offsetV(value:Number):void;            }
}
