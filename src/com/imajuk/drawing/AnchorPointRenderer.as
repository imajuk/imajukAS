package com.imajuk.drawing 
{
    import com.imajuk.geom.Vector2D;
    import com.imajuk.utils.DisplayObjectUtil;

    import flash.display.IGraphicsData;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsPathCommand;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * @author shinyamaharu
     */
    public class AnchorPointRenderer 
    {
    	private var drawnIndex:Array = [];
        private var debugDic : Dictionary = new Dictionary(true);
        
    	/**
         * アンカーポイントのセットを描画する描画データを返します.
         * @param anchorPoints            AnchorPointを要素にもつVectorです.
         * @param canvas                  AnchorPointが描画されるSpriteです.
         * @param style                   AnchorPointの描画スタイルです.
         * @param drawHandles             AnchorPointのハンドルを描画するかどうか.
         * @param drawAnchorPointIndex    AnchorPointのIDを描画するかどうか
         *                                このオプションを選択するとcanvasにTextFieldが
         *                                addChild()されます.
         */
        public function getGraphicsDataFromAnchorPoints(
                            anchorPoints : Vector.<AnchorPoint>,
                            canvas : Sprite,
                            style : AnchorPointStyle,
                            drawHandles : Boolean = false,
                            drawAnchorPointIndex : Boolean = false
                        ) : Vector.<IGraphicsData> 
        {
            var v:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
            anchorPoints.forEach(
                function(a:AnchorPoint, ...param):void
                {
                    v = v.concat(getGraphicsData(a, canvas, style, drawHandles, drawAnchorPointIndex));
                }
            );
            return v;
        }
        
    	/**
         * アンカーポイントを描画する描画データを返します.
         * @param anchorPoint             描画対象のAnchorPointです.
         * @param canvas                  AnchorPointが描画されるSpriteです.
         * @param style                   AnchorPointの描画スタイルです.
         * @param drawHandles             AnchorPointのハンドルを描画するかどうか.
         * @param drawAnchorPointIndex    AnchorPointのIDを描画するかどうか
         *                                このオプションを選択するとcanvasにTextFieldが
         *                                addChild()されます.
         */
        public function getGraphicsData(
                            anchorPoint:AnchorPoint, 
                            canvas:Sprite, 
                            style:AnchorPointStyle,
                            drawHandles:Boolean = false,
                            drawAnchorPointIndex:Boolean = false
                        ):Vector.<IGraphicsData>
        {
            var ve:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
            
            //=================================
            // registration point
            //=================================
            var a:Point = anchorPoint.point; 
            ve = ve.concat(getPointGraphicsData(a, style));
            
            //=================================
            // draw handle and index of AnchorPoint 
            // when debug is true
            //=================================
            if (drawHandles)
            {
                var b:Point = anchorPoint.leftHandle; 
                var c:Point = anchorPoint.rightHandle; 
                var v:Vector2D = anchorPoint.vector.normalize();
                
                //left handle
                var stroke:GraphicsStroke = new GraphicsStroke(1);
                stroke.fill = new GraphicsSolidFill(style.leftHandleStyle.lineColor, style.leftHandleStyle.lineAlpha);
                ve.push(stroke, GraphicsPathUtil.getLinePathData(a, b));
                //right handle
                var stroke2:GraphicsStroke = new GraphicsStroke(1);
                stroke2.fill = new GraphicsSolidFill(style.rightHandleStyle.lineColor, style.rightHandleStyle.lineAlpha);
                ve.push(stroke2, GraphicsPathUtil.getLinePathData(a, c));
                //normal line(法線)
                var stroke3:GraphicsStroke = new GraphicsStroke(1);
                stroke3.fill = new GraphicsSolidFill(style.lineColor, style.lineAlpha);
                ve.push(stroke3, GraphicsPathUtil.getLinePathData(a, a.add(new Point(v.coordinate.x * 30,v.coordinate.y * 30))));
                
                ve = ve.concat(getPointGraphicsData(b, style.leftHandleStyle));
                ve = ve.concat(getPointGraphicsData(c, style.rightHandleStyle));

                if (drawAnchorPointIndex)
                {
                    var tx:TextField;
                    if (debugDic[anchorPoint])
                    {
                        tx = debugDic[anchorPoint];
                    }
                    else
                    {
                        tx = new TextField();
                        tx.x = a.x;
                        tx.y = a.y;
                        tx.selectable = false;
                        tx.cacheAsBitmap = true;
                        var tf:TextFormat = new TextFormat();
                        tf.size = 9;
                        tx.defaultTextFormat = tf;
                        tx.text = String(anchorPoint.id);
                        debugDic[anchorPoint] = canvas.addChild(tx);
                    }
                    
                    drawnIndex.push(tx);
                }
            }
            
            return ve;
        }
   
        private static function getPointGraphicsData(
                                    p:Point,
                                    style:AnchorPointStyle
                                ):Vector.<IGraphicsData>
        {
            var h : Number = style.size * .5;
            var v : Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
            var cmd : Vector.<int> = new Vector.<int>(); 
            var data : Vector.<Number> = new Vector.<Number>(); 
            var path : GraphicsPath = new GraphicsPath(cmd, data);
            var stroke : GraphicsStroke = new GraphicsStroke(1);
            stroke.fill = new GraphicsSolidFill(style.color, 1); 
            v.push(stroke, path);
            
            switch(style.type)
            {
                case AnchorPointStyle.CIRCLE:
                    //TODO 円を書くコマンド
                    cmd.push(GraphicsPathCommand.MOVE_TO);
                    data.push(p.x - h, p.y - h);
                    cmd.push(GraphicsPathCommand.LINE_TO);
                    data.push(p.x + h, p.y - h);
                    cmd.push(GraphicsPathCommand.LINE_TO);
                    data.push(p.x + h, p.y + h);
                    cmd.push(GraphicsPathCommand.LINE_TO);
                    data.push(p.x - h, p.y + h);
                    cmd.push(GraphicsPathCommand.LINE_TO);
                    data.push(p.x - h, p.y - h);
                    break;
                case AnchorPointStyle.SQUEAR:
                    cmd.push(GraphicsPathCommand.MOVE_TO);
                    data.push(p.x - h, p.y - h);
                    cmd.push(GraphicsPathCommand.LINE_TO);
                    data.push(p.x + h, p.y - h);
                    cmd.push(GraphicsPathCommand.LINE_TO);
                    data.push(p.x + h, p.y + h);
                    cmd.push(GraphicsPathCommand.LINE_TO);
                    data.push(p.x - h, p.y + h);
                    cmd.push(GraphicsPathCommand.LINE_TO);
                    data.push(p.x - h, p.y - h);
                    break;
            }
            return v;
        }

        public function clearAnchor(toolContainer:Sprite):void
        {
            toolContainer.graphics.clear();
            
            if(!drawnIndex)
                return;
            
            drawnIndex.forEach(
                function(tx:TextField, ...param):void
                {
                    DisplayObjectUtil.removeChild(tx);
                }
            );
            drawnIndex = [];
            debugDic = new Dictionary(true);
        }
    }
    
    
}
