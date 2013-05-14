package com.imajuk.behaviors
{
    import com.imajuk.logs.Logger;
    import flash.utils.getQualifiedClassName;
    /**
     * @author imajuk
     */
    public class BehaviorConfrict
    {
        private static var colorBehavior:String = getQualifiedClassName(ColorBehavior);
        private static var transparentBehavior:String = getQualifiedClassName(TransparentBehavior);
        
        public static function validate(behaviors : Array, context:String) : void
        {
            //ColorBehaviorに透明度が指定され、かつTransparentBehaviorと重複した場合は警告を出す
            var cBehavior:ColorBehavior;
            var tBehavior:TransparentBehavior;
            behaviors.forEach(function(b:IButtonBehavior, ...param) : void
            {
                var className:String = getQualifiedClassName(b); 
                if (className == colorBehavior)
                    cBehavior = ColorBehavior(b);
                else if (className == transparentBehavior)
                    tBehavior = TransparentBehavior(b);
            });
            
            if (cBehavior && cBehavior.proxy.hasAlpha && tBehavior)
            {
                var s:String = "アクション" + context + "に指定されたビヘイビア、ColorBehaviorとTransparentBehaviorがコンフリクトしています.\n" +
                "コンフリクトを解決するまではどちらかのビヘイビアが無視されることがあります.\n" +
                "この2つのビヘイビアを1つにまとめる事でコンフリクトを解決してください.\n" +
                "ColorBehaviorに指定するColorは透明度をもつ事ができます.";
                Logger.warning(s);
            }
        }
    }
}
