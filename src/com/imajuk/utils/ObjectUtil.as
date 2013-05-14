package com.imajuk.utils
{
    import flash.utils.*;
	﻿

    /**
     * <code>Object</code>に関するユーティリティ
     * 
     * @author yamaharu
     */
    public class ObjectUtil
    {
        //--------------------------------------------------------------------------
        //
        //  Class properties
        //
        //--------------------------------------------------------------------------

        private static const INDENT:String = " ";
        private static const LINE:String = "-";

        
        //--------------------------------------------------------------------------
        //
        //  Class methods : commands
        //
        //--------------------------------------------------------------------------
        /**
         * 渡されたオブジェクトを複製して返します.
         * 
         * <p>このメソッドはオブジェクトをディープコピーします.</p>
         * <p>オブジェクトの要素が参照だった場合、参照先のオブジェクトもコピーします.</p>
         * 
         * @param src   複製したいオブジェクト.
         * @return      複製されたオブジェクト.
         * @example
         * <listing version="3.0">
         * var object:Object = {innerObject:{id:1}};
         * var copyObject:Object = ObjectUtil.clone(object);
         * object.innerObject.id = 2;
         * </listing>
         * の場合、参照先もコピーされるため、
         * <listing version="3.0">
         * trace(object.innerObject.id);    //output 2
         * trace(copyObject.id);            //output 1
         * </listing>
         * となります。
         */
        public static function clone(src:*):*
        {
            var a:ByteArray = new ByteArray();
            a.writeObject(src);
            a.position = 0;
            return(a.readObject());
        }

        
        
        
        
        /**
         * オブジェクトの内容をダンプします.
         * 
         * @param object	任意のオブジェクト
         * @param ignoredProp   特定のプロパティを表示したくない場合はプロパティ名を指定
         * 
         * @example
         * <listing version="3.0">
         * var o:Object = {
         *					str:"ID",
         *					ary:[
         *							0,
         *							["a","b","c"],
         *							{aryObj1:true,aryObj2:false}
         *						],
         *					obj:{
         *							hoge:true,
         *							foo:["f","o","o"],
         *							fuga:new Date()
         *						}
         *				};
         * ObjectUtil.dump(o);
         * </listing>
         * 上記のように呼び出した場合、以下を出力します。
         * <listing version="3.0">
         * [obj (Object)]
         *     [hoge (Boolean) -> true]
         *     [fuga (Date) -> Wed Jul 25 18:26:00 GMT+0900 2007]
         *     [foo (Array)]
         *         [0 (String) -> f]
         *         [1 (String) -> o]
         *         [2 (String) -> o]
         * [str (String) -> ID]
         * [ary (Array)]
         *     [0 (int) -> 0]
         *     [1 (Array)]
         *         [0 (String) -> a]
         *         [1 (String) -> b]
         *         [2 (String) -> c]
         *     [2 (Object)]
         *         [aryObj2 (Boolean) -> false]
         *         [aryObj1 (Boolean) -> true]
         * </listing>
         */
        public static function dump(object:*, ...ignoredProp:Array):void
        {
            var indent:Number = 0;
            if (!inner)
            {
                result = new Array();
                children = new Array();
                initDump();
            }
            
            for (var prop:* in object)
            {
                if (ignoredProp.some(function(ig : String, ...param) : Boolean
                {
                    return ig === prop;
                })) continue;
                
                var v:* = object[prop];
                var t:String = getQualifiedClassName(v);
                var hasChild:Boolean = (t == "Object") || (t == "Array");
                var res:String = getIndent() + "[" + prop + " (" + t + ")" + ((hasChild) ? "]" : " -> " + v + "]");
                result.push(res);
                
                if (hasChild)
                {
                    inner = true;
                    indent = Math.max(indent, res.length - indent);
                    children.push(indent);
                    dump(v);
                }
            }

            if (!inner && children.length == 0)
                printResult();
            initDump();
        }

        //--------------------------------------------------------------------------
        //
        //  Class methods : private
        //
        //--------------------------------------------------------------------------

        private static function initDump():void
        {
            children.pop();
            inner = false;
        }

        private static function getIndent():String
        {
            var l:Number = children.length;
            var amount:Number = (children.length == 0) ? 0 : children[l - 1];
            return getLayoutElements(" * ", amount, INDENT);
        }

        
        private static function getDash(l:Number):String
        {
            return getLayoutElements("", l, LINE);
        }

        
        private static function getLayoutElements(pre:String, l:Number, element:String):String
        {
            var s:String = pre;
            for (var i:Number = 0;i < l; i++)
            {
                s += element;
            }
            return s;
        }

        
        private static function getMaxPrintLength():Number
        {
            var l:Number = 0;
            for (var i:Number = 0;i < result.length; i++)
            {
                l = Math.max(l, result[i].length);
            }
            return l;
        }

        
        private static function printResult():void
        {
            var l:Number = getMaxPrintLength();
            trace("/*" + getDash(l));
            for (var i:Number = 0;i < result.length; i++)
            {
                trace(result[i]);
            }
            trace(" " + getDash(l) + "*/");
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  parameters
        //----------------------------------
        /**
         * @private
         */
        private static var inner:Boolean;
        /**
         * @private
         */
        private static var result:Array;
        /**
         * @private
         */
        private static var children:Array;

        public static function length(target:Object):uint
        {
            var l:uint = 0;
            for (var i : String in target) 
            {
            	i;
                l++;
            }
            return l;
        }
    }
}