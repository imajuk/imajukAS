package com.imajuk.constructions 
{
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.PixelSnapping;
    import flash.media.Sound;
    import flash.text.Font;
    import flash.utils.getQualifiedSuperclassName;
    import flash.utils.getTimer;
	
    /**
     * @author shin.yamaharu
     */
    public class AssetFactory 
    {
    	public static function create(classIdentify:String):DisplayObject
        {
       		var c:Class = AppDomainRegistry.getInstance().getDefinition(classIdentify);            var instance:DisplayObject;
            
            if (getQualifiedSuperclassName(c) == "flash.display::BitmapData")
                instance = new Bitmap(new c(0,0), PixelSnapping.AUTO, true);
            else if (getQualifiedSuperclassName(c) == "flash.media::Sound")
                throw new Error("Soundインスタンスを生成するにはAssetFactory.createSound()を使用してください.");
            else
                instance = new c();
                
            instance.name = classIdentify + "_" + getTimer();
            
            return instance;
        }

        public static function isResisterd(classIdentify : String) : Boolean 
        {
        	try
        	{        		var c:Class = AppDomainRegistry.getInstance().getDefinition(classIdentify);        	}
        	catch(e:Error)
        	{
        		return false;
        	}
        	
            return c != null;
        }
        
        public static function createBitmapData(classIdentify : String) : BitmapData
        {
            var c : Class = AppDomainRegistry.getInstance().getDefinition(classIdentify);
            var instance : BitmapData;
            
            if (getQualifiedSuperclassName(c) != "flash.display::BitmapData")
                throw new Error(classIdentify + "はBitmapDataクラスではありません" + getQualifiedSuperclassName(c) + "です.");

            instance = new c(0,0);
            return instance;
        }

        public static function createSound(classIdentify : String) : Sound         {
        	var c:Class = AppDomainRegistry.getInstance().getDefinition(classIdentify);
            var instance:Sound;
            if (getQualifiedSuperclassName(c) != "flash.media::Sound")
                throw new Error(classIdentify + "はSoundクラスではありません" + getQualifiedSuperclassName(c) + "です.");
                
            instance = new c();
            return instance;
        }
        
        public static function createXML(classIdentify : String) : XML 
        {
            var c:Class = AppDomainRegistry.getInstance().getDefinition(classIdentify);
            var instance:XML;
            if (getQualifiedSuperclassName(c) != "mx.core::ByteArrayAsset")
                throw new Error(classIdentify + "はXMLクラスではありません" + getQualifiedSuperclassName(c) + "です.");
                
            instance = XML(new c());
            return instance;
        }

        public static function registerFont(identify : String) : void
        {
        	Font.registerFont(AppDomainRegistry.getInstance().getDefinition(identify));
        }
    }
}
