package com.imajuk.site
{
    import com.imajuk.interfaces.IProgressView;
    import com.imajuk.logs.Logger;
    import com.imajuk.service.ProgressInfo;
    import com.imajuk.threads.ThreadUtil;

    import org.libspark.thread.Monitor;
    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    /**
     * [inject]指定したオブジェクトが参照できることを保証するためのThreadです.
     *      * 参照時にビューがまだなければアセットをロードしてビューを生成する     *      * @author shinyamaharu     */    public class ReferencableViewThread extends Thread     {
        private var hasInitMetadata : Boolean;
        private var monitor : Monitor;
        private var construct : Boolean;
        //--------------------------------------------------------------------------
        //
        //  Constractor
        //
        //--------------------------------------------------------------------------
        /**
         * コンストラクタ
         */
        public function ReferencableViewThread()
        {
            super();
            analyzer = new ApplicationMetaDataAnalyzer(this);
            ref = new Reference(getDefinitionByName(getQualifiedClassName(this)) as Class);
            instanceResistrar = InstanceRegistory.getInstance();
            construct = true;
        }

        /**
         * @private
         */
        override protected final function run() : void        {
            if (isInterrupted) return;

            //=================================
            // try injection
            //=================================
            if (tryInject())
            {
            	next(execPreProcess);
            	return;
            }
            
            next(prepareProgress);
        }

        private function prepareProgress() : void
        {
        	if (isInterrupted) return;
            interrupted(function() : void {t.interrupt();});
            
            //=================================
            // prepare progress view
            //=================================
            if (!progressViewInfo)
            {
                Logger.warning("ステートのProgressViewが定義されていません.");
                progressViewInfo = new ProgressInfo();
            }
            else
            {
                var t:Thread = new PrepareProgressViewThread(progressViewInfo);
                t.start();
                t.join();
            }
            
            next(createInjectObjects);
        }
        
        private function createInjectObjects() : void
        {
        	if (isInterrupted) return;
            interrupted(function() : void
            {
                ThreadUtil.interrupt(t);
            });
            
            //アセットをロードする必要がなければ次へ
            if (myAssetRecipe.children().length() == 0)
            {
                next(execPreProcess);
                return;
            }
            
            //ロードプログレス終了通知用モニタ
            monitor = new Monitor();
            progressViewInfo.monitor = monitor;
        	
            //アセットのロードスタート
            var t:Thread = 
                new ApplicationAssetLoader().getConstructionTaskFromRecipe(
                    myAssetRecipe, 
                    progressViewInfo
                );
            t.start();
            t.join();
            
            next(tryInjectAgain);
        }

        private function tryInjectAgain() : void
        {
        	//インジェクト
            tryInject();

            if (progressViewInfo.progress.percent < 1)
            {
                //通常の初期化フェーズならプログレスビューの終了を待つ
                if (!hasInitMetadata)
                    monitor.wait();
            }
            
            next(execPreProcess);
        }

        /**
         * @private
         */
        private function execPreProcess() : void
        {
            //=================================
            // 前回のステートに関連するビューを取り除く
            //=================================
            if (isState)
                DisplayManager.removeTemporaryAssets();
            
        	if (initializeNotifer)
        	   initializeNotifer.notify();
        	   
            initialize();
        }
                /**
         * コンストラクタの後に最初に呼び出されるメソッドです.
         * <p>
         * このメソッド以降、[inject]指定したオブジェクトが参照できる事がフレームワークにより保証されています.
         * </p>
         * <p>
         * 全てのステートはこのメソッドをoverrideしなければなりません.
         * （通常のThreadはrun()で開始しますが、ステートはinitialize()から開始します.
         * run()をoverrideする事は出来ません）
         * </p>
         */        protected function initialize() : void         {
        	throw ApplicationError.create(ApplicationError.CALL_ABSTRACT);        }
        
        //--------------------------------------------------------------------------
        //
        //  API for you!
        //
        //--------------------------------------------------------------------------
        private var progressViewInfo : ProgressInfo;
        protected function get progressView() : IProgressView
        {
            return progressViewInfo.progressView;
        }
        /**
         * アプリケーションの実行を通じて永続的なビューをアプリケーションのメインコンテナに追加します.
         * <p>
         * ステートの終了時に<code>removeChild()</code>されるビューを追加するには<code>addTemporaryAsset()</code>を使用します.
         * </p>
         * @param ref   ビューを参照する<code>Reference</code>オブジェクト
         * @param layerName ビューの配置先となるレイヤー
         * @see #addTemporaryView()
         * @see Reference
         * @see ApplicationLayer
         */
        protected function addParmanentView(view : DisplayObject, layerName:String) : void 
        {
        	addView(DisplayManager.addParmanentAsset, view, layerName);
        }
        
        /**
         * ステートの実行を通じて永続的なビューを任意のレイヤーに追加します.
         * <p>
         * ステートが終了するとビューはフレームワークにより自動的に<code>removeChild()</code>されます.
         * </p>
         * <p>
         * ステートが終了しても<code>removeChild()</code>されないビューを追加するには<code>addParmanentAsset()</code>を使用します.
         * </p>
         * 
         * @param ref       ビューを参照する<code>Reference</code>オブジェクト
         * @param layerName ビューの配置先となるレイヤー
         * @see #addParmanentView()
         * @see Reference
         * @see ApplicationLayer
         */
        protected function addTemporaryView(view : DisplayObject, layerName:String = ApplicationLayer.CONTENT) : void 
        {
        	addView(DisplayManager.addTemporaryView, view, this, ref, layerName);
        }
        
        /**         * このステートに必要なアセットのロード中に表示するIProgressViewを登録します.
         * IProgressViewのレイアウトはIProgressViewのbuild()メソッドで実装します.
         * <p>         * IProgressViewはアセットのロード終了後自動的にタイムラインから取り除かれます
         * </p>         * @param progressViewRef   IProgressViewを参照するReferenceインスタンス         * @param tmeline           IProgressViewが配置されるタイムライン         */        protected function resisterProgressView(                                progressViewRef : Reference,                                 waitProgressViewHiding:Boolean = true
                           ) : void
        {
        	if (!construct)
        	   throw ApplicationError.create(ApplicationError.MUST_REGISTER_PROGRESS_VIEW_IN_CONSTRUCTOR);
        	
        	if (!progressViewRef)
        	   return;
        	   
            Logger.info(1, this + " uses " + progressViewRef + " for loading progress display.");
            
            //ProgressViewを生成するための情報
            progressViewInfo = 
               new ProgressInfo(
                    waitProgressViewHiding,
                    null, 
                    progressViewRef
                ); 
        }

        /**
         * ステートを変更します.
         * <p>
         * 引数に渡されるステートはステートレシピで定義されている必要があります.
         * </p>
         */
        protected function changeState(state : Reference) : Boolean
        {
            return _application.changeState(state);
        }
        
        /**
         * 指定したinjectionのタイプを変更します.
         * <p>
         * これはインターフェイスや抽象クラスが定義されたinjectionにたいして実装クラスを上書きする際に使用します
         * </p>
         */
        protected function inject(name:String, viewRef:Reference) : void
        {
            analyzer.inject(name, viewRef);
        }
        
        /**
         * ステートに依存しないGlovalControlerを生成し、起動します.
         * <p>
         * 典型的なGlovalControlerとしてグローバルナビゲーションのコントローラなどが挙げられます。
         * このメソッドを使用する事で任意のステートがCommonControlerを起動できます
         * </p>
         */
        protected function startGlobalControler(klass : Class) : void
        {
            ApplicationControlerFactory.create(klass, _application, false).start();
        }
        
        /**
         * アセットレシピを追加、または上書きします.
         * <p>
         * このメソッドはアプリケーションの言語切り替えなどに利用されます.
         * </p>
         */
        protected function overwriteAssetRecipie(receipt:XML):void
        {
        	instanceResistrar.registerReceipt(receipt);
        }
        
        //--------------------------------------------------------------------------
        //
        //  API for internal
        //
        //--------------------------------------------------------------------------
        private var _application : Application;
        /**
         * @private
         * Applcationの参照
         */
        internal function set application(value : Application) : void
        {
            _application = value;
        }
        /**
         * @private
         * イニシャライズされた事を知らせるオブジェクト
         */
        internal var initializeNotifer : Monitor;
        /**
         * @private
         * このオブジェクトがステートならtrue, グローバルコントローラならfalse
         */
        internal var isState : Boolean;
        
        //--------------------------------------------------------------------------
        //
        //  private
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         * メタタグ解析オブジェクト
         */
        private var analyzer:ApplicationMetaDataAnalyzer;
        /**
         * @private
         * 自分自身のReference表現
         */
        private var ref : Reference;
        /**
         * @private
         * このステートが必要とするアセットレシピ
         */
        private var myAssetRecipe : XML = <root></root>;
        /**
         * @private
         */
        private var instanceResistrar : InstanceRegistory;
        /**
         * @private
         * ビューの参照を格納。Referenceインスタンスをキーとする
         */
        private var resisterdViews : Dictionary = new Dictionary(true);
        /**
         * @private
         * add View to an application layer.
         */
        private function addView(addingMethod : Function, view : DisplayObject, ...param) : void
        {
            if (view)
                addingMethod.apply(undefined, [view].concat(param));
            else
                if (resisterdViews[view])
                    throw ApplicationError.create(
                        ApplicationError.FAILED_INJECT, 
                        new Reference(getDefinitionByName(getQualifiedClassName(view)) as Class)
                    );
                else
                    throw ApplicationError.create(ApplicationError.FAILED_ADDING_VIEW);
        }
        /**
         * @private
         * ビューの取得を試みる.
         * 失敗した場合はアセットをロードしてビューを生成する
         */
        private function tryInject() : Boolean 
        {
        	//全てのインジェクトオブジェクトにアクセス可能かどうか
            var canAccessAll:Boolean = true;
            
            //analyze State Class and create new view receipt for lazy loading
            analyzer.getMetaDataInfo(MetaData.INJECT).forEach(
                function(info : Object, ...param) : void
                {
                    var viewReference : Reference = 
                        new Reference(getDefinitionByName(info.type) as Class);
                    try
                    {
                        //=================================
                        // このステートに登録されているビューの生成を試みる
                        // 失敗したらそれはまだ生成されてないビュー
                        //=================================
                        var vRef:* = instanceResistrar.getAsset(viewReference);
                        resisterdViews[vRef] = true;
                        //=================================
                        // 成功したらプロパティにビューをインジェクト
                        //=================================
                        this[info.propName] = vRef;
                    }
                    catch(e : ApplicationError)
                    {
                        Logger.info(0, "The view [" + viewReference + "] still not be instantiated, it'll be done after loading asset.\nthe loading are starting now...");
                        canAccessAll = false;
                        //=================================
                        // アセットをロードするためにレシピを編集
                        //=================================
                        try
                        {
                            var r:XML = instanceResistrar.getReceipt(viewReference.encode());
                        }
                        catch(e2:ApplicationError)
                        {
                            throw ApplicationError.create(
                               ApplicationError.FAILED_ASSET_LOADING, getQualifiedClassName(this), 
                               e2.message
                            );
                        }
                        myAssetRecipe.appendChild(r);
                    }
                }, this
            );
            
            return canAccessAll;
        }
    }
    }