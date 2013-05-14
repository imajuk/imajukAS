package com.imajuk.utils
{
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;

    /**
     * <code>Dictionary</code>に関するユーティリティ.
     * 
     * @author yamaharu  (design, program)     * @author takahashi (ducument)
     */
    public class DictionaryUtil 
    {

        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------

        /**
         * 渡された<code>Dictionary</code>インスタンスが持っている要素の数をカウントします.
         * 
         * <p>値が<code>null</code>である要素はカウントされません.</p>
         * 
         * @example	以下のような3つの要素のうち1つの要素が<code>null</code>である<code>Dictionary</code>インスタンスを渡すと結果は2になります.
         * <listing version="3.0">
         * var dictionary:Dictionary = new Dictionary();
         * dictionary[0] = "0";         * dictionary[1] = "1";         * dictionary[2] = null;
         * trace(DictionaryUtil.count(dictionary)); //output : 2
         * </listing>
         * 
         * @param dictionary	要素数をカウントしたい<code>Dictionary</code>インスタンス
         * @return 				<code>Dictionary</code>インスタンスが持つの要素数
         */
        public static function count(dictionary:Dictionary, ignoreNullElements:Boolean = true):int
        {
            var cnt:int = 0;
            for (var p:* in dictionary) 
            {
                if (!ignoreNullElements || dictionary[p] != null) 
                    cnt++;
            }
            return cnt;
        }        

        
        /**
         * 渡された<code>Dictionary</code>インスタンスの要素に任意のオブジェクトが含まれているか調べます.
         * 
         * @param dictionary	調査対象となる<code>Dictionary</code>ンスタンス
         * @param value			<code>Dictionary</code>インスタンスに含まれているかどうか調べたい任意のオブジェクト
         * @return				<code>Dictionary</code>インスタンスに、渡された任意のオブジェクトが含まれるかどうか
         */
        public static function containes(dictionary:Dictionary, value:*):Boolean
        {
            for each (var p:* in dictionary) 
            {
                if (p == value)
                    return true;
            }
            return false;
        }
        
        public static function containesKey(dictionary : Dictionary, key : String) : Boolean
        {
            return dictionary[key] != undefined;
        }

        /**
         * 渡された<code>Dictionary</code>インスタンスの要素からランダムに一つ返します.
         * ただしnullの要素は対象となりません.
         */
        public static function random(dictionary:Dictionary, returnKey:Boolean = false):*
        {
            var d:Dictionary = normalize(dictionary);
            var idx:uint = Math.floor(Math.random() * count(d));
            var a:Array = [];
            for (var key:* in d) 
            {
            	if (returnKey)
            	   a.push(key);
            	else 
                   a.push(d[key]);
            }
           
            return a[idx];
        }

         /**
         * 渡された<code>Dictionary</code>インスタンスの要素からnullの要素をのぞいた
         * 新しい<code>Dictionary</code>インスタンスを返します.
         */
        public static function normalize(dictionary:Dictionary):Dictionary
        {
            var d:Dictionary = new Dictionary(true);
            var e:*;
            for (var key:* in dictionary) 
            {
                e = dictionary[key]; 
                if (e != null)
                    d[key] = e;
            }
            return d;
        }

        public static function createInvertDictionary(dic : Dictionary, weakKeys : Boolean = true) : Dictionary
        {
            var invert : Dictionary = new Dictionary(weakKeys);
            for (var key : * in dic)
            {
                invert[dic[key]] = key;
            }
            return invert;
        }

        public static function dump(states : Dictionary) : void
        {
            trace("/***********************************");
            for (var i : * in states)
                trace(" * key:" + (i is DisplayObject ? i.name : i) + " -> " + states[i]);
            trace(" ***********************************/");
        }
    }
}