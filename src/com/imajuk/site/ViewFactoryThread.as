package com.imajuk.site
{
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.InstanceFactory;
    import com.imajuk.logs.Logger;
    import com.imajuk.threads.ThreadUtil;

    import org.libspark.thread.Monitor;
    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.utils.getQualifiedClassName;

    /**
     * @author shinyamaharu
     */
    public class ViewFactoryThread extends Thread
    {
        private var monitors : Array = [];
        private var assets : Array=[];
        private var klass : Class;
        private var domainRegistrar : AppDomainRegistry;
        private var instanceRegistrar : InstanceRegistory;
        private var inject : String;

        public function ViewFactoryThread(klass : Class, domainRegistrar : AppDomainRegistry, instanceRegistrar : InstanceRegistory, inject : String)
        {
            super();
            this.klass = klass;
            this.domainRegistrar = domainRegistrar;
            this.instanceRegistrar = instanceRegistrar;
            this.inject = inject;
        }

        public function createMonitor() : Monitor
        {
            var m:Monitor = new Monitor();
            monitors.push(m);
            return m;
        }

        public function setAsset(asset : *, order:int) : void
        {
            assets[order] = asset;

            //ApplicationDomainを登録
            if (asset is DisplayObject)
                domainRegistrar.resisterAppDomain(asset);
        }

        override protected function run() : void
        {
            var p:Thread = 
                ThreadUtil.pararel(
                    monitors.map(function(m:Monitor, ...param) : Thread
                    {
                        return new WaitMonitorThread(m);
                    })
                );
            p.name = "waiting asset loading "+id;
            p.start();
            p.join();
            
            next(allAssetsLoaded);
        }
        
        //--------------------------------------------------------------------------
        //  アセットのロード終了後処理
        //--------------------------------------------------------------------------
        private function allAssetsLoaded() : void
        {
            if (!klass) return;

            //=================================
            // ラップするべきViewがあれば生成してラップする
            //=================================
            try
            {
                //ViewまたはModelを生成
                var instance:* = InstanceFactory.newInstance(klass, assets);
            }
            catch(e:Error)
            {
                throw ApplicationError.create(ApplicationError.CONSTRUCTION_PROBLEM, getQualifiedClassName(klass), e.message);
            }
            //生成したインスタンスを登録
            instanceRegistrar.register(inject, instance);
            Logger.info(1, "Registered AssetRegistory[ " + inject + " ] ← " + instance);
        }

        override protected function finalize() : void
        {
        }
    }
}
import org.libspark.thread.Monitor;
import org.libspark.thread.Thread;
class WaitMonitorThread extends Thread
{
    private var m : Monitor;

    public function WaitMonitorThread(m : Monitor)
    {
        this.m = m;
    }
    
    override protected function run():void
    {
        m.wait();
    }
}
