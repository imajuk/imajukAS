package com.imajuk.site
{
    import com.imajuk.utils.DisplayObjectUtil;

    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    
    /**
     * アプリケーションのコンテナに配置されレイヤーを定義します.
     * <p>
     * Applicationのコンストラクタに渡されたコンテナに4つのレイヤーが生成されます.<br/>
     * 4つのレイヤーの名前は奥から手前に向かって</br>
     * <ul>
     * <li><code>ApplictionLayer.BACKGROUND</code></li>
     * <li><code>ApplictionLayer.CONTENT</code></li>
     * <li><code>ApplictionLayer.CONTENT_OVERLAY</code></li>
     * <li><code>ApplictionLayer.APPLICATION_OVERLAY</code></li>
     * </ul>
     * によって定義されています.
     * </p>
     * <p>
     * 各レイヤーには便宜上名前がついていますが、どのレイヤーに何を配置するかは特に規定はありません.<br/>
     * レイヤーにビューを配置するにはステートの<code>addTemporaryView()</code>または<code>addParmanentView()</code>メソッドを使用します.
     * </p>
     * 
     * @see StateThread#addTemporaryView
     * @see StateThread#addParmanentView
     * 
     * @author imajuk
     */
    public class ApplicationLayer
    {
        public static const BACKGROUND          : String = "BACKGROUND";
        public static const CONTENT             : String = "CONTENT";
        public static const CONTENT_OVERLAY     : String = "CONTENT_OVERLAY";
        public static const APPLICATION_OVERLAY : String = "APPLICATION_OVERLAY";
        
        private static var application : Application;
        private static var layers : Dictionary = new Dictionary();

        /**
         * @private
         */
        internal static function initialize(application : Application) : void
        {
            ApplicationLayer.application = application;
            
            //=================================
            // layers
            //=================================
            ApplicationLayer.add(ApplicationLayer.BACKGROUND);
            ApplicationLayer.add(ApplicationLayer.CONTENT);
            ApplicationLayer.add(ApplicationLayer.CONTENT_OVERLAY);
            ApplicationLayer.add(ApplicationLayer.APPLICATION_OVERLAY);
        }

        /**
         * レイヤーを取得します
         * @param layerName レイヤー名. レイヤー名はApplicationLayerの定数で定義されています.
         */
        public static function getLayer(layerName : String) : Sprite
        {
        	if (!ApplicationLayer.application)
        	   throw ApplicationError.create(ApplicationError.CANT_UESE_WITHOUT_APP_INSTANCE, getQualifiedClassName(ApplicationLayer));
        	
            var layer : Sprite = layers[layerName] as Sprite;
            if (!layer)
        	   throw ApplicationError.create(ApplicationError.INVALID_LAYER_NAME, layerName);
                
            return layer;
        }

        /**
         * @private
         */
        internal static function reset() : void
        {
        	if (!application)
        	   return;
        	   
        	DisplayObjectUtil.removeAllChildren(application.mainContainer);
            layers = new Dictionary();
            application = null;
        }
        
        private static function add(name : String) : void
        {
            var layer:Sprite = application.mainContainer.addChild(new Sprite()) as Sprite;
            layer.name = "layer_" + name;
            layer.mouseEnabled = false;
            layers[name] = layer;
        }
    }
}
