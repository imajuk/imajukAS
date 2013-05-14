package com.imajuk.graphics {
    import com.imajuk.constants.Direction;
    import flash.display.DisplayObjectContainer;        import flash.geom.Rectangle;        import flash.display.DisplayObject;        import flash.display.Stage;        import com.imajuk.utils.DisplayObjectUtil;        import com.imajuk.graphics.IALignAction;    /**
     * @author yamaharu
     */
    public class AbstractAlignAction implements IALignAction     {        protected var offH:Number = 0;        protected var offV:Number = 0;        public function execute(target:DisplayObject, coordinateSpace:AlignCoordinateSpace, aplyDirection : String = null):void        {        	throw new Error("abstract method must be implemented.");
        }                private function mayHaveProblem(target:DisplayObject, coordinateSpace:AlignCoordinateSpace):Boolean        {            //座標系オブジェクトがステージでもドキュメントクラスでもない場合で、ターゲットと親子関係にある時、            //座標系のサイズにターゲットの存在が影響している可能性がある.            return    !(coordinateSpace.container is Stage) &&                                     !DisplayObjectUtil.isStageChild(coordinateSpace.container) &&                                    DisplayObjectUtil.containsDeeply(coordinateSpace.container,target);        }                /**         * 座標系オブジェクトのサイズを取得する         */        protected function getSpaceSize(target:DisplayObject,coordinateSpace:AlignCoordinateSpace):Rectangle        {            var size:Rectangle;            var temp:DisplayObjectContainer;            if (mayHaveProblem(target, coordinateSpace))            {                //座標系オブジェクトとターゲットが親子関係にある場合、座標系のサイズを知るため一度ターゲットを取り除く                temp = target.parent;                 temp.removeChild(target);                size = new Rectangle(0, 0, coordinateSpace.width, coordinateSpace.height);            }                        //TODO  深度を元に戻す            if (temp)                temp.addChild(target);            else                size = new Rectangle(0, 0, coordinateSpace.width, coordinateSpace.height);                            return size;        }                public function set offsetH(value:Number):void        {        	offH = value;        }                public function set offsetV(value:Number):void        {            offV = value;
        }

        protected function align(target : DisplayObject, aplyDirection : String, x : Number, y : Number) : void
        {
            if (aplyDirection == Align.BOTH)                 DisplayObjectUtil.setGlobalPosition(target, x, y, true);
            else if                 (aplyDirection == Direction.HORIZON) DisplayObjectUtil.setGlobalX(target, x, true);
            else if                 (aplyDirection == Direction.VERTICAL) DisplayObjectUtil.setGlobalY(target, y, true);
        }
    }
}
