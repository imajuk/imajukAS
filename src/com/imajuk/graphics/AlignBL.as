package com.imajuk.graphics {
    import flash.geom.Rectangle;        import flash.geom.Point;            import com.imajuk.utils.DisplayObjectUtil;            import flash.display.DisplayObject;            import com.imajuk.graphics.AbstractAlignAction;    import com.imajuk.graphics.IALignAction;        /**
     * @author yamaharu
     */
    public class AlignBL extends AbstractAlignAction implements IALignAction     {
        override public function execute(target:DisplayObject, coordinateSpace:AlignCoordinateSpace, aplyDirection : String = Align.BOTH):void        {        	var p:Point = DisplayObjectUtil.getGlobalPosition(coordinateSpace.container);            var coordinateSize:Rectangle = getSpaceSize(target, coordinateSpace);            var r:Rectangle = DisplayObjectUtil.getPixelBounce(target);                        var x : Number = p.x + offH;
            var y : Number = p.y + (coordinateSize.height - r.height) + offV;                        super.align(target, aplyDirection, x, y);        }                public function toString() : String         {            return "com.imajuk.graphics::AlignBL";        }    }
}
