package com.imajuk.drawing
{
    import flash.display.GraphicsPathCommand;
    import flash.display.GraphicsPath;
    import flash.geom.Point;    

    /**
     * ベジェ曲線で定義されたシェイプのレンダラー
     * 
     * ベジェ曲線で定義されたシェイプを描画します。
     * アンカーポイントオブジェクトのセット、またはベジェ曲線オブジェクトのセットを使用し描画します。
     * 
     * @author yamaharu
     */
    public class BezierRenderer 
    {
        public var accuracy:int;
        private var invertDrawing:Boolean;

        /**
		 * コンストラクタ
		 * @param accuracy	ベジェ曲線をレンダリングする際にどのくらいの直線で分割するか
		 * @param shape_color	シェイプのカラー
		 * @param line_color	ラインの色
		 * @param pattern		塗りにパターンを使用するかどうか
		 * @param invert		渡されたアンカーポイントは通常時計回りに描画されるが
		 * 						これを反時計回りに描画する場合はtrueを指定します
		 */
        public function BezierRenderer(
        					accuracy:int,
        					invert:Boolean = false
        				) 
        {
            this.accuracy = accuracy;
            invertDrawing = invert;
        }
        
        /**
         * AnchorPointのコレクションで定義された複数のベジェ曲線を描画するためのGraphicsPathを返します.
         * ベジェ曲線を一つだけ渡す場合はgetGraphicsPathFromBezierCurve()を使用します.
         * @param anchorPoints  ベジェ曲線を表現するAnchorPointのコレクションを要素にもつVectorです.
         * @param closedShape   閉じた図形かどうか
         */
        public function getGraphicsPathFromMultipleBezierCurve(
                            anchorPointSets:Vector.<Vector.<AnchorPoint>>,
                            closedShape:Boolean,
                            path:GraphicsPath = null
                        ):GraphicsPath        {
            path = path || getNewGraphicsPath();
            
            for each (var aps : Vector.<AnchorPoint> in anchorPointSets) 
            {
                getGraphicsPathFromBezierCurve(aps, closedShape, path);            }
            return path;
        }

        /**
         * AnchorPointのコレクションで定義されたベジェ曲線を描画するためのGraphicsPathを返します.
		 * 複数のベジェ曲線を渡す場合はgetGraphicsPathFromMultipleBezierCurve()を使用します.
		 * @param anchorPoints	ベジェ曲線を表現するAnchorPointのコレクションです.
		 * @param closedShape	閉じた図形かどうか
		 */
        public function getGraphicsPathFromBezierCurve(
        					anchorPoints:Vector.<AnchorPoint>,
        					closedShape:Boolean,
        					path:GraphicsPath = null
        				):GraphicsPath
        {
        	//ベジェ曲線の描画には少なくとも2つのAnchorPointが必要
            var apNum:int = anchorPoints.length;
            if (apNum <= 1)
                return null;
                    
            //閉じたシェイプを描画するには少なくとも3つ以上のアンカーポイントが必要
            var closed:Boolean = apNum > 2 && closedShape;
            
            return getGraphicsPathFromBezier(
            	BezierHelper.getBezierFromAnchors(
            		anchorPoints.concat(), closed, invertDrawing
            	),
            	path
            );
        }
        
		/**
		 * ベジェ曲線のコレクションを線分に分解しGraphicsPathとして返します.
		 * @param beziers		ベジェ曲線のコレクションです.
		 */
        public function getGraphicsPathFromBezier(
                            beziers : Vector.<BezierSegment>,
                            path:GraphicsPath = null
                        ) : GraphicsPath
        {
            try
            {           
                var p:Point = BezierSegment(beziers[0]).a;
            }
            catch(e:Error)
            {
                throw new Error("BezierSegmentが渡されませんでした");
                return null; 
            }
                
            path = path || getNewGraphicsPath(); 
                
            path.commands.push(GraphicsPathCommand.MOVE_TO);            path.data.push(p.x, p.y);
                
            
            for each (var bezir : BezierSegment in beziers) 
            {
                getPathFromBezier(bezir, path);
            }
            
            return path;        }

        /**
         * ベジェ曲線を線分に分解し描画コマンドをGraphicsPathに登録します
		 * @param bezir		ベジェ曲線オブジェクト
		 * @param myCanvas	描画対象になるGraphicsオブジェクト
         */
        private function getPathFromBezier(bezir : BezierSegment, path : GraphicsPath) : void 
        {
        	var t:Number = 0;
            var d:Number = 1 / accuracy;
            for (var i:int = 0;i < accuracy; i ++) 
            {
                t += d;
                var p:Point = bezir.getValue(t);
                path.commands.push(GraphicsPathCommand.LINE_TO); 
                path.data.push(p.x, p.y); 
            }
        }

        private function getNewGraphicsPath() : GraphicsPath 
        {
            return new GraphicsPath( new Vector.<int>(), new Vector.<Number>());
        }
    }
}
