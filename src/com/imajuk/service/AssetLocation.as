package com.imajuk.service 
{
    import flash.system.ApplicationDomain;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.utils.Dictionary;

    /**
     * 複数のURIをコンポジットします.
     * また、URIをキーとして任意のsetterと紐づけられます.
     * @author yamaharu
     */
    public class AssetLocation implements IAssetLocation
    {
        private var _registers:Dictionary = new Dictionary(true);
        private var _contexts:Dictionary = new Dictionary(true);
        private var _bins:Dictionary = new Dictionary(true);
        private var _location:Array = [];

        public function add(key:URLRequest, register:Function, context:LoaderContext = null, asBinary:Boolean = false):IAssetLocation
        {
        	var keyURI:String = key.url; 
            if(_registers[keyURI])
                throw new Error(keyURI + "に複数のクロージャを登録しようとしています.(重複したアセットはロードできません.)");
            
            _registers[keyURI] = register;
            _contexts[keyURI] = context || new LoaderContext(true, ApplicationDomain.currentDomain);
            _bins[keyURI] = asBinary;
            _location.push(key);

            return this;
        }

        public function get locations():Array
        {
            return _location;
        }

        /**
         * ロードしたデータをsetterに渡す
         */
        public function regist(uriStr:String, data:*):void
        {
            var register:Function = _registers[uriStr] as Function;
            
            if (register == null)
                throw new Error(
                    "add()されてない識別子[" + 
                    uriStr + 
                    "]に対してデータをバインドしようとしています.");
            else
                register(data);
        }

        public static function getXMLRegistryProxy():Function
        {
            var xml:XML;
            return function(v:XML = null):XML
            {
                if (v == null)
                    return xml;
                else
                    return xml = v;
            };
        }

        public function getContext(url : String) : LoaderContext
        {
            return _contexts[url];
        }

        public function binaryLoading(url : String) : Boolean
        {
            return Boolean(_bins[url]);
        }
    }
}
