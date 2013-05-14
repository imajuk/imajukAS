package com.imajuk.motion 
{
    import com.imajuk.color.Color;
    import com.imajuk.color.ColorTransformEffect;
    import com.imajuk.color.ColorTransformUtils;
    import com.imajuk.constructions.InstanceFactory;
    import com.imajuk.geom.Vector2D;
    import com.imajuk.utils.MathUtil;
    import flash.display.DisplayObject;
    import flash.geom.ColorTransform;

    
    /**
     * ColorTransformによるTweenをサポートします.
     * 
     * DisplayObjectのColorTransformの適用によってできる以下のエフェクトをTweenできます.
     * これらのエフェクトはColorTransformEffectによって定義されています.
     * ・Tint　着色
     * ・2wayTint　２色での着色。オリジナルのピクセルの黒,白に対してそれぞれ着色します
     * ・Lightness　明度操作
     * ・Lightness_offset　オフセットによる明度操作
     * ・Invert　色の反転
     * 
     * @author shin.yamaharu
     */
    public class ColorTransformTweenHelper implements ITweenHelper
    {
        private var diff:int;
        private var target : DisplayObject;
        private var colorTransform : ColorTransform;
        private var _toAmount : Number;
        private var _offAmount : Number;

        public function ColorTransformTweenHelper(
                            target:DisplayObject,
                            amount:Number,
                            toColor:Color,
                            toAmount:Number = 1,
                            fromColor:Color = null,
                            offAmount:Number = 0
                        ) 
        {
            _offAmount = offAmount;
            _toAmount = toAmount;
            this.target = target;
            this._toColor   = toColor;
            this._fromColor = fromColor;
            this._amount    = amount;
            
            //=================================
            // 色相の回転方向
            // 11時方向〜1時方向：時計回り
            // 3時方向〜1時方向：反時計回り
            //=================================
            if (_fromColor && _fromColor.h > _toColor.h)
            {
                var angleA : Number = MathUtil.degreesToRadians(_fromColor.h);
                var angleB : Number = MathUtil.degreesToRadians(_toColor.h);
                var diff : Number = Vector2D.create(angleA).getRadiansWith2(Vector2D.create(angleB));
                if (diff > 0)
                {
                    //時計回り(11時方向〜13時方向に変換)
                    _toColor.h += 360;
                }
            }
            
            if (fromColor)
                target.transform.colorTransform = 
                    ColorTransformUtils.applyTint(target.transform.colorTransform, fromColor);
                
            this.amount = amount;
        }

        public function toString():String 
        {
            var s:String = "target:" + target.name + "from:" + _fromColor + "to:" + _toColor; 
            return "HSVColorTweenHelper[" + s + "]";
        }
        
        public static function create(mode : String, target : DisplayObject, amount : Number, ...params) : ColorTransformTweenHelper
        {
            switch(mode)
            {
                case ColorTransformEffect.TINT:
                    return InstanceFactory.newInstance(ColorTransformTweenHelper, [target, amount].concat(params)) as ColorTransformTweenHelper;
                    break;
                default:
                    throw new Error("un-recognize color transform effect mode.[" + mode + "]");
            }
            return null;
        }
        
        public function dispose() : void
        {
            target.transform.colorTransform = new ColorTransform();
            _fromColor = null;
            _toColor = null;
            target = null;
        }

        private var _amount:Number;
        public function get amount():Number
        {
            return _amount;
        }
        public function set amount(value:Number):void
        {
            _amount = value;
            
            colorTransform = target.transform.colorTransform;
            
            if (_fromColor)
            {
                var h : int,s : int,v : int;
                h = _fromColor.h;
                s = _fromColor.s;
                v = _fromColor.v;
                a = _fromColor.alpha;
                
                h = (h + (_toColor.h - h) * value) - diff;
                s = s + (_toColor.s - s) * value;
                v = v + (_toColor.v - v) * value;

                var a : Number;
                if (!isNaN(a))
                    a = a + (_toColor.alpha - a) * value;
                
                ColorTransformUtils.applyTint(
                    colorTransform,
                    Color.fromHSV(h,s,v,a),
                    value * _toAmount + (1 - value) * _offAmount
                );
            }
            else
            {
                ColorTransformUtils.applyTint(colorTransform, _toColor, value * _toAmount);
            }
            
            target.transform.colorTransform = colorTransform;
           
        }
        
        private var _toColor:Color;
        public function get toColor() : Color
        {
            return _toColor;
        }
        public function set toColor(value : Color) : void
        {
            _toColor = value;
        }

        private var _fromColor : Color;
        public function get fromColor() : Color
        {
            return _fromColor;
        }
        public function set fromColor(value : Color) : void
        {
            _fromColor = value;
        }

        public function get hasAlpha() : Boolean
        {
            return !isNaN(_toColor.alpha) || (_fromColor && !isNaN(_fromColor.alpha));
        }
    }
}
