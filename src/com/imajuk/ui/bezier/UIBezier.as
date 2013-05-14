package
com.imajuk.ui.bezier{
    import com.imajuk.drawing.AnchorPoint;
    import com.imajuk.drawing.AnchorPointRenderer;
    import com.imajuk.drawing.AnchorPointStyle;
    import com.imajuk.drawing.BezierHelper;
    import com.imajuk.drawing.BezierRenderer;
    import com.imajuk.drawing.BezierSegment;

    import flash.display.Graphics;
    import flash.display.IGraphicsData;
    import flash.display.Sprite;

    /**
     * @author shin.yamaharu
     */
    public class UIBezier extends Sprite
    {
        private var _ap1 : AnchorPoint;
        private var _ap2 : AnchorPoint;
        private var apRenderer : AnchorPointRenderer;
        private var apStyle : AnchorPointStyle;
        private var sizeRenderer : BezierRenderer;
        private var _auip : Array;
        
        public function UIBezier(accuracy:int, apStyle:AnchorPointStyle, ...param)
        {
            _auip = 
            param.map(function(ap : AnchorPoint, ...param) : UIAnchorPoint
            {
                return addChild(new UIAnchorPoint(ap)) as UIAnchorPoint;
            });
                        _ap1 = param[0];
            _ap2 = param[1];

            apRenderer = new AnchorPointRenderer();
            this.apStyle = apStyle;
            sizeRenderer = new BezierRenderer(accuracy);
            
            ContextMenuUtil.register(this, ["generate code"], [function() : void
            {
            	var s:String = 
                    "new UIBezier(\n" +
                    "    $accuracy, $style,\n" + 
                    "    AnchorPointHelper.create(new Point($ap1_x, $ap1_y), $ap1_a, $ap1_l),\n" + 
                    "    AnchorPointHelper.create(new Point($ap2_x, $ap2_y), $ap2_a, $ap2_l)\n"+
                    ")";
                    
                s = s.split("$accuracy").join(String(accuracy));                              s = s.split("$ap1_x").join(_ap1.x);                              s = s.split("$ap1_y").join(_ap1.y);                s = s.split("$ap2_x").join(_ap2.x);                s = s.split("$ap2_y").join(_ap2.y);                s = s.split("$ap1_l").join(_ap1.lefthandleLength);                s = s.split("$ap2_l").join(_ap2.lefthandleLength);                s = s.split("$ap1_a").join(_ap1.vector.angle);                s = s.split("$ap2_a").join(_ap2.vector.angle);
                              
                trace(s);
            }]);
        }
        
        
        public function get ap1() : AnchorPoint
        {
            return _ap1;
        }
        
        public function get ap2() : AnchorPoint
        {
            return _ap2;
        }

        public function getBezier() : BezierSegment
        {
        	return BezierHelper.getBezierFromAnchorPair(ap1, ap2);
        }

        public function draw(graphics : Graphics, color:int) : void
        {
            graphics.drawGraphicsData(apRenderer.getGraphicsDataFromAnchorPoints(Vector.<AnchorPoint>([_ap1, _ap2]), this, apStyle, true));
            graphics.lineStyle(1, color);
            graphics.drawGraphicsData(Vector.<IGraphicsData>([sizeRenderer.getGraphicsPathFromBezierCurve(Vector.<AnchorPoint>([_ap1, _ap2]), false)]));
        }

        public function set draggable(value:Boolean) : void
        {
        	super.mouseEnabled = value;
            _auip.forEach(function(apui : UIAnchorPoint, ...param) : void
            {
                apui.mouseEnabled = value;
            });
        }

        public function translateAP1(tx : Number, ty : Number) : void
        {
        	UIAnchorPoint(_auip[0]).x = tx;        	UIAnchorPoint(_auip[0]).y = ty;
        }

        public function translateAP2(tx : Number, ty : Number) : void
        {
        	UIAnchorPoint(_auip[1]).x = tx;
            UIAnchorPoint(_auip[1]).y = ty;
        }

    }
}
