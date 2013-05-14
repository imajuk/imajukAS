package com.imajuk.utils 
{
    import flash.geom.Point;
    import flash.display.DisplayObject;
    /**
     * @author shin.yamaharu
     */
    public class TransformUtil 
    {
        public static const POSITION:Array = ["x", "y"];
        public static const POSITION_SIZE:Array = ["x", "y", "width", "height"];
        public static const POSITION_SIZE_ALPHA:Array = ["x", "y", "width", "height", "alpha"];
        public static const SIZE:Array = ["width", "height"];
        public static const POSITION_ALPHA:Array = ["x", "y", "alpha"];

        public static function getTransform(reference:DisplayObject, properties:Array):Object
        {
            var o:Object = {};
            properties.forEach(function(prop:String, ...param):void
            {
                o[prop] = reference[prop];
            });            return o;
        }

        /**
         * 対象となるオブジェクトのプロパティとガイドオブジェクトのプロパティを同期します.
         * @param target        同期対象となるオブジェクトです.
         * @param guideObject   同期するプロパティのコピー元になるオブジェクトです.
         * @param properties    同期対象となるプロパティのリストです.
         * @param useGlobal     DisplayObject同士のプロパティを同期する際に
         *                      グローバル座標系を使うかどうかを指定します.<br>
         *                      グローバル座標系を使うことで複雑な階層内にある
         *                      DisplayObjectであっても正確なポジショニングが期待できます。
         *                      ただしこのオプションを使用する場合は、
         *                      ターゲットオブジェクトとガイドオブジェクト双方が表示リスト内にある必要があります。
         *                      もし表示リスト内にない場合は例外をスローします.
         */
        public static function syncTransform(
                                target:DisplayObject,
                                guideObject:Object,
                                properties:Array,
                                useGlobal:Boolean = false):void
        {
            try
            {
                var isDisplayObjects:Boolean = guideObject is DisplayObject && target is DisplayObject;
                
                if (isDisplayObjects)
                {
                    var targetParent:DisplayObject = (isDisplayObjects) ? target.parent : null;                    var guideParent:DisplayObject = (isDisplayObjects) ? guideObject.parent : null;
                }
                
                if (useGlobal)
                {
                	if (!isDisplayObjects)
                        throw new Error("Global座標系での配置を試みましたがターゲットオブジェクトまたはガイドオブジェクトがDisplayObjectではありません.");
                    if (!guideParent)                        throw new Error("Global座標系での配置を試みましたが" + guideObject.name + "が表示リスト内にないため失敗しました.");
                    if (!targetParent)
                        throw new Error("Global座標系での配置を試みましたが" + target.name + "が表示リスト内にないため失敗しました.");

                    var gp:Point = DisplayObjectUtil.getGlobalPosition(DisplayObject(guideObject));                    var lp:Point = targetParent.globalToLocal(gp);
                }
                
                var idx:int;
                	
                properties.forEach(function(prop:String, ...param):void
                {
                    idx = param[0];
                	
                    if (useGlobal)
                    {
                        if (prop == "x")
                            target[prop] = lp.x;
                        if (prop == "y")
                            target[prop] = lp.y;
                    }
                    else
                    {
                        if (target[prop] != null)
                            target[prop] = guideObject[prop];
                    } 
                });
            }
        	catch(e:Error)
            {
                trace(e);
                trace([idx, target, guideObject, properties, useGlobal]);
            }
        }
    }
}
