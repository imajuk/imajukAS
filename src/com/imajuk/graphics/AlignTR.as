﻿package com.imajuk.graphics{    import com.imajuk.utils.DisplayObjectUtil;    import flash.display.DisplayObject;    import flash.geom.Point;    import flash.geom.Rectangle;    /**
     * @author yamaharu
     */    public class AlignTR extends AbstractAlignAction implements IALignAction    {        override public function execute(target : DisplayObject, coordinateSpace : AlignCoordinateSpace, aplyDirection : String = Align.BOTH) : void        {            var size : Rectangle = getSpaceSize(target, coordinateSpace),                p    : Point = DisplayObjectUtil.getGlobalPosition(coordinateSpace.container),                r    : Rectangle = DisplayObjectUtil.getPixelBounce(target),                x    : Number = p.x + size.width - r.width + offH,                y    : Number = p.y + offV;                            super.align(target, aplyDirection, x, y);        }        public function toString() : String        {            return "com.imajuk.graphics::AlignTR";        }    }}
