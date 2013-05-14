package com.imajuk.site
{
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.service.AssetLocation;
    import com.imajuk.service.IAssetLocation;
    import com.imajuk.service.PreLoaderThread;
    import com.imajuk.service.ProgressInfo;
    import com.imajuk.utils.StringUtil;

    import org.libspark.thread.Monitor;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;



    /**
     * アセットのロードとインジェクトオブジェクトの生成
     * @author shinyamaharu
     */
    internal class ApplicationAssetLoader 
    {
        private var domainRegistrar : AppDomainRegistry;
        private var instanceRegistrar : InstanceRegistory;
        private static var sid : int;
        private var id : int;

        public function ApplicationAssetLoader()
        {
        	id = sid++;
            domainRegistrar = AppDomainRegistry.getInstance();
            instanceRegistrar = InstanceRegistory.getInstance();
        }
        
        public function toString() : String
        {
            return "ApplicationAssetLoader" + id;
        }
        
        /**
         * 以下のプロセスを実行するThreadを返します.
         * プロセス
         * ------------------------------------------------------------
         * レシピに記述されたアセットをロードしViewがあれば生成しレジストリに保存します.
         * ルートノードがプログレスビューであれば先にロードします.
         */
        internal function getConstructionTaskFromRecipe(receipt : XML, progressInfo:ProgressInfo = null) : Thread 
        {
        	//レシピが渡されなかったら何もしない
            if (!receipt)
                return new Thread();
                
            //------------------------
            // varidate
            //------------------------
            var elements : XMLList = receipt.elements();
            if (elements.length() == 0)
                throw ApplicationError.create(ApplicationError.NO_ASSETS_DEFINITION_IN_RECIPE);
            if (receipt.children().length() == 0)
                return new Thread();
            
            return getConstructionTask(receipt, progressInfo);
        }

        /**
         * @private
         * 渡されたXMLの要素をレシピとしてアセットをロードしViewを構築するためのThreadを返す
         */
        private function getConstructionTask(
                                receipt : XML, 
                                progressInfo:ProgressInfo = null
                            ) : Thread 
        {
            //------------------------------------------------
            // whole task of loading assets and creating view
            //------------------------------------------------
            var p:ParallelExecutor = new ParallelExecutor();
            p.name = "construction request task " + p.id;
            //------------------------------------------------
            // loading request
            //------------------------------------------------
            var a : IAssetLocation = new AssetLocation();
            //------------------------------------------------
            // add loading request from recipe 
            // and task for construct view as ViewFactoryThread
            //------------------------------------------------
            for each (var xml : XML in receipt.elements()) 
                p.addThread(addConstructionRequest(xml, a));
            //------------------------------------------------
            // add loading task as PreloaderThread
            //------------------------------------------------
            p.addThread(PreLoaderThread.create(a, null, null, progressInfo));
            return p;
        }
        
        /**
         * @private
         */
        private function addConstructionRequest(receipt : XML, a:IAssetLocation) : Thread 
        {
            //=================================
            // create requests from recipe
            //=================================
            var inject   : String = receipt.name(),
                klass    : Class = domainRegistrar.getDefinition(Reference.decodeType(inject)) as Class,
                src      : String = receipt.@src,
                ctx      : String = receipt.@appdomain,
                bin      : String = receipt.@bin,
                factory  : ViewFactoryThread = new ViewFactoryThread(klass, domainRegistrar, instanceRegistrar, inject),
                callback : Function = 
                    function(i:int, m:Monitor):Function{
                        return function(asset:*):void
                        {
                            factory.setAsset(asset, i);
                            m.notify();
                        };
                    };
            
            StringUtil.trimSpace(src).split(",").forEach(function(s:String, idx:int, ...param) : void
            {
                a.add(
                    new URLRequest(s), 
                    callback(idx, factory.createMonitor()),
                    new LoaderContext(true, ctx == "current" ? ApplicationDomain.currentDomain : new ApplicationDomain()),
                    bin.length > 0
                );
            });
            return factory;            
        }
    }
}
