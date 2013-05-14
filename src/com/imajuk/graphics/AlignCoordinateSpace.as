package com.imajuk.graphics {
    import com.imajuk.utils.StageReference;    
    
    import flash.display.DisplayObject;        import flash.display.Stage;        import flash.display.DisplayObjectContainer;    /**     * DisplayObjectContainerの派生クラスを透過的にに扱うためのアダプタ     * 
     * @author yamaharu
     */
    public class AlignCoordinateSpace     {
        private var _container:DisplayObjectContainer;        public function AlignCoordinateSpace(container:DisplayObjectContainer)        {            _container = container || StageReference.stage;
        }                public function toString() : String {
            return "AlignCoordinateSpace[c:" + _container + ", x:" + x + ", y:" + y + ", w:" + width + ", h:" + height + "]";
        }        internal function get x():Number        {            return _container.x;        }        internal function get y():Number        {            return _container.y;        }        internal function get width():Number        {            return (_container is Stage) ? Stage(_container).stageWidth : _container.getBounds(_container.parent).width;        }        internal function get height():Number        {            return (_container is Stage) ? Stage(_container).stageHeight : _container.getBounds(_container.parent).height;        }        internal function get container():DisplayObjectContainer        {            return _container;        }        internal function contains(target:DisplayObject):Boolean        {            return _container.contains(target);        }                internal function get numChildren():int        {            return _container.numChildren;        }                internal function removeChild(target:DisplayObject):void        {            _container.removeChild(target);        }                internal function addChild(target:DisplayObject):void        {            _container.addChild(target);        }    }
}
