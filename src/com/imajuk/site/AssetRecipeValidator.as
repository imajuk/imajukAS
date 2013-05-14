package com.imajuk.site
{
    import com.imajuk.constructions.AppDomainRegistry;

    /**
     * @private
     * @author imajuk
     */
    public class AssetRecipeValidator
    {
        public static function validate(assetReceipt : XML) : void
        {
        	if (!assetReceipt)
        	   return;
        	   
        	_validate(assetReceipt.children());
        }

        private static function _validate(list : XMLList) : void
        {
        	//=================================
        	// レシピで定義されているクラスの参照テスト
        	//=================================
        	for each (var node : XML in list) {
                var className : String = node.name();
                try
                {
                    AppDomainRegistry.getInstance().getDefinition(Reference.decodeType(className)) as Class;
                }
                catch(e : Error)
                {
                    throw ApplicationError.create(ApplicationError.FAILED_LOOK_UP_APP_CLASS_IN_RECIPE, className, e.message);
                }

                if (node.children().length() > 0)
                {
                    _validate(node.children());
                    return;
                }
        	}
        }
    }
}
