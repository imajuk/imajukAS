package com.imajuk.site 
{
    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;

    /**
     * レシピで定義されるクラスを指定するためのクラスです.
     * <p>
     * 以下のようにXMLノード名に<code>Reference</code>オブジェクトを使用する事によって、
     * アプリケーションが自動生成するビューやステートを指定できます.
     * </p>
     * <p>
     * また、<code>Reference.NOTHING</code>定数はアセットのインジェクトが必要ない場合に使用します.
     * </p>
     * <listing version="3.0">
     * &lt;{Recipe.ASSET}&gt;
     * 
     *     &lt;!-- load assets/yourAsset1.swf, and then inject it to YourView --&gt;
     *     &lt;{new Reference(YourView)}  src=&quot;assets/yourAsset1.swf&quot;  /&gt;
     *     
     *     &lt;!-- load assets/yourAsset2.swf, it's never injected --&gt;
     *     &lt;{Reference.NOTHING}        src=&quot;assets/yourAsset2.swf&quot;  /&gt;
     *     
     * &lt;/{Recipe.ASSET}&gt;
     * </listing>
     * 
     * @see Application#start()
     * 
     * @author imajuk
     */
    public class Reference 
    {
        internal static var mainAppDomain : ApplicationDomain;
    	/**
    	 * アセットレシピ内でアセットのインジェクトが必要ない場合はXMLノード名にこの定数を使用します.
    	 */
        public static const INBOX : Reference = new Reference(Inbox);
        private static const REPLACE : String = "__";
        private static const PACKAGE_SEPARATER : String = "::";
        private var _encode : String;
        private var _decode : String;

        /**
         * コンストラクタ
         * @param klass     この<code>Reference</code>オブジェクトが参照するクラス
         * @param urlName   ディープリンクを使用する場合のページ名.
         *                  このオプションはステートレシピでのみ有効です.
         */
        public function Reference(klass : Class = null) 
        {
            _encode = (klass) ? encodeType(getQualifiedClassName(klass)) : "null";
            _decode = decodeType(_encode);
        }

        /**
         * @private
         */
        final public function toString() : String 
        {
            return _encode;
        }

        /**
         * レシピのノード名<code>package__ClassName</code>をクラスの文字列表現<code>package::ClassName</code>に変換します
         */
        public static function decodeType(stateType : String) : String 
        {
            return stateType.split(REPLACE).join(PACKAGE_SEPARATER);
        }

        /**
         * クラスの文字列表現 package::ClassName を package__ClassName の形式に変換します
         */
        private static function encodeType(className : String) : String 
        {
            return className.split(PACKAGE_SEPARATER).join(REPLACE);
        }

        /**
         * @private
         * この<code>Reference</code>オブジェクトが参照するクラス名を返す
         */
        internal function decode() : String 
        {
            return _decode;
        }
        
        /**
         * @private
         * この<code>Reference</code>オブジェクトが参照するクラス名の変換文字列を返す
         */
        internal function encode() : String
        {
        	return _encode;
        }
        
        /**
         * @private
         * 等価チェック
         */
        internal function equals(ref : Reference) : Boolean
        {
            return encode() == (ref ? ref.encode() : "null");
        }

        /**
         * @private
         * ファクトリメソッド
         * @param decoded   クラス名
         */
        internal static function fromStrings(decoded : String) : Reference
        {
            return new Reference(mainAppDomain.getDefinition(decoded) as Class);
        }
    }
}
