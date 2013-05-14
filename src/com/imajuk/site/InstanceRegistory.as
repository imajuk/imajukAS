package com.imajuk.site
{

    /**
     * @private
     * @author shinyamaharu
     */
    public class InstanceRegistory 
    {
        //--------------------------------------------------------------------------
        //
        //  Class properties
        //
        //--------------------------------------------------------------------------
        private static var _instance : InstanceRegistory;
        //for hold View instances
        private var registory : Object = {};
        //for refer receipt with view        private var viewToReceipt : Object = {};

        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------
        public static function getInstance():InstanceRegistory
        {
            if (!_instance)
                _instance = new InstanceRegistory(new PrivateClass());
            return _instance;
        }

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        public function InstanceRegistory(privateClass:PrivateClass)
        {
        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        /**
         * シングルトンを破棄する（テスト用）
         */
        internal static function reset() : void
        {
        	_instance = null;
        }
        
        internal function registerReceipt(receipt : XML) : void        {
        	if(!receipt)
        	   return;
        	   
        	for each (var xml : XML in receipt.elements()) 
            	viewToReceipt[xml.name()] = xml;
        }
        
        internal function getReceipt(prop : String) : XML
        {
            var recipe : XML = viewToReceipt[prop] as XML;
            if (!recipe)
            {
                var failed : Reference;
                try
                {
                    prop = Reference.decodeType(prop);
                    failed = Reference.fromStrings(prop);
                }
                catch(e : Error)
                {
                }
                finally
                {
                    throw ApplicationError.create(ApplicationError.TRIED_TO_REFER_UNREGISTED_VIEW, prop);
                }
            }
            return recipe;
        }

        internal function register(prop:String, value:*):void
        {
            registory[prop] = value;
        }
        
        internal function getAsset(ref:Reference):*
        {        	var prop:String = ref.toString();
        	if (!registory[prop])
        	   throw ApplicationError.create(ApplicationError.UNRESOLVABLE_ASSET, ref, prop);
        	    
        	return registory[prop];
        }
    }
}


class PrivateClass
{
}