package com.imajuk.render2D.plugins.dowrap
{
    import com.imajuk.interfaces.IDisplayObjectWrapper;
    import com.imajuk.render2D.plugins.tile.AbstractNode;

    import flash.display.DisplayObject;

    /**
     * @author imajuk
     */
    public class DONode extends AbstractNode implements IDisplayObjectWrapper
    {

        public function DONode(displayObject : DisplayObject)
        {
            super(displayObject ? displayObject.x : 0, displayObject ? displayObject.y : 0);

            if (displayObject)
                asset = displayObject;
        }

        override public function toString() : String
        {
            return "DONode " + ["id:" + _id];
        }

        private var _asset : DisplayObject;

        public function get asset() : DisplayObject
        {
            return _asset;
        }

        public function set asset(asset : DisplayObject) : void
        {
            if (_asset && contains(_asset))
                removeChild(_asset);

            _asset = asset;
            
            if (_asset)
            {
                addChild(_asset);
                _size = Math.sqrt(width * width + height * height);
            }
        }
    }
}
