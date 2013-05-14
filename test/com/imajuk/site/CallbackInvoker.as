package com.imajuk.site
{
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    /**
     * @author shin.yamaharu
     */
    internal class CallbackInvoker
    {
        private static var _callBack : Object = {};

        public static function exec(o : *) : void
        {
        	var ref:Reference = new Reference(getDefinitionByName(getQualifiedClassName(o)) as Class);
        	
        	if (_callBack[ref.encode()] != null)
                _callBack[ref.encode()]();
        }

        public static function setCallback(ref : Reference, f : Function) : void
        {
            _callBack[ref.encode()] = function() : void
            {
            	clear();
            	f();
            };
        }

        public static function clear() : void
        {
        	_callBack = {};
        }
    }
}
