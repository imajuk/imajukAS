package com.imajuk.utils 
{
    import com.imajuk.constants.Direction;
    import com.imajuk.constants.Geom;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.graphics.AspectRatio;
    import com.imajuk.graphics.LiquidLayout;
    import com.imajuk.logs.Logger;

    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageDisplayState;
    import flash.events.FullScreenEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import flash.text.TextField;

    
    /**
     * <code>DisplayObject</code>に関するユーティリティ.
     * 
     * @author imajuk
     */
    public class DisplayObjectUtil 
    {
        /**
         * Stageから任意のDisplayObjectまでのパスを文字列で返します.
         * DisplayObjectが表示リストにない場合は、可能な範囲で親をたどりそのパスを返します.
         * 
         * @param displayObject パスを取得したいDisplayObject
         * @return  任意のDisplayObjectのパス
         */
        public static function getDisplayListPath(displayObject:DisplayObject):String
        {
            return (function(displayObject : DisplayObject, path : String = ""):String
                    {
                        if (path.length > 0)
                           path = "." + path; 
                           
                        var name:String = 
                           (displayObject is Stage) ? "STAGE" : 
                           (displayObject === DocumentClass.container) ? "DOCUMENTCLASS" :
                           displayObject.name; 
                        path = name + path;
            
                        var parent:DisplayObjectContainer = displayObject.parent;
                           
                        if (parent)
                            return arguments.callee(parent, path);
            
                        return path;
                    }
                   )(displayObject);
        }

        /**
         * 任意のDisplayObjectContainerから任意の文字列を名前に含む子供を配列で返します.
         * 次の例では名前に"btn"を含むすべての子供のプロパティを変更しています.
         * DisplayObjectUtil.getAllChildrenByName(container, "btn")
         *     .forEach(
         *          function(child:DisplayObject, ...param)
         *          {
         *              child.x += 10
         *          }
         *      );
         *      
         * @param container 任意のDisplayObjectContainerインスタンス
         * @param name      名前の検索に使用する文字列 
         */
        public static function getAllChildrenByName(container:DisplayObjectContainer, name:String):Array
        {
            return getAllChildren(container).filter(
                function(d:DisplayObject, ...param):Boolean
                {
                    //TODO テスト書く
                    return d && d.name.indexOf(name) > -1; 
                });
        }

        /**
         * <code>DisplayObject</code>インスタンスのグローバル座標を返します.
         * 
         * @param displayObject     グローバル座標を調べたい<code>DisplayObject</code>インスタンス
         * @return                  グローバル座標を表す<code>Point</code>
         */
        public static function getGlobalPosition(displayObject:DisplayObject):Point
        {
            if (!displayObject || !displayObject.parent)
                return Geom.REGULAR_POINT;
                
            var p:Point = new Point(displayObject.x, displayObject.y);
            
            if (isStageChild(displayObject))
                return p;
            
            return displayObject.parent.localToGlobal(p);
        }

        /**
         * <code>DisplayObject</code>インスタンスがStage直下に配置されているかどうかを返します.
         * 
         * <p>グローバル座標系で操作できるオブジェクトかどうかを調べるのに便利です.</p>
         * 
         * @param displayObject    <code>Stage</code>直下に配置されているか調べたい<code>DisplayObject</code>インスタンス
         * @return                <code>Stage</code>直下に配置されているかどうか
         */
        public static function isStageChild(displayObject:DisplayObject):Boolean
        {
            var pa:DisplayObjectContainer = displayObject.parent as DisplayObjectContainer;
            return (pa && (pa == displayObject.stage));
        }

        /**
         * 渡された<code>DisplayObject</code>インスタンスを、指定したグローバル座標上に移動します.
         * 
         * @param displayObject     移動対象となる<code>DisplayObject</code>インスタンス
         * @param x                 移動先のグローバルx座標
         * @param y                 移動先のグローバルy座標
         * @param usePixelBounds    対象の表示エリアの左上隅を原点と考えて移動します.
         */
        public static function setGlobalPosition(displayObject:DisplayObject, x:int, y:int, usePixelBounds:Boolean = false):Point
        {
            return new Point(setGlobalX(displayObject, x, usePixelBounds), setGlobalY(displayObject, y, usePixelBounds));
        }

        /**
         * 渡された<code>DisplayObject</code>インスタンスのx座標をグローバル座標系で変更します.
         * y座標も同時に変更したい場合は<code>setGlobalPosition()</code>を使用します.
         * 
         * @param displayObject     移動対象となる<code>DisplayObject</code>インスタンス
         * @param x                 移動先のグローバルx座標
         * @param usePixelBounds    対象の表示エリアの左上隅を原点と考えて移動します.
         */
        public static function setGlobalX(
                                    displayObject:DisplayObject,
                                    globalX:Number,
                                    usePixelBounds:Boolean
                                ):Number
        {
            if (!displayObject)
                return 0;
            
            return execToSetGlobal(displayObject, "x", globalX, usePixelBounds);
        }

        /**
         * 渡された<code>DisplayObject</code>インスタンスのy座標をグローバル座標系で変更します.
         * x座標も同時に変更したい場合は<code>setGlobalPosition()</code>を使用します.
         * 
         * @param displayObject     移動対象となる<code>DisplayObject</code>インスタンス
         * @param y                 移動先のグローバルy座標
         * @param usePixelBounds    対象の表示エリアの左上隅を原点と考えて移動します.
         */
        public static function setGlobalY(displayObject:DisplayObject, y:Number, usePixelBounds:Boolean):Number
        {
            if (!displayObject)
                return 0;
            
            return execToSetGlobal(displayObject, "y", y, usePixelBounds);
        }

        /**
         * @private
         */
        private static function execToSetGlobal(
                                    displayObject:DisplayObject,
                                    prop:String,
                                    globalValue:Number,
                                    usePixelBounds:Boolean
                                ):Number
        {
            //displayObjectが配置されている座標系でみた、displayObjectのpixelBounds
            var r:Rectangle = (usePixelBounds) ? getLocalPixelBounds(displayObject) : Geom.REGULAR_RECT;
            
            if (isStageChild(displayObject))
                displayObject[prop] = globalValue - r[prop];
            else
                if (!containsInDisplayList(displayObject))
                {
                    throw new Error("指定されたDisplayObject[" + displayObject + "]は表示リストに追加されていません。");
                    return;
                }
            else
            {
                var isPropX:Boolean = (prop == "x");
                //displayObjectが配置されている座標系に適用されているMatrix
                var m:Matrix = displayObject.parent.transform.concatenatedMatrix;
                //displayObjectが配置されている座標系のスケール
                var s:Number = isPropX ? 1 / m.a : 1 / m.d;
                
                var gp:Point = isPropX ? new Point(globalValue, 0) : new Point(0, globalValue);
                var lp:Point = displayObject.parent.globalToLocal(gp);
                
                globalValue = lp[prop] ;
                displayObject[prop] = globalValue - r[prop] * s;
            }
                
            return displayObject[prop];
        }

        //displayObjectが配置されている座標系でみた、displayObjectのpixelBoundsを返す.
        private static function getLocalPixelBounds(displayObject:DisplayObject):Rectangle
        {
            //global座標系でのpixelBounds
            var gb:Rectangle = getPixelBounce(displayObject);
            //            trace("global pixelBounds", gb);            //displayObjectのglobal座標
            var p:Point = getGlobalPosition(displayObject);
            //            trace("global position", p);            //displayObjectの原点からpixelBoundsまでの距離
            var d:Point = new Point(gb.x - p.x, gb.y - p.y);
            //            trace("distance from origin(global)", d);
            //            trace("");            return new Rectangle(d.x, d.y, gb.width, gb.height);
        }

        /**
         * @private
         */
        private static function containsInDisplayList(displayObject:DisplayObject):Boolean
        {
            return displayObject && displayObject.stage; 
        }

        /**
         * <code>DisplayObject</code>インスタンスの、画面上にレンダリングされたピクセルの幅を返します.
         * 
         * @param displayObject     調査対象となる<code>DisplayObject</code>インスタンス
         * @return                  グローバル座標系での<code>DisplayObject</code>インスタンスの幅
         */
        public static function getRenderedWidth(displayObject:DisplayObject):int
        {
            return displayObject.width * getRealScale(displayObject, "scaleX");
        }

        /**
         * <code>DisplayObject</code>インスタンスの、画面上にレンダリングされたピクセルの高さを返します.
         * 
         * @param displayObject    調査対象となる<code>DisplayObject</code>インスタンス
         * @return                グローバル座標系での<code>DisplayObject</code>インスタンスの高さ
         */
        public static function getRenderedHeight(displayObject:DisplayObject):int
        {
            return displayObject.height * getRealScale(displayObject, "scaleY");
        }

        /**
         * @private 
         */
        private static function getRealScale(displayObject:DisplayObject, kind:String):Number
        {
            var p:DisplayObjectContainer = displayObject.parent;
            return (p) ? getMultipleParentScale(p, kind) : 1;
        }

        /**
         * @private 
         */
        private static function getMultipleParentScale(displayObject:DisplayObject, kind:String):Number
        {
            var s:Number = displayObject[kind]; 
            var p:DisplayObject = displayObject.parent;
            return (p) ? s * getMultipleParentScale(p, kind) : s;
        }

        /**
         * <code>DisplayObject</code>インスタンスが拡大、縮小されてレンダリングされているかどうかを調べます.
         * 
         * <p>このメソッドは、<code>DisplayObject</code>インスタンスが拡大、縮小されているかどうかを、
         * 再帰的に親をさかのぼって調べます.<br/>
         * つまり、このメソッドで<code>false</code>が得られると、その<code>DisplayObject</code>インスタンスは
         * 等倍でレンダリングされていると言えます.</p>
         * 
         * @param displayObject     拡大、縮小されているか調べたい<code>DisplayObject</code>インスタンス
         * @return                  <code>DisplayObject</code>インスタンスが拡大、縮小されているかどうか.
         */
        public static function isScaled(displayObject:DisplayObject):Boolean
        {
            var p:DisplayObject = displayObject.parent;
            var b:Boolean = (displayObject.scaleX != 1 || displayObject.scaleY != 1);
            return  (b) ? b : (p) ? (b || isScaled(p)) : b;
        }

        /**
         * 渡された<code>DisplayObjectContainer</code>インスタンスに含まれる全ての<code>DisplayObject</code>インスタンスをリムーブします.
         * 
         * @param displayObjectContainer    全ての子をリブームする対象となるコンテナ.
         *                                  <p>nullまたはStageを渡すとStage上の全てのDisplayObjectをリムーブします.<br/>
         *                                  ただし、DocumentClassはのぞきます.</p>
         */
        public static function removeAllChildren(displayObjectContainer:DisplayObjectContainer = null):void
        {
            if (!StageReference.isEnabled) 
            {
                if (displayObjectContainer == null)
                    throw new DisplayObjectUtilError(
                        DisplayObjectUtilError.FAILED_STAGE_REFERENCE_INIT, 
                        DisplayObjectUtilError.FAILED_STAGE_REFERENCE_INIT_ID
                    );
                else
                    StageReference.initialize(displayObjectContainer);
            }

            var c:DisplayObjectContainer = (displayObjectContainer == null) ? StageReference.stage : displayObjectContainer;
            var docClass:DisplayObjectContainer = StageReference.documentClass;
            
            DisplayObjectUtil.getAllChildren(c).forEach(function (a:DisplayObject, ...param):void
            {
                if (a != docClass)
                    c.removeChild(a);
            });
            
            if (c is Stage)
            {
                DisplayObjectUtil.getAllChildren(docClass).forEach(function (a:DisplayObject, ...param):void
                {
                    docClass.removeChild(a);
                });
            }
        }

        /**
         * 渡された<code>DisplayObjectContainer</code>インスタンスのすべての子を配列で返します.
         * 
         * <p>子が一つもない場合は空の配列を返します.<br/>
         * このメソッドは、直下の子のみを返します.孫の<code>DisplayObject</code>インスタンスは配列に含まれません.</p>
         * 
         * @param container    調査対象となる<code>DisplayObjectContainer</code>インスタンス
         */
        public static function getAllChildren(container:DisplayObjectContainer):Array
        {
            if (!container)
               return [];
               
            var a:Array = [];
            for (var i:int = 0;i < container.numChildren; i++)
            {
                a.push(container.getChildAt(i));
            }
            return a;
        }

        /**
         * 渡された<code>DisplayObjectContainer</code>インスタンスの子を再帰的に全てトレースします.
         * NOTES:インスタンスの子にMovieClipが含まれている場合そのMovieClipは再生を停止します.<br>
         * これはFlashPlayerが再生中のMovieClip子を正しく取得できない事があるためです.
         * 
         * @param displayObjectContainer    トレースしたい<code>DisplayObjectContainer</code>インスタンス
         * @param properties                オプション。出力される<code>DisplayObject</code>のプロパティを
         *                                  0個以上指定できます.
         */
        public static function dumpChildren(
                                    displayObjectContainer:DisplayObjectContainer,
                                    ...properties 
                               ):String
        {
//            var globalDepth:uint = 0;
            
            var traceChild : Function = 
                function(d:DisplayObject, depth:int, ...properties):void                {
                    var tab:String = "";
                    for (var j : int = 0; j < depth; j++) {
                        tab += "\t";
                    }
                    
                    var props:String = "";
                    if (properties.length > 0)
                    {
                        properties.forEach(function(p:String, ...param):void
                        {
                            var r:* =
                                (function(o:*, a:Array, i:int=0) : *
                                {
                                    var v:* = a[i];
                                    if (o.hasOwnProperty(v))
                                    {
                                        if (i == a.length-1)
                                            return o[v];
                                        else
                                            return arguments.callee(o[v], a, ++i);
                                    }
                                    return null;
                                })(d, p.split("."));
                            props += p + ": " + r + " ";
                        });
                    }

                    try
                    {
                        trace(tab, d, d.name, props);
                        //TODO 深度表示//                        trace(tab, globalDepth++, getGlobalDepth(d), d, d.name, props);
                    }
                    catch(e:Error)
                    {
                        trace(e);
                    }
                };
            
            var traceChildren:Function = 
                function (co:DisplayObjectContainer, depth:int):String
                {
                    traceChild.apply(this, [co, depth].concat(properties));
                    
                    if (co is MovieClip) MovieClip(co).gotoAndStop(MovieClip(co).currentFrame);
                    
                    var s:String = "";
                    for (var i:int = 0;i < co.numChildren; i++) 
                    {
                        var child:DisplayObject = co.getChildAt(i);
                        if (child is DisplayObjectContainer)
                            traceChildren(child as DisplayObjectContainer, depth + 1);                        else
                            traceChild.apply(this, [child, depth + 1].concat(properties));
                    }
                    
                    return s;
                };
                
            return traceChildren(displayObjectContainer, 0);
        }

        /**
         * DisplayObjectContainer.removeChild()は、
         * 削除したいchildがコンテナに含まれているかどうか確認しません.
         * もし、childがコンテナに含まれていない場合はランタイムエラーになります.
         * このメソッドはchildを削除する前にそのchildがchildがコンテナに
         * 含まれているかどうかをチェックします.
         * 
         * 明示的にランタイムエラーをキャッチしたい場合は使用しないで下さい.
         */
        public static function removeChild(child:DisplayObject):DisplayObject
        {
            if (!child)
                return child;
                
            var container:DisplayObjectContainer = child.parent;
            if (!container)
                return child;
                
            if (container.contains(child))
                container.removeChild(child);
                
            return child;
        }

        /**
         * DisplayObjectContainerの子供を再帰的に調べtargetが存在するかどうかを返します.
         * DisplayObjectContainer.contains()が、直下の子供しか調べないのに対し、このメソッドは孫以降まで調べます.
         */        public static function containsDeeply(container:DisplayObjectContainer, target:DisplayObject):Boolean        {
            var f:Function = function(c:DisplayObjectContainer):Boolean
            {
                var child:DisplayObject = c.getChildAt(i); 
                for (var i:int = 0;i < c.numChildren; i++) 
                {
                    if (child is DisplayObjectContainer)
                        return f(child as DisplayObjectContainer);
                    else
                        return c.contains(target);
                }
                return false;
            };
            return f(container);        }

        /**
         * 対象となるDisplayObjectを、グローバル座標系での任意の点を原点として回転させます.
         * 
         * @param target            対象となるDisplayObject
         * @param origin            回転の中心となるグローバル座標です.
         *                          DisplayObjectが配置されている座標系で指定したい場合は
         *                          DisplayObjectUtil.rotateOnLocalPoint()を使用します.
         * @param radians           新しい角度.これは絶対値です.
         */
        public static function rotateOnGlobalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    radians:Number
                                ):void
        {
            var p:DisplayObjectContainer = target.parent;
            var l:Point = (p) ? p.globalToLocal(origin) : origin;
            var m:Matrix = target.transform.matrix;
            var x:Number = l.x;
            var y:Number = l.y;
            m.translate(-x, -y);
            m.rotate(radians - MathUtil.degreesToRadians(target.rotation));
            m.translate(x, y);
            target.transform.matrix = m;
        }

        /**
         * 対象となるDisplayObjectを、DisplayObjectが配置された座標系での任意の点を原点として回転させます.
         * @param target    対象となるDisplayObject
         * @param origin    回転の中心となる座標
         *                  この座標は対象となるDisplayObjectのローカル座標系での位置です.
         *                  グローバル座標で指定したい場合はDisplayObjectUtil.rotateOnGlobalPoint()を使用します.
         * @param radians   新しい角度.これは絶対値です.
         */
        public static function rotateOnLocalPoint(
                                    target:DisplayObject,
                                    origin:Point, 
                                    radians:Number
                                ):void
        {
            rotateOnGlobalPoint(
                target,
                target.localToGlobal(origin),
                radians
            );
        }

        /**
         * 対象となるDisplayObjectを、グローバル座標系での任意の点を原点として拡大・縮小させます.
         * 
         * @param target    対象となるDisplayObject
         * @param origin    拡大・縮小の中心となるグローバル座標です.
         *                     ターゲットのローカル座標系で中心を指定したい場合は
         *                     scaleOnLocalPoint()を使用してください.
         * @param scaleX    新しいスケールX.これは絶対値です.
         * @param scaleY    新しいスケールY.これは絶対値です.
         */
        public static function scaleOnGlobalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    scaleX:Number,
                                    scaleY:Number
                                ):void
        {
            var p:DisplayObjectContainer = target.parent;
            var l:Point = (p) ? p.globalToLocal(origin) : origin;
            var m:Matrix = target.transform.matrix;
            var x:Number = l.x;
            var y:Number = l.y;
            m.translate(-x, -y);
            m.scale(1 / target.scaleX, 1 / target.scaleY);
            m.scale(scaleX, scaleY);
            m.translate(x, y);
            target.transform.matrix = m;
        }
        
        /**
         * 対象となるDisplayObjectを、DisplayObjectが配置された座標系での任意の点を原点として拡大・縮小させます.
         * 
         * @param target    対象となるDisplayObject
         * @param origin    拡大・縮小の中心となる座標です。これはターゲットの座標系での位置です.
         *                     グローバル座標系で中心を指定したい場合はscaleOnGlobalPoint()を使用してください.
         * @param scaleX    新しいスケールX.これは絶対値です.
         * @param scaleY    新しいスケールY.これは絶対値です.
         */
        public static function scaleOnLocalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    scaleX:Number,
                                    scaleY:Number
                                ):void
        {
            scaleOnGlobalPoint(target, target.localToGlobal(origin), scaleX, scaleY);
        }
        
        /**
         * グローバル座標系での任意の点を原点とし、その原点がグローバル座標系での任意の座標に位置するようにターゲットを移動します.
         * 
         * @param target        対象となるDisplayObject
         * @param origin        移動の基準になるグローバル座標系の基準点です.
         *                      ターゲットのローカル座標系で中心を指定したい場合は
         *                      translateOnLocalPoint()を使用してください.
         * @param destination   ターゲットの移動先です.これは絶対値です.
         *                      基準点がこの位置にくるようにターゲットは移動します.
         */
        public static function translateOnGlobalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    destination : Point) : void
        {
              var diff:Point = destination.subtract(origin);
            target.x += diff.x;
            target.y += diff.y;
        }
        
        /**
         * DisplayObjectが配置された座標系での任意の点を原点とし、その原点が同じ座標系での任意の座標に位置するようにターゲットを移動します.
         * 
         * @param target        対象となるDisplayObject
         * @param origin        移動の基準になるグローバル座標系の基準点です.
         *                      グローバル座標系で中心を指定したい場合はtranslateOnGlobalPoint()を使用してください.
         * @param destination   ターゲットの移動先です.これは絶対値です.
         *                      基準点がこの位置にくるようにターゲットは移動します.
         */
        public static function translateOnLocalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    destination : Point) : void
        {
            translateOnGlobalPoint(target, target.localToGlobal(origin), destination);
        }
        
        /**
         * グローバル座標系での任意の位置を原点としてDisplayObjectを変形します.
         * 
         * @param target        対象となるDisplayObject
         * @param origin        変形の基準になるグローバル座標系の基準点です.
         *                      ターゲットのローカル座標系で中心を指定したい場合は
         *                      transformOnLocalPoint()を使用してください.
         * @param radians       新しい角度.これは絶対値です.
         * @param scaleX        新しいスケールX.これは絶対値です.         * @param scaleY        新しいスケールY.これは絶対値です.
         * @param destination   ターゲットの移動先です.これは絶対値です.
         *                      基準点がこの位置にくるようにターゲットは移動します.
         */
        public static function transformOnGlobalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    radians:Number,
                                    scaleX:Number,
                                    scaleY:Number,
                                    destination : Point
                                ):void
        {
            var p:DisplayObjectContainer = target.parent;
            var l:Point = (p) ? p.globalToLocal(origin) : origin;
            var m:Matrix = target.transform.matrix;
            var x:Number = l.x;
            var y:Number = l.y;
            m.translate(-x, -y);
            m.scale(1 / target.scaleX, 1 / target.scaleY);
            m.rotate(radians - MathUtil.degreesToRadians(target.rotation));
            m.scale(scaleX, scaleY);
            m.translate(x, y);
            target.transform.matrix = m;
            
            translateOnGlobalPoint(target, origin, destination);
        }
        
        /**
         * DisplayObjectが配置された座標系での任意の点を原点とし、DisplayObjectを変形します.
         * 
         * @param target        対象となるDisplayObject
         * @param origin        変形の基準になる基準点です.これはターゲットのローカル座標系での位置です.
         *                      グローバル座標系で中心を指定したい場合はtransformOnGlobalPoint()を使用してください.
         * @param radians       新しい角度.これは絶対値です.
         * @param scaleX        新しいスケールX.これは絶対値です.
         * @param scaleY        新しいスケールY.これは絶対値です.
         * @param destination   ターゲットの移動先です.これは絶対値です.
         *                      基準点がこの位置にくるようにターゲットは移動します.
         */
        public static function transformOnLocalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    radians:Number,
                                    scaleX:Number,
                                    scaleY:Number,
                                    destination : Point
                                ):void
        {
            transformOnGlobalPoint(
                target,
                target.localToGlobal(origin), 
                radians, 
                scaleX, 
                scaleY, 
                destination
            );
        }

        /**
         * 渡されたDisplayObjectの表示オブジェクトツリーにおけるグローバルな深度を返します.
         * グローバルな深度とは、画面にレンダリングされているすべてのDisplayObjectの一気通貫した深度です.
         * DisplayObjectが表示ツリー内にない場合は-1を返します.
         * TODO テスト書く
         */
        public static function getGlobalDepth(displayObject:DisplayObject):int
        {
            if (!displayObject.stage)
               return -1;
               
            var f:Function = 
                function(displayObject:DisplayObject, add:int):int
                {
                    var parent : DisplayObjectContainer = displayObject.parent;
                    if (!parent)
                        return add;
                        
                    var idx:int = parent.getChildIndex(displayObject);
                    
                    if (idx != 0)
                    {
                        for (var i:int = 0;i < idx; i++) 
                        {
                            var d:DisplayObjectContainer = parent.getChildAt(i) as DisplayObjectContainer;
                            if (d)
                                add += getRenderedDecendantNum(d);
                            else
                                add++;
                        }
                    }
                        
                    return f(parent, add);
                };
            
            return f(displayObject, 0);
        }

        /**
         * 渡されたDisplayObjectにベクターシェイプが描画されているかどうかを返します.
         * TODO:たぶんShapeを渡すと失敗する.test書く
         */
        public static function hasVectorShape(displayObject : DisplayObject) : Boolean
        {
            if (displayObject is Sprite)
            {
                var spr:Sprite = Sprite(displayObject); 
                if (spr.numChildren == 0)
                {
                    if (rectangleHasSize(displayObject.getRect(displayObject)))
                        return true;
                }
                else
                {
                    var childBounce:Rectangle = new Rectangle();
                    for (var i:int = 0;i < spr.numChildren; i++) 
                    {
                        var child:DisplayObject = spr.getChildAt(i);
                        var b:Rectangle = child.getRect(spr); 
                        if (rectangleHasSize(b))
                          childBounce = childBounce.union(b);
                    }
                    return !spr.getBounds(spr).equals(childBounce);
                }
            }
            
            return false;
        }

        private static function rectangleHasSize(r:Rectangle):Boolean
        {
            if (r.width > 0 || r.height > 0)
                if(r.width != 6710886.4 && r.height != 6710886.4)
                    return true;
                    
            return false;
        }

        /**
         * コンテナに含まれた画面上にレンダリングされているすべてのDisplayObjectの数を返します.
         * コンテナ自身がベクターシェイプを持っている場合はコンテナもカウントされます.
         * コンテナが入れ子になっている場合、再起的にカウントします.
         * 
         * WARING!:コンテナにMovieClipが含まれている場合そのMovieClipは再生を停止します.<br>
         * これはFlashPlayerが再生中のMovieClip子を正しく取得できない事があるためです.
         * 
         * あるDisplayObjectが画面にレンダリングされているか知る方法
         * 1・表示リストに含まれる
         * 2・ベクターシェイプが描画されている、または大きさをを持つDisplayObjectを子供に持つ
         */
        public static function getRenderedDecendantNum(container:DisplayObjectContainer):int
        {
//            trace("\n");
            
            /**
             * for debug
             */
            var getIndent:Function = function(indent:int):String
            {
                var s:String = "";
                for (var k:int = 0;k < indent; k++) 
                {
                    s += "\t";
                }
                return s;
            };
            
            var f:Function = function(c:DisplayObject, indent:int = 0):int
            {
                if (!c.stage)
                    return 0;

                var cNum:int = 0;
                var co:DisplayObjectContainer = c as DisplayObjectContainer;
                
//                trace(getIndent(indent), "---", c.name, co, co is MovieClip);
                
                if (co)
                {
                    if (co is MovieClip)
                        MovieClip(co).gotoAndStop(MovieClip(co).currentFrame);
                    
                    for (var i:int = 0;i < co.numChildren; i++) 
                    {
                        var d:DisplayObject = co.getChildAt(i);
                        var a:int = f(d, indent + 1);
                        cNum += a;
//                        trace(getIndent(indent), d.name, a, "total:", cNum);                    }
                    //ベクターシェイプが描画されている場合はカウントする
                    if (hasVectorShape(c))
                    {
                        cNum ++;
//                        trace(getIndent(indent), "has vectorShape", "total:", cNum);
                    }
                }
                else
                {
                    if (c.width > 0 || c.height > 0)
                        if (c is TextField)
                           if (TextField(c).text.length > 0)
                               return ++cNum;
                           else
                               return cNum;
                        else
                            return ++cNum;
                }
                
                return cNum;
            };
            
            return f(container, 0);
        }
        
        //TODO テスト書く
        public function dumpParents(target : DisplayObject, s : String = "", indent : int = 0) : String
        {
            var t : String = "\n";
            for (var i : int = 0;i < indent; i++) 
            {
                t += "  ";
            }
            
            var a:String = "";
            if (target is Sprite)
                a = String(Sprite(target).mouseEnabled) + String(Sprite(target).mouseChildren);
            
            s += t + target.name + "("+ a + ")";
                
            if (target.parent)
                return dumpParents(target.parent, s, ++indent);
            else
                return s;
        }

        /**
         * DisplayObjectをアスペクト比を保持したまま任意のサイズの枠内に収まるようにスケールします.
         * 
         * @param target    スケール対象となるDisplayObject
         * @param width     DisplayObjectを収める枠の横幅         * @param height    DisplayObjectを収める枠の縦幅
         * @param fitType   フィットタイプは枠内にどのように収まるかを指定します.この値はスケール後のDisplayObjectのサイズに影響します.
         *                  有効な値は以下の通りです.
         *                  Direction.HORIZON :                         枠内の水平方向に隙間が出来なくなるまでDisplayObjectをスケールします.
         *                  Direction.VERTICAL :                        枠内の垂直方向に隙間が出来なくなるまでDisplayObjectをスケールします.
         *                  Direction.BOTH :                            AspectRatio.AUTO_SCALE_HOLDと同様です.
         *                  AspectRatio.KEEP_ASPECT_INSIDE_RECTANGLE :  水平方向または垂直方向どちらかに隙間が出来なくなるまでDisplayObjectをスケールします.
         *                                                              DisplayObjectと枠のアスペクト比が一致しない場合は枠内に隙間が出来ます.<br/>         *                  AspectRatio.KEEP_ASPECT_OVER_RECTANGLE :    水平方向および垂直方向どちらにも隙間が出来なくなるまでDisplayObjectをスケールします.
         *                                                              DisplayObjectと枠のアスペクト比が一致しない場合はDisplayObjectの縦横いずれかが枠外にはみだします.
         *                  デフォルトはAspectRatio.KEEP_ASPECT_OVER_RECTANGLEです.
         */
        public static function fitToRectangle(
                                    target : DisplayObject, 
                                    width : Number, 
                                    height : Number, 
                                    fitType : String = null,
                                    round : Boolean = true
                               ) : DisplayObject
        {
            fitType = (fitType == null) ? AspectRatio.KEEP_ASPECT_OVER_RECTANGLE : fitType;
            
            //ターゲットのスケールを一度元に戻す
            target.scaleX = target.scaleY = 1;

            var targetWidth:Number  = target.width;            var targetHeight:Number = target.height;
            
            //コンテナの比率（width/height）            var rateCon : Number    = width / height;
            //ターゲットの比率（width/height）
            var rateTar : Number    = targetWidth / targetHeight;

            //横を基準にフィットさせるかどうか
            var fitToGuideWidth : Boolean;
            switch(fitType)
            {
                case Direction.HORIZON:
                    fitToGuideWidth = true;
                    break;
                case Direction.VERTICAL:
                    fitToGuideWidth = false;
                    break;
                case Direction.BOTH:
                case AspectRatio.KEEP_ASPECT_INSIDE_RECTANGLE:
                    fitToGuideWidth = (rateTar > 1) ? rateTar > rateCon : rateTar > rateCon;
                    break;
                case AspectRatio.KEEP_ASPECT_OVER_RECTANGLE:
                    fitToGuideWidth = rateCon > rateTar;
                    break;
                case AspectRatio.KEEP_ASPECT_FILL_HORIZON:
                    fitToGuideWidth = true;
                    break;
                default :
                    throw new Error("未知のfitTypeが指定されました");
            }
            //スケール
            var scale : Number = fitToGuideWidth ? width / targetWidth : height / targetHeight;
            target.scaleX = target.scaleY = scale;
            target.width = round ? Math.round(target.width) : target.width;
            target.height = round ? Math.round(target.height) : target.height;
            Logger.debug(DisplayObjectUtil, "コンテナの比率（width/height）", rateCon);            Logger.debug(DisplayObjectUtil, "ターゲットの比率（width/height）", rateTar);            Logger.debug(DisplayObjectUtil, "横サイズを基準にフィットさせるかどうか", fitToGuideWidth);            Logger.debug(DisplayObjectUtil, "スケール", scale);
            
            return target;
        }
        
        /**
         * すべての子DisplayObjectのalphaを0にします. また同時にvisibleをfalseにする事も出来ます.
         * 
         * @param container     対象となるDisplayObjectContainer
         * @param alsoVisible   全ての子DisplayObjectのvisibleをfalseにするかどうか
         */
        public static function invisibleAllChildren(container : Sprite, alsoVisible:Boolean = true) : void
        {
            if(getAllChildren(container).length == 0)
               Logger.warning("コンテナ内にDisplayObjectがありませんでした.");
            if(getAllChildren(container).length == 1)
               Logger.warning("コンテナ内のDisplayObjectの数が1です. コンテナ内のDisplayObjectはShapeとして一つに統合されている可能性があります.");
               
            getAllChildren(container).forEach(
                function(img : DisplayObject, ...param):void
                {
                    img.alpha = 0;
                    img.visible = alsoVisible ? false : img.visible;
                });
        }

        /**
         * 任意の座標系におけるDisplayObjectのレンダリングされた矩形を返します.
         * DisplayObject.transform.pixelBoundsと似ていますが、DisplayObjectに適用されたマスクなどを考慮する点で異なります。<br/>
         * また、DisplayObject.transform.pixelBoundsが返す矩形はグローバル座標系での値ですが、このメソッドは任意の座標系を指定できます.<br/>
         * DisplayObjectが表示リスト内に存在するにもかかわらずレンダリングされてない場合はnullを返します<br/>
         * このメソッドを使用する際DisplayObjectは表示リスト内に存在している必要があります.<br/>
         * DisplayObjectが表示リスト内に存在しない場合はエラーを投げます.
         * 
         * @param content       対象となるDisplayObject
         * @param coordinate    矩形をどの座標系で表現するか<br/>座標系を省略した場合はDisplayObjectの親の座標系を使用します.
         */
        public static function getPixelBounce(target : DisplayObject, coordinate : DisplayObjectContainer = null) : Rectangle 
        {
            if (target && !target.parent)
               throw new Error("pixel bounceを取得するためには" + target + "は表示リスト内になければなりません.");
               
            coordinate = coordinate || target.parent;
                  
            //coordinate座標系のビットマップを作成
            var tBounce : Rectangle = target.getBounds(coordinate),
                m : Matrix = target.transform.matrix, 
                w : int, h : int,
                bitmap : BitmapData,
                p : DisplayObjectContainer = target.parent;
            
            //ターゲットのバウンスがマイナス位置にあると正しく描画できないのでオフセット値をもとめる
            w = tBounce.x < 0 ? -tBounce.x : 0;
            h = tBounce.y < 0 ? -tBounce.y : 0;
                
            bitmap = new BitmapData(tBounce.x + tBounce.width + w, tBounce.y + tBounce.height + h, true, 0);

            //coordinate座標系でのターゲットのマトリクス
            while(p != coordinate)
            {
                m.concat(p.transform.matrix);
                p = p.parent;
            }
            
            //targetのcoordinate座標系でのマトリクスをオフセット
            m.tx += w;
            m.ty += h;
            
            //描画
            bitmap.draw(target, m);
            
            //レンダリング部分をトリム
            var bounce : Rectangle = bitmap.getColorBoundsRect(0xFF000000, 0x00000000, false);
            
            //オフセット分を戻す
            bounce.x -= w;
            bounce.y -= h;
            
            return bounce;
        }

        /**
         * xmlからSpriteを生成し表示リストツリーを生成して返します.
         * XMLノード名がSprite名となります.
         * 以下の例では3階層を持つ表示リストツリーを生成しています.
         * 
         * var p:Sprite = 
               DisplayObjectUtil.createHierarchy(
                   &lt;{&quot;PARENT&quot;}&gt;
                       &lt;{&quot;CHILD1&quot;}&gt;
                           &lt;{&quot;GRAND_CHILD1&quot;}/&gt;
                           &lt;{&quot;GRAND_CHILD2&quot;}/&gt;
                       &lt;/{&quot;CHILD1&quot;}&gt;
                       &lt;{&quot;CHILD2&quot;}&gt;
                           &lt;{&quot;GRAND_CHILD3&quot;}/&gt;
                       &lt;/{&quot;CHILD2&quot;}&gt;
                   &lt;/{&quot;PARENT&quot;}&gt;
               );
         */
        public static function createHierarchy(xml : XML) : Sprite 
        {
            return (function(xml : XML):Sprite
            {
                var spr : Sprite = new Sprite();
                spr.name = xml.name();
                     
                if (xml.children().length() > 0)
                {
                    for each (var i : XML in xml.children()) 
                    {
                        spr.addChild(arguments.callee(i));
                    }
                }
                return spr;
            })(xml);
        }

        /**
         * 任意のコンテナから任意の名前をもつDisplayObjectを返します.
         * TODO テスト書く
         */
        public static function getChildByUniqueName(container : DisplayObjectContainer, name : String) : DisplayObject 
        {
            return (function(c:DisplayObjectContainer, name : String):DisplayObject
                    {
                        var child:DisplayObject = c.getChildByName(name); 
                        if (child)
                           return child;
                           
                        if (c is DisplayObjectContainer)
                            for (var i : int = 0; i < c.numChildren; i++) 
                            {
                                var child2:DisplayObjectContainer = c.getChildAt(i) as DisplayObjectContainer; 
                                if (child2)
                                {
                                    var c2:DisplayObject = arguments.callee(child2, name);
                                    if (c2)
                                       return c2;
                                }
                            }
                            
                        return null;
               
                    })(container, name);   
        }

        public static function addChildren(timeline : Sprite, children : Array) : Sprite
        {
            children.forEach(function(d:DisplayObject, ...param) : void
            {
            	timeline.addChild(d);
            });
            
            return timeline;
        }

        /**
         * 深い階層の子供を取得します
         * @param   子供の名前をドットでつないだテキスト
         *          e.g "child.decendant.hisDog"
         */
        public static function retrieve(container:DisplayObjectContainer, path : String) : DisplayObject
        {
            var a:Array = path.split("."),
                d:DisplayObject;
                
            a.forEach(function(s:String, ...param) : void
            {
                d = d || container;
                if (d is DisplayObjectContainer)
                    d = DisplayObjectContainer(d).getChildByName(s);
            });
            
            return d;
        }

        /**
         * 任意のコンテナの最深層にDisplayObjectを追加します.
         */
        public static function prependChild(container : DisplayObjectContainer, child : DisplayObject) : void
        {
            container.addChildAt(child, 0);
        }

        public static function fullScreen(target : DisplayObject, stage:Stage, onRevert:Function = null) : void
        {
            if (stage.displayState == StageDisplayState.NORMAL)
            {
                const   tp : Sprite = target.parent as Sprite,
                        tx : Number = target.x,
                        ty : Number = target.y,
                        tw : Number = target.width,
                        th : Number = target.height;

                DisplayObjectUtil.fitToRectangle(target, Capabilities.screenResolutionX, Capabilities.screenResolutionY, AspectRatio.KEEP_ASPECT_INSIDE_RECTANGLE);

                target.x = 0;
                target.y = 0;
                stage.addChild(target);
                stage.fullScreenSourceRect = new Rectangle(0, 0, target.width, target.height);
                stage.displayState = StageDisplayState.FULL_SCREEN;
                stage.addEventListener(FullScreenEvent.FULL_SCREEN, function() : void
                {
                    tp.addChild(target);
                    target.x = tx;
                    target.y = ty;
                    target.width = tw;
                    target.height = th;
                    if (onRevert != null) onRevert();
                    LiquidLayout.layout();
                    stage.removeEventListener(FullScreenEvent.FULL_SCREEN, arguments.callee);
                });
            }
        }
    }
}
