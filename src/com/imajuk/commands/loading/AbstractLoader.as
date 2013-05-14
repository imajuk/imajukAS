package com.imajuk.commands.loading{    import com.imajuk.interfaces.IDisposable;    import com.imajuk.interfaces.IProgess;    import com.imajuk.testImajuk;    import flash.display.Loader;    import flash.display.LoaderInfo;    import flash.events.Event;    import flash.events.EventDispatcher;    import flash.events.IEventDispatcher;    import flash.media.Sound;    import flash.net.URLLoader;    import flash.net.URLLoaderDataFormat;    import flash.net.URLRequest;    import flash.system.LoaderContext;    import flash.utils.clearTimeout;    import flash.utils.setTimeout;		use namespace testImajuk;    /**     * <code>Loader</code>と<code>URLLoader</code>を透過的に扱うためのラッパー.     *      * <p>このクラスは<code>Loader</code>または<code>URLLoader</code>をラップします.<br/>     * AbstractLoaderのクライアントオブジェクトは、     * 扱う対象が<code>Loader</code>か<code>URLLoader</code>を意識しないで透過的にアクセスできます.</p>     * <p>AbstractLoader wraps <code>Loader</code> or <code>URLLoader</code>.<br/>     * The client object of AbstractLoader can transparently access      * without thinking that operated object is <code>Loader</code> or <code>URLLoader</code>.</p>     *      * @author yamaharu     */    public class AbstractLoader extends EventDispatcher implements IProgess, IDisposable
    {        private static var sid : int;        public static var loadingSimurationTime : Number = 0;
                private var _asBinary : Boolean;        private var id : Number;        //--------------------------------------------------------------------------        //        //  Constructor        //        //--------------------------------------------------------------------------        /**         * コンストラクタ.         *          * @param loaderClass	<code>Loader</code>または<code>URLLoader</code>クラスへの参照         * 						<p>reference of Class - <code>Loader</code> or <code>URLLoader</code> - that will be wrapped.</p>         */        public function AbstractLoader(loaderClass : Class, asBinary : Boolean) 		        {            id = sid++;            _asBinary = asBinary;                        if (_asBinary)                loaderClass = URLLoader;                        if (loaderClass === Loader || loaderClass === URLLoader || loaderClass === Sound)	            loader = new loaderClass();	        else	        	throw new Error("AbstractLoaderのコンストラクタに不正なローダが渡されました. " + loaderClass);                                            if (_asBinary)                URLLoader(loader).dataFormat = URLLoaderDataFormat.BINARY;                        }
        
        //--------------------------------------------------------------------------
        //
        //  implementation for IProgress
        //
        //--------------------------------------------------------------------------
        /**
         * @copy IProgess#total
         */
        public function get total():Number
        {
            var t:Number = dispatcher["bytesTotal"];
            return (isNaN(t)) ? 0 : t;
        }
        public function set total(value : Number) : void
        {
            throw new Error("totalの設定は許されていません");
        }
        /**
         * @copy IProgess#value
         */
        public function get value():Number
        {
            var b:Number = dispatcher["bytesLoaded"];
            return isNaN(b) ? 0 : b;        
        }
        public function set value(value : Number) : void
        {
            throw new Error("valueの設定は許されていません");
        }
        /**
         * @copy IProgess#percent
         */
        public function get percent():Number
        {
            var total:Number = total;
            return (total == 0) ? 0 : value / total;
        }
        //--------------------------------------------------------------------------        //        //  Variables        //        //--------------------------------------------------------------------------        /**         * @private         */        private var loader:*;                 /**         * @private         * for test         */        testImajuk var eventType:String;        /**         * @private         * whether loading completed or not.         */        private var _isCompleted:Boolean = false;        /**         * @private         * temporaly for resume();         */        private var _request:URLRequest;        /**
         * @private
         * temporaly for resume();         */
        private var _context : LoaderContext;        //--------------------------------------------------------------------------        //        //  properties        //        //--------------------------------------------------------------------------                /**         * このローダーの<code>EventDispatcher</code>を返します.         *          * <p>returns dispatcher of this loader.</p>         */        public function get dispatcher():IEventDispatcher        {            return (loader is Loader) ? Loader(loader).contentLoaderInfo : loader;        }        public function set dispatcher(value : IEventDispatcher) : void
        {
        }        /**         * @copy LoadCommand#content         */        public function get content():*        {            var c:* ;            if (_asBinary)            {                c = URLLoader(loader).data;            }            else if (loader is Loader)            {                 c = Loader(loader).content;            }
            else if (loader is Sound)
            {
                c = loader;	            }
			else            {                var data:String = URLLoader(loader).data;                 if (data == null)                {                    c = null;	                }                else                {                	data = data as String;                	if (data)                	{                		if (data.indexOf("<?xml") > -1)                		  c = XML(data);                		else                		  c = data;                 	}                	else                	{                		throw new Error("URLLoaderでロードした不明なデータ");                	}                }            }            return c;        }        /**         * @copy LoadCommand#loaderInfo         */        public function get loaderInfo():LoaderInfo        {            return (loader is Loader) ? Loader(loader).contentLoaderInfo : null;        }        /**         * @copy ILoadComponent#waitInitialize         */        private var _waitInitialize:Boolean = false;        public function get waitInitialize():Boolean        {            return _waitInitialize;        }        public function set waitInitialize(value:Boolean):void        {            _waitInitialize = value;            startListeningCompletion();        }                public function dispose() : void        {        	if (loader is Loader)            	Loader(loader).unload();        }        //--------------------------------------------------------------------------        //        //  Overridden methods        //        //--------------------------------------------------------------------------        override public function toString():String        {            return "AbstractLoader[" + id + "(" + ((_request) ? _request.url : "null") + ")]";        }        //--------------------------------------------------------------------------        //        //  Methods: control loader        //        //--------------------------------------------------------------------------                /**         * ロードを開始します.         *          * <p>start loading.</p>         */        public function load(request:URLRequest, context:LoaderContext):Boolean        {            startListeningCompletion();                        _request = request;            _context = context;
                                if (loader is Loader)            	loader["load"](request, context);            else            	loader["load"](request);                        return true;        }        /**         * ロードを一時停止します.         *          * <p>pauses loading.</p>         */        public function pause():Boolean        {            //AbstractLoaderの実装レベルでは、pause()とstop()は等価            return stop();        }        /**         * ロードを終了します.         *          * <p>stops loading.</p>         */        public function stop():Boolean        {            if(_isCompleted)                return false;                        stopListenningCompletion();                        //ストリームが開いてない可能性があるため、エラーをキャッチ            try            {                loader["close"]();            }            catch(e:Error)            {            	            }                        return true;        }        /**         * 一時停止したロードを再開します.         *          * <p>resumes loading.</p>         */        public function resume():Boolean        {            if(_isCompleted)                return false;            return load(_request, _context);        }        //--------------------------------------------------------------------------        //        //  Methods: listening event.        //        //--------------------------------------------------------------------------                /**         * @private         * start to listen for catching a event of completion.         */        private function startListeningCompletion():void        {            stopListenningCompletion();                        var type:String = (_waitInitialize && loader is Loader) ? Event.INIT : Event.COMPLETE;             dispatcher.addEventListener(type, completionHandler);        }        /**         * @private         * stop to listen for catching a event of completion.         */        private function stopListenningCompletion():void        {            dispatcher.removeEventListener(Event.COMPLETE, completionHandler);            dispatcher.removeEventListener(Event.INIT, completionHandler);        }        //--------------------------------------------------------------------------        //        //  Event Handler        //        //--------------------------------------------------------------------------        /**         * @private         */        public function  completionHandler(event:Event):void        {            var intvl:uint;
            var f : Function = function() : void
            {                stopListenningCompletion();                if(_asBinary)                {                    var binLoader:Loader = new Loader();                    binLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void                    {                        binLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);                        _isCompleted = true;                        testImajuk::eventType = event.type;                                                dispatchEvent(event);                                                clearTimeout(intvl);                    });                    binLoader.loadBytes(event.target.data);                }                else                {                    _isCompleted = true;                    testImajuk::eventType = event.type;                                        dispatchEvent(event);
                    
                    clearTimeout(intvl);                }                
            };            
        	if (loadingSimurationTime > 0)
                intvl = setTimeout(f, loadingSimurationTime * 1000);
            else
                f();        }    }
}
