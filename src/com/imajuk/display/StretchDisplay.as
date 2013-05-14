package com.imajuk.display
{
    import com.imajuk.constants.Direction;
    import com.imajuk.graphics.LiquidLayout;
    import com.imajuk.interfaces.IDisplayObjectWrapper;

    import flash.display.DisplayObject;
    import flash.display.Sprite;

    /**
     * @author imajuk
     */
    public class StretchDisplay extends Sprite implements IDisplayObjectWrapper
    {

        public function StretchDisplay(asset : DisplayObject, direction : String = Direction.BOTH, autoStart : Boolean = true)
        {
            _asset = addChild(asset);
            _direction = direction;
            if (autoStart)
                start();
        }

        public function start() : void
        {
            LiquidLayout.fitToStage(this, Direction.BOTH);
        }

        private var _asset : DisplayObject;
        public function get asset() : DisplayObject
        {
            return null;
        }

        private var _direction : String;
        public function get direction() : String
        {
            return _direction;
        }
    }
}
