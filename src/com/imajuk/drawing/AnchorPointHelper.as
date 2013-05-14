package  
com.imajuk.drawing
{
	import com.imajuk.utils.MathUtil;    

	import flash.geom.Point;    

	/**
	 * @author yamaharu
	 */
	public class AnchorPointHelper 
	{
		/**
		 * @param angle アンカーポイントの法線の向き
		 */
		public static function create(
									registration:Point,
									angle:Number,
									handleLength:Number
								):AnchorPoint
		{
			//左ハンドルの位置
			var left:Point = getLeftHandle(angle, registration, handleLength);
			//右ハンドルの位置
			var right:Point = getRightHandle(angle, registration, handleLength);
			return new AnchorPoint(registration, left, right);
		}

		public static function getRightHandle(
									rad:Number,
									registlation:Point, 
									handleLength:Number
								):Point
		{
			rad += MathUtil.degreesToRadians(90);
			return new Point(
					Math.cos(rad) * handleLength + registlation.x, 
					Math.sin(rad) * handleLength + registlation.y
				);
		}

		public static function getLeftHandle(
									rad:Number,
									registlation:Point,
									handleLength:Number
								):Point
		{
			rad += MathUtil.degreesToRadians(-90);
			return new Point(
						Math.cos(rad) * handleLength + registlation.x,
						Math.sin(rad) * handleLength + registlation.y);
        }

		/**
		 * 渡されたAnchorPointのセットを逆順にして新しいセットを返します.
		 */
        public static function invert(anchorPoints : Vector.<AnchorPoint>) : Vector.<AnchorPoint> 
        {
        	var v:Vector.<AnchorPoint>  = 
                anchorPoints.concat().reverse();
                
            //Vector.mapができないので一時変数を使う
            var v2:Vector.<AnchorPoint> = new Vector.<AnchorPoint>();
	        v.forEach(
                function(ap:AnchorPoint, ...param):void
                {
                    var ap2:AnchorPoint = ap.clone();
                    ap2.rotate(Math.PI);
                    v2.push(ap2);
                }
            );
            return v2;
        }
    }
}
