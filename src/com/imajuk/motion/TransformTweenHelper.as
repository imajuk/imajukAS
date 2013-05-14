package com.imajuk.motion 
{
	import com.imajuk.utils.MathUtil;
	import flash.geom.Point;
	import com.imajuk.utils.DisplayObjectUtil;
    import flash.display.DisplayObject;
    /**
     * @author shin.yamaharu
     */
    public class TransformTweenHelper 
    {
        private var target:DisplayObject;
        private var _scale:Number = 1;        private var _scaleX:Number = 1;
        private var _scaleY:Number = 1;
        private var origin:Point;
        private var _rotation:Number;

        public function TransformTweenHelper(target:DisplayObject, origin:Point)         
        {
            this.origin = origin;
            this.target = target;
        }
        
        public function get scaleX():Number
        {
            return _scaleX;
        }
        
        public function set scaleX(scaleX:Number):void
        {
            _scaleX = scaleX;
            DisplayObjectUtil.scaleOnGlobalPoint(target, origin, _scaleX, _scaleY);        }
        
        public function get scaleY():Number
        {
            return _scaleY;
        }
        
        public function set scaleY(scaleY:Number):void
        {
            _scaleY = scaleY;
            DisplayObjectUtil.scaleOnGlobalPoint(target, origin, _scaleX, _scaleY);        }
        
        public function get scale():Number
        {
            return _scale;
        }
        
        public function set scale(scale:Number):void
        {
            _scale = scale;
            DisplayObjectUtil.scaleOnGlobalPoint(target, origin, _scale, _scale);        }
        
        public function get rotation():Number
        {
            return _rotation;
        }
        
        public function set rotation(value:Number):void
        {
            _rotation = value;
            DisplayObjectUtil.rotateOnGlobalPoint(target, origin, MathUtil.degreesToRadians(value));
        }
    }
}
