package com.imajuk.ui.buttons 
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    import com.imajuk.utils.GraphicsUtil;
    import com.imajuk.color.Color;

    /**
     * 汎用ボタン用シェイプ
     * @author shin.yamaharu
     */
    public class ButtonBase extends Sprite
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        public function ButtonBase(
    	                            width : int,
                                    height : int,
                                    ellipseWidth : int = 0,
                                    basefilters : Array = null,
                                    offColor : Color = null,
                                    lineTickness : Number = 0,
                                    lineColor : Color = null,
                                    linePixelSnapping : Boolean = true
                                    ) 
        {
            _lineColor = lineColor;
            _lineTickness = lineTickness;
            _offColor = offColor || new Color();
            
            if (basefilters)
            {
                _shadow = addChild(new Sprite()) as Sprite;
                //エッヂが微妙に見えてしまうので1px小さく作る
                var shadowBase : DisplayObject = drawBase(width - 2, height - 2, _offColor, ellipseWidth);
                shadowBase.name = "_shBmp_";
                shadowBase.x++;
                shadowBase.y++;
                _shadow.addChild(shadowBase);
                _shadow.filters = basefilters;
                _shadow.name = "_baseShadow_";
            }
            
            _base = addChild(new Sprite()) as Sprite;
            _base.addChild(drawBase(width, height, _offColor, ellipseWidth)).name = "_bBmp_";
            _base.name = "_baseShape_";
            
            if (lineTickness > 0)
            {
                _line = addChild(new Sprite()) as Sprite;
                var fillColor : Color = _offColor.clone();
                fillColor.alpha = 0;
                _line.addChild(drawBase(width, height, fillColor, ellipseWidth, lineTickness, lineColor, linePixelSnapping)).name = "_lBmp_";
                _line.x = _line.y = -lineTickness;
                _line.name = "_baseLine_";
            }
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        protected var _shadow : Sprite;
        private var _offColor : Color;
        private var _lineTickness : Number;
        private var _lineColor : Color;
        private var _line : Sprite;
        
        //--------------------------------------------------------------------------
        //
        //  overrideen properties
        //
        //--------------------------------------------------------------------------
        
        override public function get width() : Number
        {
            return _base.width;
        }

        override public function set width(value : Number) : void
        {
            _base.width = value;
            _shadow.width = _base.width;
        }
    	       
        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        protected var _base : Sprite;
        
        public function get base() : Sprite
        {
            return _base;
        }
        
        public function set baseColor(value : Color) : void
        {
            if (!value)
                return;
               
            _offColor = value; 
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------
    	        
        protected function drawBase(
                                width : int,
                                height : int,
                                color : Color,
                                ellipseWidth : Number,
                                lineTickness : Number = 0,
                                lineColor : Color = null,
                                linePixelSnapping : Boolean = true
                                ) : DisplayObject
        {
            return GraphicsUtil.getRoundRectAsBitmap(
            						width,
            						height,
            						color,
            						ellipseWidth,
            						lineTickness,
            						lineColor,
            						linePixelSnapping
            					);
        }
    }
}
