package com.imajuk.service 
{
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    
    /**
     * @author yamaharu
     */
    public interface IAssetLocation
    {
    	/**
    	 * 登録されているURIを返します.
    	 */
        function get locations():Array;
        /**
         * URIを識別子として、クロージャを紐づける.
         * このクロージャはロード済みのデータを引数に、内包しているメソッドを呼び出す.
         */
        function add(request:URLRequest, callback:Function, context:LoaderContext = null, asBinary:Boolean = false):IAssetLocation;
        /**
         * URIを識別子として、ロード済みのデータを紐づける
         */
        function regist(keyURI : String, data : *) : void;

        function getContext(url : String) : LoaderContext;

        function binaryLoading(url : String) : Boolean;
    }
}
