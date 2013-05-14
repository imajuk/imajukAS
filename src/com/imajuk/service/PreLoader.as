package com.imajuk.service 
{
    import com.imajuk.commands.ICommand;
    import com.imajuk.commands.loading.ILoadComponent;
    import com.imajuk.commands.loading.LoadCommandComposite;
    import com.imajuk.commands.loading.LoadCommandLeaf;
    import com.imajuk.interfaces.IDisposable;
    import com.imajuk.interfaces.IProgess;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    /**
     * 多機能ファイルローダー.
     * 
     * <p>ファイルをロードするためのクラスです.
     * 以下の機能を持っています.
     * <ul>
     * 		<li> ロードリクエストを複数追加できます.</li>
     * 		<li> 追加されたリクエストは順番に処理されます.</li>
     * 		<li> 複数のPreLoaderのリクエストを統合して実行できます.</li>
     * 		<li> ロード状況の進捗を取得できます.</li>
     * 		<li> ロード対象になるファイル形式を意識せずにロードを実行できます.
     * 			<ul>
     * 				<li>LoaderやURLLoaderは自動的に生成されます.</li>
     * 				<li>ロード対象になるファイル形式に合ったオブジェクトに、自動的にキャストします.</li>
     * 			</ul>
     * 			</li>
     * 		<li> ロードの一時停止や再開が出来ます.（未実装）</li>
     * 	</ul></p>
     * <p>PreLoader supports file loading.</p>
     * <p>PreLoader has the following functions :
     * <ul>
     * 		<li> you can add a lot of requests to the load file.</li>
     * 		<li> added requests are executed sequentially.</li>
     * 		<li> PreLoader provides complete progress updates about loading requests.</li>
     * 		<li> you can transparently load files with various file-types.
     * 			<ul>
     * 				for example,
     * 				<li>PreLoader won't require a decision whether use Loader, URLLoader or other of loader.</li>
     * 				<li>Loaded content will be casted automatically as a proper object.</li>
     * 			</ul>
     * 	    </li>
     * 		<li> you can pause and resume loading at any time.</li>
     * 	</ul></p>
     * 
     * @author		yamaharu
     * @see			Asset
     * @example		<p>以下の例では、swfファイル、jpgファイル、xmlファイルをロードし、ロード終了後にそれぞれのオブジェクトにアクセスしています.<br/>
     * 				また、ロード中にロードの進捗を出力しています.</p>
     * <listing version="3.0">
     * package
     * {
     *     public class PreloaderExample extends Sprite
     *     {
     * 	        private var content1:Asset;
     *          private var content2:Asset;
     *          private var content3:Asset;
     *          
     * 	        public function PreloaderExample()
     * 	        {
     * 	            var preLoader:PreLoader = new PreLoader();
     * 		
     * 	            //add requests to Preloader.
     * 	            content1 = preLoader.request(new URLRequest("asset/testAsset.swf"));
     * 	            content2 = preLoader.request(new URLRequest("asset/testAsset.jpg"));
     * 	            content3 = preLoader.request(new URLRequest("asset/testAsset.xml"));
     * 			
     * 	            //recieve completion event.
     * 	            preLoader.addEventListener(Event.COMPLETE, onLoadComplete);
     * 	            preLoader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
     * 			
     * 	            //start loading.
     * 	            preLoader.execute();
     * 	        }
     * 						
     * 	        private function onLoadProgress(event:ProgressEvent):void
     * 	        {
     * 	            trace(Preloader(event.target).percentLoaded);
     * 	        }
     * 		
     * 	        private function onLoadComplete(event:Event):void
     * 	        {
     * 	            trace(content1.content is MovieClip); //output : true
     * 	            trace(content2.content is Bitmap); //output : true
     * 	            trace(content3.content is XML); //output : true
     * 	        }
     *     }
     * }
     * </listing>
     */
    public class PreLoader extends EventDispatcher implements ILoadComponent, IDisposable, IProgess
    {
        private static var sid : int;
        private var _value : Number;
        private var _total : Number;
        private var _id : int;
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         * コンストラクタ.
         * @param defaultLoader このオプションは拡張子判別をスキップし、
         *                      引数で与えたクラスのインスタンスをローダとして使用します.
         *                      このオプションを使用しない場合、PreLoaderはファイルの拡張子を判別し
         *                      内部的にLoaderまたはURLLoaderのインスタンスを生成します.
         *                      拡張子がない場合、もしくは拡張子が対応してない場合は、
         *                      <code>flash.display.Loader</code>を生成します.
         */
        public function PreLoader(defaultLoader:Class = null)
        {
            queue = new LoadCommandComposite();
            _defaultLoader = defaultLoader;
            //Preloaderはシーケンシャルなコマンドの実行のみをサポートする
            queue.sequential = true;
            queue.sequentialChildren = true;
            queue.addEventListener(Event.COMPLETE, dispatchEvent);
            queue.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);            queue.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
            queue.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
            
            _id = sid++;
        }
        
        override public function toString() : String 
        {
            return "PreLoader[" + _id + "]";
        }
        

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        private var queue:LoadCommandComposite;
        /**
         * @private
         */
        private var _defaultLoader:Class;
        
        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * ロード対象となる全てのファイルの現在のロード量を合計した数値を返します.
         * 
         * <p>returns loaded bytes of all loaded files.</p>
         */
        public function get bytesLoaded():Number
        {
        	return queue.value;        }

        /**
         * ロード対象となる全てのファイルのデータサイズを合計した数値を返します.
         * 
         * <p>ただし、まだロードを開始していないリクエストについては、合計された数値に含まれません.<br/>
         * 上記の理由で、このプロパティの使用は非推奨です.<br/>
         * ロードの進捗を知りたい場合はpercentLoadedプロパティを使用して下さい.</p>
         * <p>returns total bytes of all loading files.</p>
         * <p>but, this doesn't include bytes that request won't start to load.
         * so, if you want to know progress of loading, 
         * don't use this property, use <code>percentLoaded</code> property.
         * it gives you progress about it.</p>
         */
        public function get bytesTotal():Number
        {
        	return queue.total;
        }

        /**
         * ロード状況の進捗を0〜1の数値で返します.
         * 
         * <p>登録されている全てのリクエストに対する進捗となります.<br/>
         * たとえば、4つのリクエストのうち、2つのリクエストが終了した時点では、この数値は0.5となります.</p>
         * <p>returns value of progress between 0 and 1</p>
         * <p>It's value expresses progress about all added requests.<br/>
         * For example, when 2 requests of 4 requests is completed, this value is 0.5.</p>
         */
        public function get percentLoaded():Number
        {
        	return queue.percent;
        }

        /**
         * ロードリクエストが実行中かどうかを返します.
         * 
         * <p>returns whether loading requests are doing.</p>
         */
        public function get isExecuting():Boolean
        {
            return  queue.isExecuting;
        }
        
        /**
         * ロードリクエストが一時停止中かどうかを返します.
         * 
         * <p>returns whether loading request is paused or not.</p>
         */
        public function get isPausing():Boolean
        {
            return queue.isPausing;
        }

        /**
         * すべてのロードリクエストが終了しているかどうかを返します.
         * 
         * <p>returns whether all loading request was completed.</p>
         */
        public function get isCompleted():Boolean
        {
            return queue.isCompleted;
        }
        
        /**
         * ロード終了を通知する際に、ロードされたアセットの初期化を待つかどうか設定できます.
         * 
         * <p><code>true</code>が設定されると、<code>Preloader</code>はアセットの
         * <code>Event.INIT</code>イベントを検知して、<code>Event.COMPLETE</code>を配信します.<br>
         * <code>false</code>が設定されるとアセットの<code>Event.COMPLETE</code>イベントを検知します.<br>
         * デフォルト値は<code>true</code>です.</p>
         * <p>このプロパティの設定値に関わらず、<code>Preloader</code>が
         * ロード終了後に配信するイベントのタイプは<code>Event.COMPLETE</code>であることに注意して下さい.</p>
         * <p>whether dispatching of completion waits loaded assets initialize or doesn't.</p>
         * <p>if this property is true, PreLoader will accept Event.INIT from loaded object,
         * and dispaches Event.COMPLETE</p>
         * 
         * @default true
         */
        public function get waitInitialize():Boolean
        {
            return queue.waitInitialize;
        }

        public function set waitInitialize(value:Boolean):void
        {
            queue.waitInitialize = value;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods: organize queue
        //
        //--------------------------------------------------------------------------
        
        /**
         * プリローダにリクエストを追加します.
         * 
         * <p>プリローダは、要求された<code>URLRequest</code>のURLから拡張子を識別し、
         * 適当なローダを内部的に生成します.<br/>
         * このメソッドは、<code>Asset</code>オブジェクトを返します.
         * ロード終了後に、このオブジェクトを通してロードしたアセットにアクセスできます.</p>
         * <p>add a request to PreLoader.</p>
         * <p>PreLoader analyses extention of URL included loading request, 
         * and creates internally proper loader.<br/>
         * And also, this method returns <code>Asset</code>.<br/>
         * After loading, you can access loaded contents by <code>Asset.content</code> property.</p>
         * 
         * 
         * @param urlRequest	ロードしたいファイルのURLを含む<code>URLRequest</code>.
         * 						<p><code>URLRequest</code> includes URL</p>
         * @param context       ローダーコンテクスト
         *                      デフォルトはnew LoaderContext(true, ApplicationDomain.currentDomain)です
         * @see					Asset
         */
        public function request(urlRequest:URLRequest, context:LoaderContext = null, asBinary:Boolean = false):Asset
        {
            var item:LoadCommandLeaf = new LoadCommandLeaf(urlRequest, _defaultLoader, context || new LoaderContext(true, ApplicationDomain.currentDomain), asBinary);
            queue.add(item);
            return new Asset(item);
        }

        /**
         * プリローダを結合してリクエストをまとめます.
         * 
         * <p>まず現在の<code>PreLoader</code>に登録されているリクエストの後に引数で渡した<code>PreLoader</code>のリクエストが続きます.</p>
         * <p>concatenates requests to another <code>PreLoader</code>'s request.</p>
         */
        public function join(preLoader:PreLoader):PreLoader
        {
            queue.add(preLoader.queue);
            return this;
        }
        
        public function dispose():void
        {
        	//値を保存しておく
            _value = queue.value;
            _total = queue.total;
            
        	queue.removeEventListener(Event.COMPLETE, dispatchEvent);
            queue.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
            queue.removeEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
            queue.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
            queue.dispose();
            queue = null;
            
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: control queue
        //
        //--------------------------------------------------------------------------
        
       /**
         * ロードを一時停止します.
         * 
         * <p>pause loading request.</p>
         */
        public function pause():Boolean
        {
          return queue.pause();
        }

        /**
         * ロードを完全に停止します.
         * 
         * <p>pause()とちがうところは、resume()が出来ない事です.</p>
         * <p>stop loading request.<br/>
         * the difference between pause and stop is a thing whether can resume.</p>
         */
        public function stop():Boolean
        {
            return queue.stop();
        }

        /**
         * 一時停止したロードを開始します.
         * 
         * <p>今のところ未実装です</p>
         * <p>resume paused request.</p>
         */
        public function resume():Boolean
        {
            return queue.resume();
        }

        /**
         * 追加されたリクエストについて、ロードを開始します.
         * 
         * <p>まず、最初に追加されたリクエストについてロードし、終了すると次のリクエストに続きます.</p>
         * <p>全てのリクエストについてロードが終了すると、プリローダは<code>Event.Complete</code>イベント、
         * および<code>HTTPStatusEvent.STATUS</code>イベントを配信します.<br>
         * また、ファイルが見つからない場合は<code>IOErrorEvent.IO_ERROR</code>イベント、
         * および<code>HTTPStatusEvent.STATUS</code>イベントを配信します.</p>
         * <p>executes requests, and start loading.</p>
         * <p>First, PreLoader starts to load first request.<br/>
         * After first request is completed, second request will start,
         * and next as same.<br/>
         * When all loading requests will be completed, 
         * PreLoader dispatches <code>Event.Complete</code> and <code>HTTPStatusEvent.STATUS</code>.<br/>
         * If requested file didn't get, PreLoader dispatches <code>IOErrorEvent.IO_ERROR</code> 
         * and <code>HTTPStatusEvent.STATUS</code>.</p>
         */
        public function execute():ICommand
        {
            return queue.execute();
        }

        public function get value() : Number
        {
            return queue ? queue.value : _value;
        }

        public function get total() : Number
        {
            return queue ? queue.total : _total;
        }

        public function get percent() : Number
        {
            return queue ? queue.percent : 1;
        }

        public function set value(value : Number) : void
        {
        }

        public function set total(value : Number) : void
        {
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: cloning
        //
        //--------------------------------------------------------------------------
        
        /**
         * プリローダを複製します.
         * 
         * <p>保持しているリクエストも全てコピーされます.</p>
         * <p>creates clone and returns it.<br/>
         * all request included will be copied.<p>
         */
//        public function clone():ICommand
//        {
//            return new PreLoader().join(this);
//        }
    }
}
