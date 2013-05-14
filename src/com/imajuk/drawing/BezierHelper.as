package com.imajuk.drawing
{
    import flash.utils.Dictionary;
    import flash.geom.Point;    
    /**
     * @author yamaharu
     */
    public class BezierHelper 
    {
        public static function print(bezier:BezierSegment):void
        {
            trace(bezier.a, bezier.b, bezier.c, bezier.d);
        }
        
        /**
         * 2点のアンカーポイントをつなぐベジェ曲線を返します
         */
        public static function getBezierFromAnchorPair(
        							ap1 : AnchorPoint, 
        							ap2 : AnchorPoint, 
        							invertDrawing:Boolean = false
        						) : BezierSegment 
        {
        	var v:Vector.<AnchorPoint> = Vector.<AnchorPoint>([ap1, ap2]);
            return BezierSegment(
            			getBezierFromAnchors(v, false, invertDrawing)[0]
	               );
        }

    	/**
		 * アンカーポイントのセットをベジェ曲線のセットに変換します
		 * @param anchorPoints		ベジェ曲線を構成するアンカーポイントのセットです
		 * @param isClosedShape		アンカーポイントのセットが閉じたシェイプを定義しているかどうか
		 * @param invertDrawing		アンカーポイントをつなぐ順番
		 * 							アンカーポイントのセットはデフォルトで法線の向きに対して時計回りにつながれます。
		 * 							これを反時計回りでつなぐ場合はtrueを渡します。
		 * @param bezierToAnchor	この引数に辞書を渡すと、その辞書はベジェ曲線をキーに両端のアンカーポイントを返す辞書になります.
		 */
        public static function getBezierFromAnchors(
        							anchorPoints : Vector.<AnchorPoint>,
        							isClosedShape:Boolean = true,
        							invertDrawing:Boolean = false,
        							bezierToAnchor:Dictionary = null
        						) : Vector.<BezierSegment> 
        {
            if (anchorPoints.length <= 1)
            	throw new Error("ベジェ曲線の生成には少なくとも2つのAnchorPointが必要です");
            	
        	//反時計回りに描画する場合はアンカーポイントのセットを逆順にする
            if (invertDrawing)
            {
                var top:AnchorPoint = anchorPoints.shift();
                anchorPoints.reverse();
                anchorPoints = Vector.<AnchorPoint>([top]).concat(anchorPoints);            }
            if (isClosedShape)
            	anchorPoints.push(anchorPoints[0]);
            	
            var pre:AnchorPoint;
            
            var v2:Vector.<BezierSegment> = new Vector.<BezierSegment>();
            for each (var anchorPoint:AnchorPoint in anchorPoints) 
            {
                if (pre)
                {
                    var a : Point = pre.point;
                    var b : Point = pre.rightHandle;
                    var c : Point = anchorPoint.leftHandle;
                    var d : Point = anchorPoint.point;
                    var bezier : BezierSegment = new BezierSegment(a, b, c, d);
                    if (bezierToAnchor)
                        bezierToAnchor[bezier] = [pre, anchorPoint];
                }
                pre = anchorPoint;
                v2.push(bezier);
            }
            v2 = v2.slice(1);
	       return v2;
        }
    }
}
