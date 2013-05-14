package com.imajuk.behaviors 
{
    import com.imajuk.color.Color;
    import com.imajuk.motion.ColorMatrixTweenHelper;


    /**
     * アセットを着色するボタンビヘイビアです.
     * FlatColorBehaviorがColorTransformを使用するのに対し、このクラスはColorMatrixを使用します.
     * 
     * @author shinyamaharu
     */
    public class ColorlizeBehavior extends AbstractButtonBehavior implements IButtonBehavior 
    {
        protected var _max : Number;
        protected var _color : Color;
        protected var _brightness : Number;
        protected var _colorTarget : Object;

        /**
		 * コンストラクタ
		 * 
		 * 通常、このタイプのボタンを生成したい場合はColorlizeButtonインスタンスを生成し、
	     * このクラスを直接インスタンス化する必要はありません。
	     * ただし、新しいviewを作るのではなく、既存のviewにビヘイビアを追加してボタンとして機能させたい場合は
	     * クラスはこのクラスを直接インスタンス化し、ButtonThreadに渡します.
	     * 
	     * @see ColorlizeButton
	     * @see ButtonThread
	     * 
		 */
        public function ColorlizeBehavior(
        					color:Color,
                            max:Number = .5,
        					colorTarget:Object = null,
                            brightness:Number = 0
                        ) 
        {
            super();
            
            _max = max;
            _color = color;
            _brightness = brightness;
            _colorTarget = colorTarget;
        }
        
        public static function create(
                            color:Color,
                            max:Number = .5,
                            colorTarget:Object = null,
                            brightness:Number = 0
                        ) : IButtonBehavior
        {
            return new ColorlizeBehavior(color, max, colorTarget, brightness);
        }
        
        override public function initialize(behaviorSubject:*, amount:Number) : IButtonBehavior
        {
            _target = resolveTarget(behaviorSubject, _colorTarget);
            proxy = new ColorMatrixTweenHelper(_target, _color, _brightness);
            
            return this;
        }
        
        override public function dispose() : void
        {
            super.dispose();
            proxy.dispose();
            proxy = null;
            _color = null;
            _colorTarget = null;
        }
        
        override public function clone() : IButtonBehavior
        {
            return new ColorlizeBehavior(_color, _max, _colorTarget, _brightness);
        }
        
    }
}
