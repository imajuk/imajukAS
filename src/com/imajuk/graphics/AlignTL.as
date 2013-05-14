package com.imajuk.graphics {
    import flash.geom.Point;            import com.imajuk.utils.DisplayObjectUtil;        import com.imajuk.graphics.IALignAction;    import flash.display.DisplayObject;        /**
     * @author yamaharu
     */
    public class AlignTL extends AbstractAlignAction implements IALignAction     {
        override public function execute(target:DisplayObject, coordinateSpace:AlignCoordinateSpace, aplyDirection : String = Align.BOTH):void        {        	var p:Point = DisplayObjectUtil.getGlobalPosition(coordinateSpace.container);                        var x : Number = p.x + offH;
            var y : Number = p.y + offV;                        super.align(target, aplyDirection, x, y);        }                public function toString() : String         {            return "com.imajuk.graphics::AlignTL";        }    }
}
