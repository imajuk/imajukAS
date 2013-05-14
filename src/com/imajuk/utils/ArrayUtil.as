package com.imajuk.utils 
{
    import flash.geom.Point;

    /**
     * @author yamaharu
     */
    public class ArrayUtil 
    {
        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------
	    
        /**
         * 渡された配列の要素をシャッフルします.
         * 
         * <p>このメソッドは、渡された配列を変更する事に注意して下さい.</p>
         * 
         * @param array シャッフルしたい配列を渡します.
         */
        public static function shuffle(array:Array):void
        {
            var n:int = array.length;
            for (var i:int;i < n; i++)
            {
                var r:int = int(Math.random() * (n - i));
                array.push(array.splice(r, 1)[0]);
            }
        }

        /**
         * 渡された配列を複製して返します.
         * 
         * <p>このメソッドは配列をディープコピーします.</p>
         * <p>配列の要素が参照だった場合、参照先のオブジェクトもコピーします.</p>
         * 
         * @param src   複製したいオブジェクト.
         * @return      複製されたオブジェクト.
         * @example
         * <listing version="3.0">
         * var srcArray:Array = [{{id:1}];
         * var copyArray:Array = ArrayUtil.clone(srcArray);
         * srcArray[0].id = 2;
         * </listing>
         * の場合、参照先もコピーされるため、
         * <listing version="3.0">
         * trace(srcArray[0].id);    //output 2
         * trace(copyArray[0].id);   //output 1
         * </listing>
         * となります。
         */
        public static function clone(src:Array):Array
        {
            return ObjectUtil.clone(src);
        }

        /**
         * 渡された配列の任意の二つの要素を入れ替えます.
         * 
         * <p>このメソッドは、渡された配列を変更する事に注意して下さい.</p>
         * 
         * @param array 要素を入れ替えたい配列
         * @param element1 入れ替えたい要素1のインデックス
         * @param element2 入れ替えたい要素2のインデックス
         */
        public static function swap(array:Array, index1:int, index2:int):void
        {
            var tempElement:* = array[index1];
            array[index1] = array[index2];
            array[index2] = tempElement;
        }

        /**
         * 渡された配列の任意の２つの要素が、型および順番も含めて全て一致しているか調べます.
         * 
         * <p>このメソッドは、要素がさらに要素を持つ場合、再帰的に子要素の等価性をチェックする事はしません.<br/>
         * また、等価性のチェックはチェック対象となるオブジェクトの<code>equals()</code>メソッドの実装に依存する事に注意して下さい.</p>
         * 
         * @param array1    比較する配列1
         * @param array2    比較する配列2
         * @return 要素が型および順番も含めて全て一致した場合、trueを返します.
         */
        public static function equals(array1:Array, array2:Array):Boolean
        {
            if (array1.length != array2.length)
                return false;
                
            var n:int = array1.length;
            for (var i:int = 0;i < n; i++)
            {
                if (array1[i] !== array2[i])
                    return false;
            }
            return true;
        }

        /**
         * 渡された配列の最後の要素を返します.
         * 
         * @param array	最後の要素を取得したい配列
         * @return		配列の最後の要素
         */
        public static function last(array:Array):*
        {
            if (!array || array.length == 0)
                return null;
                
            if (array.length == 1)
                return array[0];
            else
                return array[array.length - 1];
        }

        /**
         * 渡された配列の最初の要素を返します.
         * 
         * @param array 最初の要素を取得したい配列
         * @return      配列の最初の要素
         */
        public static function first(array:Array):*        {
            return array[0];        }

        /**
         * 渡された配列からn個の重複しない要素をランダムに選択し、配列として返します.
         * 
         * @param array 要素をランダムに取得したい配列
         * @return array n個のランダムに取得した要素を含む配列.
         *               省略した場合は1つの要素をランダムに取得し配列として返します.
         */
        public static function selectRandom(array:Array, amount:int = 1):Array
        {
            if (array.length < amount)
                throw new Error("ランダムに選択したい要素数が配列の長さを超えています.このメソッドは要素の重複を許可しません.");
                
            var a:Array = array.concat();
            var result:Array = [];
            var idx:int;
            var b:*;
            for (var i:Number = 0;i < amount; i++)
            {
                idx = Math.floor(Math.random() * a.length);
                b = a.splice(idx, 1);                result.push(b[0]);
            }
            return result;
        }
        
        /**
         * 副作用のあるselectRandom
         */
        public static function splitRandom(array:Array, amount:int = 1):Array
        {
            if (array.length < amount)
                throw new Error("ランダムに選択したい要素数が配列の長さを超えています.このメソッドは要素の重複を許可しません.");
                
            if (amount == array.length)
                return array.splice(0, array.length);
                
            var a:Array = array;
            var result:Array = [];
            var idx:int;
            var b:*;
            for (var i:Number = 0;i < amount; i++)
            {
                idx = Math.floor(Math.random() * a.length);
                b = a.splice(idx, 1);
                result.push(b[0]);
            }
            return result;
        }

        /**
         * 配列を渡された要素で埋めて返します.
         * 
         * @param array     ある要素で埋めたい配列
         * @param content   配列を埋める要素
         * @return          任意の要素で埋まった配列
         */
        public static function fill(array:Array, content:* = null):Array
        {
            return array.map(function(...param):Point
            {
                return content;
            });
            ;
        }

        /**
         * 配列に渡された要素が存在するかどうかを返します.
         * 
         * @param array     ある要素が含まれているかどうか調べたい配列
         * @param element   含まれているかどうか調べたい要素
         * @param useCast   暗黙の型変換をして比較するかどうか.
         * @return          配列に渡された要素が存在するか
         */
        public static function contains(array:Array, element:*, useCast:Boolean = false):Boolean
        {
            return array.some(function(e:*, ...param):Boolean
            {
                if (useCast)
                    return e == element;                else
                    return e === element;
            });
        }
        
        public static function selectRandomOne(array:Array):*
        {
            return selectRandom(array)[0];
        }
        
        /**
         * 配列a1の要素から配列a2の要素を引いた残りの要素を配列で返します.
         * このメソッドは、引数で与えられた配列に対しての副作用はありません. 
         * 
         */
        public static function substract(a1:Array, a2:Array):Array
        {
            return a1.filter(function(b:*, ...param):Boolean
            {
                return !a2.some(function(b2:*, ...param):Boolean
                {
                    return b == b2;
                });
            });;
        }
        
        /**
         * 渡された配列から任意のアイテムを取り除いた配列を返します.
         * このメソッドは、引数で与えられた配列に対しての副作用はありません. 
         */
        public static function remove(a:Array, item:*):Array
        {
        	return a.filter(function(i:*, ...param):Boolean
        	{
        	   return i != item;	
        	});
        }

        public static function getNextOne(array : Array, element : *, loop:Boolean = false) : *
        {
            var idx : int = -1;
            for (var i : int = 0; i < array.length; i++)
            {
                if (array[i] === element)
                {
                    idx = i;
                    break;
                }
            }
            
            if (idx == -1)
                return null;
            else if ( idx >= array.length -1)
                return (loop) ? array[0] : null; 
            else
                return array[i+1];    
        }

        public static function previousOne(array : Array, element : *,  loop:Boolean = false) : *
        {
            var idx : int = -1;
            for (var i : int = 0; i < array.length; i++)
            {
                if (array[i] === element)
                {
                    idx = i;
                    break;
                }
            }
            
            if (idx == -1)
                return null;
            else if(idx == 0)
                return (loop) ? array[array.length-1] : null;
            else
                return array[i-1];    
        }

        /**
         * 配列の要素の合計を求めます
         * @param array 対象となる配列です
         * @param prop  合計対象となる要素のプロパティです.省略された場合要素そのものが合計対象とります
         *              TODO:省略時未実装
         */
        public static function sum(array : Array, prop : String) : *
        {
        	var result:*;
            array.forEach(function(o : Object, ...param) : void
            {
                if (result == undefined)
                {
                if (o[prop] is Number) 
                    result = 0;
                else if (o[prop] is String)
                    result = "";
                else
                    throw new Error("+オペレータが使用できないタイプです." + typeof o[prop]);
                }
                
                result += o[prop];
            });
            return result;
        }

        /**
         * 配列の要素から最大のものを返します
         * 比較対象のタイプが数値であれば数値の大小を比較します。         * 比較対象のタイプが文字列であれば文字列の長さを比較します。TODO:未実装
         * 
         * @param array 対象となる配列です
         * @param prop  比較対象となる要素のプロパティです.省略された場合要素そのものが比較対象とります
         *              TODO:省略時未実装
         */
        public static function max(array : Array, prop : String) : *
        {
            var result:*;
            array.forEach(function(o:Object, ...param) : void
            {
            	var n:* = o[prop];
                result = result > n ? result : n;
            });
            return result;
        }

        /**
         * 配列の要素であるオブジェクトのプロパティを設定します
         */
        public static function setProperty(array : Array, prop : String, value : *) : void
        {
            array.forEach(function(o:Object, ...param) : void
            {
            	o[prop] = value;
            });
        }
    }
}
