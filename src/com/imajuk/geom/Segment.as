package com.imajuk.geom
{
    import com.imajuk.interfaces.IMotionGuide;

    import flash.geom.Point;
    import flash.geom.Rectangle;

	/**
	 * 線分を表現するクラス
	 * 線分は位置をもつ2次元ベクトルとして定義されます.
	 * @author imajuk
	 */
	public class Segment implements IMotionGuide
    {
		//--------------------------------------------------------------------------
		//
		//  Class Methods
		//
		//--------------------------------------------------------------------------
		//=================================
		// factory methods
		//=================================
		/**
		 * 2点から線分オグジェクトを生成します.
		 * 線分オブジェクトは方向をもちます.第1匹数はベクトルの始点、第2匹数はベクトルの終点となります
		 * @param p1	線分の両端の一点
		 * @param p2	線分の両端の点でp1ではない点
		 * @return		２点を結ぶ線分オブジェクト
		 */
        public static function createFromPoint(p1 : Point, p2 : Point, id : Number = NaN) : Segment 
        {
        	return Segment.createFromVector2D(
    					p1,
        				Vector2D.createFromPoint(p1, p2),
        				id
        			);
        }
		/**
		 * 開始点と2次元ベクトルから線分を生成します.
		 * @param point		線分の始点
		 * @param vector	線分のベクトル
		 * @return			任意の始点、ベクトルをもつ線分オブジェクト
		 */
		public static function createFromVector2D(
									point : Point, 
									vector : Vector2D,
								    id : Number = NaN
								) : Segment
		{
			var sg:Segment = new Segment();
			sg._vector = vector.clone();
			sg._begin = point.clone();
			sg._end = null;
			sg.id = id;
			return sg;
        }
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function Segment() 
		{
		}

		//--------------------------------------------------------------------------
		//
		//  properties
		//
		//--------------------------------------------------------------------------
		public var id : Number;

		/**
		 * 線分の始点です
		 * このプロパティを変更するとendプロパティも変更されます.
		 */
		private var _begin:Point = null;
		public function get begin():Point
		{
			return _begin;
		}
		public function set begin(point:Point):void
		{
			_begin = point;
			_end = null;
        }
        public function set begin2(point:Point):void
        {
            _begin = point;
        }

        /**
		 * 線分の終点です
		 * このプロパティを変更によって線分の角度が変わるとangle, vectorプロパティが変更されます.
		 * //TODO seg.end.x = 10のように直接ポイントのプロパティを変更すると整合性がとれなくなる		 */
		private var _end:Point = null;
        public function get end() : Point
        {
            if (!_end)
			 _end = validate(_begin, _vector);
            return _end;
        }
        public function set end(point:Point):void
		{
			_end = point;
            _vector = Vector2D.createFromPoint(_begin, point);
        }
        public function set end2(point:Point):void
        {
            _end = point;
        }

        /**
		 * 線分の方向と長さを表す2次元ベクトルです
		 * このプロパティを変更によって線分のベクトルが変わるとend, angleプロパティが変更されます.
		 */
		private var _vector:Vector2D = null;
		public function get vector():Vector2D
		{
			return _vector;
		}
		public function set vector(value:Vector2D):void
        {
            _vector = value;
            _end = null;
        }

		/**
		 * 線分の角度
		 * このプロパティを変更するとend, vectorプロパティも変更されます.
		 */
		public function get angle():Number
		{
			return _vector.angle;
		}
		public function set angle(value:Number):void
		{
			_vector.angle = value;
			_end = null;
		}
		
		/**
		 * 線分の長さ
		 * このプロパティを変更するとend, vectorプロパティも変更されます.
		 */
		public function get length():Number
		{
			return _vector.velocity;
		}
		public function set length(value:Number):void
        {
            _vector.velocity = value;
            _end = null;
        }

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		//=================================
		// for trace()
		//=================================
        public function toString() : String 
        {
            return "Segment[" + id + "](" + _begin + " " + end + ")";
        }
        
        public function equals(s:Segment):Boolean
        {
            return _begin.equals(s._begin) && end.equals(s.end);
        }

        //=================================
        // duplicate
        //=================================
		public function clone():Segment
		{
            var s : Segment = new Segment();
            s._begin = _begin.clone();
            s._end = end.clone();
            s._vector = _vector.clone();
            return s;
//			return Segment.createFromPoint(_begin, _end);		}
		
		//=================================
		// oparetion
		//=================================
        /**
         * 線分を回転します
         * このメソッドはend, angleプロパティを変更します
         * @param value 現在の角度に加えるラジアン度
         */
		public function rotate(angle:Number):Segment
		{
            _vector.rotate(angle);
            _end = null;
            
            return this;
        }
        
        //TODO 相対値に変更したのでBezierが動くか確認
        /**
         * 線分を移動させます
         * このメソッドはbegin, endプロパティを変更します.
         */
        public function translate(x : Number, y : Number) : void 
        {
            _begin.x += x;
            _begin.y += y;
            _end = null;
        }
        
		/**
		 * 線分を対角線にもつ矩形を返します.
		 * @param segment	対角線となるSegment
		 * @return			線分を対角線にもつ矩形
		 */
        public static function getBounce(segment:Segment) : Rectangle 
        {
        	var p1:Point = segment.begin;
        	var p2:Point = segment.end;
            return new Rectangle(
            			Math.min(p1.x, p2.x), 
            			Math.min(p1.y, p2.y), 
            			Math.abs(p1.x - p2.x), 
            			Math.abs(p1.y - p2.y));
        }
        
        //=================================
        // collision
        //=================================
		/**
		 * 任意の線分と交差しているかどうかを返します.
		 */
        public function isCrossing(sg : Segment) : Boolean 
        {
            var v : Vector2D = Vector2D.createFromPoint(_begin, sg._begin);
            var v1 : Vector2D = _vector; 
            var v2 : Vector2D = sg._vector; 
            var v1Xv2 : Number = v1.crossProduct(v2);

            // 平行
            if ( v1Xv2 == 0 ) 
                return false;
			
            var t1 : Number = v.crossProduct(v2) / v1Xv2;
            var t2 : Number = v.crossProduct(v1) / v1Xv2;
            var eps : Number = 0.00001;
            
            if ( t1 + eps < 0 || t1 - eps > 1 || t2 + eps < 0 || t2 - eps > 1 ) 
                return false;
            else
            	return true;
        }

        /**
         * ある線分に対し任意の点が線分の右側にあるかどうかを返します.
         * 多角形内に任意の点が含まれるかどうかを調べる時に使います.
         */
        public function isRightSide(point : Point) : Boolean 
        {
            var vx1 : Number = _begin.x;
            var vy1 : Number = _begin.y;
            var vx2 : Number = end.x;
            var vy2 : Number = _end.y;
            return ((vx2 - vx1) * (point.y - vy1) - (point.x - vx1) * (vy2 - vy1)) > 0;	
        }
        
        /**
         * @private
         * 始点とベクトルから終点を求める
         */        
        private static function validate(point:Point, vector:Vector2D):Point
        {
            return new Point(point.x + vector.vx, point.y + vector.vy);
        }

        public function getIntersection(sg : Segment) : Point
        {
        	if (!isCrossing(sg))
        	   return null;
            
            var a1 : Point = sg.begin.clone();
            var a2 : Point = sg.end.clone();
            var b1 : Point = begin.clone();
            var b2 : Point = end.clone();
            
            var b : Point = b2.subtract(b1);
            var d1 : Number = Math.abs(Vector2D.createFromPoint(b).crossProduct(Vector2D.createFromPoint(a1.subtract(b1))));
            var d2 : Number = Math.abs(Vector2D.createFromPoint(b).crossProduct(Vector2D.createFromPoint(a2.subtract(b1))));
            var t : Number = d1 / (d1 + d2);
            var c : Point = a2.subtract(a1);
            c.x *= t;            c.y *= t;
            c = a1.add(c);
            return c;
        }

        public function getValue(time : Number) : Point
        {
            return new Point(begin.x + (end.x - begin.x) * time, begin.y + (end.y - begin.y) * time);
        }
    }
}
