package com.imajuk.motion 
{
    import flash.display.Shape;
    import com.imajuk.utils.MathUtil;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    /**
     * @author shin.yamaharu
     */
    public class MatrixTweenHelper implements ITweenHelper
    {
        private var _target : DisplayObject;
        private var _fromMatrix : Matrix;
        private var _toMatrix : Matrix;
        private var _amount : Number = NaN;
        private var fx : Number;
        private var fy : Number;
        private var frt : Number;
        private var fsx : Number;
        private var fsy : Number;
        private var trt : Number;
        private var dx : Number;
        private var dy : Number;
        private var dsx : Number;
        private var dsy : Number;
        private var drt : Number;

        public function MatrixTweenHelper(
                            target:DisplayObject,
                            toMatrix:Matrix = null,
                            fromMatrix:Matrix = null,
                            amount:Number = 0
                        ) 
        {
            _target     = target;
            _fromMatrix = fromMatrix || new Matrix();
            _toMatrix   = toMatrix   || new Matrix();
            
            fx = _fromMatrix.tx;            fy = _fromMatrix.ty;
            
            dx = (_toMatrix.tx - fx);            dy = (_toMatrix.ty - fy);
            
            var s : Shape = new Shape(),
                tsx : Number, tsy : Number;
                    
            s.transform.matrix = fromMatrix;
            fsx = s.scaleX;
            fsy = s.scaleY;
            frt = MathUtil.degreesToRadians(s.rotation);

            s.transform.matrix = toMatrix;
            tsx = s.scaleX;
            tsy = s.scaleY;
            trt = MathUtil.degreesToRadians(s.rotation);

            dsx = (tsx - fsx);
            dsy = (tsy - fsy);
            drt = trt - frt;
            
            this.amount = amount;        }
        
        public function toString():String 
        {
            var s:String = "target:" + _target.name + "from:" + _fromMatrix + "to:" + _toMatrix; 
            return "MatrixTweenHelper[" + s + "]";
        }

        public function get amount():Number
        {
            return _amount;
        }

        public function set amount(value:Number):void
        {
        	if (_amount == value)
        	   return;
        	   
            _amount = value;

            var m : Matrix = new Matrix();
            m.scale(fsx + dsx * value, fsy + dsy * value);
            m.rotate(frt + drt * value);
            m.tx = fx + dx * value;
            m.ty = fy + dy * value;

            _target.transform.matrix = m;
        }
        
        public function set fromMatrix(fromMatrix : Matrix) : void
        {
            _fromMatrix = fromMatrix;
        }
        
        public function set toMatrix(toMatrix : Matrix) : void
        {
            _toMatrix = toMatrix;
        }
    }
}
