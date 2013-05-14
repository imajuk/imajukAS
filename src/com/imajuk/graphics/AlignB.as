package com.imajuk.graphics {
    import flash.geom.Point;        import flash.geom.Rectangle;        import com.imajuk.utils.DisplayObjectUtil;        import flash.display.DisplayObject;        import com.imajuk.graphics.AbstractAlignAction;    import com.imajuk.graphics.IALignAction;    /**
     * @author yamaharu
     */
    public class AlignB extends AbstractAlignAction implements IALignAction     {
        override public function execute(target:DisplayObject, coordinateSpace:AlignCoordinateSpace, aplyDirection : String = Align.BOTH):void
        {            var p              : Point = DisplayObjectUtil.getGlobalPosition(coordinateSpace.container),                coordinateSize : Rectangle = getSpaceSize(target, coordinateSpace),                r              : Rectangle = DisplayObjectUtil.getPixelBounce(target),                x              : Number = p.x + (coordinateSize.width - r.width) * .5 + offH,                y              : Number = p.y + (coordinateSize.height - r.height)    + offV;                        super.align(target, aplyDirection, x, y);        }                public function toString() : String         {            return "com.imajuk.graphics::AlignB";        }    }
}
