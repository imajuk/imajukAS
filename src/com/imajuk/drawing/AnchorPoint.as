package com.imajuk.drawing
{
	import com.imajuk.geom.Vector2D;    
	import com.imajuk.utils.MathUtil;    

	import flash.geom.Point;

	/**
	 * @author yamaharu
	 */
	public class AnchorPoint
    {
        private static var _sid : int = 0;

        //--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function AnchorPoint(point:Point, left:Point, right:Point)
		{
			this.point = point;
			_leftHandle = left;
			_rightHandle = right;
			_leftHandleLength = Point.distance(_point, _leftHandle);
			_rightHandleLength = Point.distance(_point, _rightHandle);			id = _sid ++;
            
			//デフォルトの向きは、ハンドルを結ぶ直線に直行する方向.
			_vector = 
				Vector2D.createFromPoint(_leftHandle, _rightHandle)
					.rotate(-MathUtil.degreesToRadians(90));
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------


		//--------------------------------------------------------------------------
		//
		//  properties
		//
		//--------------------------------------------------------------------------
		
        public var id : int;
        
		private var _point:Point;

		public function get point():Point
		{
			return _point;
		}
		
		public function set point(point : Point) : void
        {
            _point = point;
            _x = point.x;            _y = point.y;
        }

		private var _x:Number;

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			_point.x = value;
			updateHandle();
		}

		private var _y:Number;

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
			_point.y = value;
			updateHandle();
		}

		private var _leftHandleLength:Number;

		public function get lefthandleLength():Number
		{
			return _leftHandleLength;
		}

		public function set lefthandleLength(value:Number):void
		{
			_leftHandleLength = value;
			updateHandle();
		}

		private var _rightHandleLength:Number;

		public function get rightHandleLength():Number
		{
			return _rightHandleLength;
		}

		public function set rightHandleLength(value:Number):void
		{
			_rightHandleLength = value;
			updateHandle();
		}

		private var _leftHandle:Point;

		public function get leftHandle():Point
		{
			return _leftHandle;
		}

		private var _rightHandle:Point;

		public function get rightHandle():Point
		{
			return _rightHandle;
		}

		private var _vector:Vector2D;

		public function get vector():Vector2D
		{
			return _vector;
		}

		public function set vector(value:Vector2D):void
		{
			_vector = value;
			updateHandle();
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function toString():String 
		{
			return 	"AnchorPoint[" + id + " " + int(point.x) + "," + int(point.y) + "]";
//					[ _point, leftHandle, rightHandle ] + "]";
		}

		public function clone():AnchorPoint
		{
			return new AnchorPoint(
							_point.clone(),
							_leftHandle.clone(),
							_rightHandle.clone()
						);
		}

		private function updateHandle():void
		{
			_leftHandle = 
				AnchorPointHelper.getLeftHandle(
					_vector.angle,
					_point, _leftHandleLength
				);
				
			_rightHandle = 
				AnchorPointHelper.getRightHandle(
					_vector.angle,
					_point,
					_rightHandleLength);
		}

		public function rotate(rad:Number):void
		{
			//180度以上の回転はハンドルの左右が入れ替わる
			if (rad%(Math.PI*2) >= Math.PI)
			{
				var l:Number = _leftHandleLength;
				var r:Number = _rightHandleLength;
				_leftHandleLength = r;
				_rightHandleLength = l;
			}
			_vector.rotate(rad);
			updateHandle();
        }

        public function translate(tx : Number, ty : Number) : void 
        {
        	x += tx;        	y += ty;
        }
    }
}
