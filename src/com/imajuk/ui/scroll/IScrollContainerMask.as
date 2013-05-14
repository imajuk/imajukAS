package com.imajuk.ui.scroll 
{
    import com.imajuk.interfaces.IDisplayObject;
    import flash.geom.Rectangle;

    /**
     * IScrollContainerMaskはスクロールコンポネントにおけるコンテントのマスクです.
     * コンテントはIScrollContainerで定義され、
     * このクラスのインスタンスはIScrollContainer内に配置されます.
     * IScrollContainerMaskの領域はIScrollContainer内で自由に定義できますが
     * y座標を負の値にすることはできません.（縦スクロールの場合）
     * 
     * @see	IScrollContainer
     * @see	/diagram/scroll.ai 
     * @author imajuk
     */
    public interface IScrollContainerMask extends IDisplayObject 
    {
        function get rectangle() : Rectangle;
        function get maskWidth():int
        function set maskWidth(value:int):void
        function get maskHeight():int
        function set maskHeight(value:int) : void
    }
}
