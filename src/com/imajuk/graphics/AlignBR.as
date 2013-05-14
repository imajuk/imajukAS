package com.imajuk.graphics {
    import flash.geom.Point;            import com.imajuk.utils.DisplayObjectUtil;            import flash.geom.Rectangle;        import flash.display.DisplayObject;            import com.imajuk.graphics.AbstractAlignAction;    import com.imajuk.graphics.IALignAction;        /**
     * @author yamaharu
     */
    public class AlignBR extends AbstractAlignAction implements IALignAction     {
        override public function execute(target:DisplayObject, coordinateSpace:AlignCoordinateSpace, aplyDirection : String = Align.BOTH):void        {        	var coordinateSize:Rectangle = getSpaceSize(target, coordinateSpace);            var p:Point = DisplayObjectUtil.getGlobalPosition(coordinateSpace.container);            var r:Rectangle = DisplayObjectUtil.getPixelBounce(target);                        var x : Number = p.x + coordinateSize.width - r.width + offH;
            var y : Number = p.y + coordinateSize.height - r.height + offV;                        super.align(target, aplyDirection, x, y);        }                public function toString() : String         {            return "com.imajuk.graphics::AlignBR";        }            }
}
