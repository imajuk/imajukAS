package com.imajuk.service 
{
    import flash.utils.getQualifiedClassName;
    import com.imajuk.threads.ThreadUtil;

    import org.libspark.thread.Thread;

    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;


    /**
     * 要求されたURLをロードし、ロード内容をクライアントにセットするスレッド
     * @author yamaharu
     */
    public class PreLoaderThread extends Thread 
    {
        /**
         * PreLoaderThreadを生成します.
         * @param location  URL文字列またはIAssetLocationオブジェクト
         */
        public static function create(location:*, callBack:Function = null, defaultLoader:Class = null, progressInfo:ProgressInfo = null):Thread
        {
            if (!(location is IAssetLocation) && !(location is String)) throw new Error("location must be URL String or IAssetLocation. but actually it's " + getQualifiedClassName(location));
            
            if (location is String)
                location = new AssetLocation()
                            .add(new URLRequest(location), callBack == null ? function(...param):void{} : callBack);

            var loader:PreLoader = new PreLoader(defaultLoader);
                
            if (progressInfo)
            {
                if (progressInfo.progress is AbstractProgress)
                    AbstractProgress(progressInfo.progress).add(loader);
                else
                    progressInfo.progress = loader;
            }
                    
            return new PreLoaderThread(loader, location, progressInfo);
        }
        
        private var reason:String;
        private var preloader:PreLoader;
        private var locations:Array;
        private var assetLocation:IAssetLocation;
        private var progressThread:Thread;
        private var progressInfo : ProgressInfo;
        private var asset : Array;
        private var intvl : uint;

        /**
         * PreLoaderのクライアントスレッド.
         * ロードの進捗を表示する場合はProgressInfoを渡します.
         * @param preloader         ロードを実行するPreLoaderです.
         * @param assetLocation     ロードを実行するためのレシピです.
         * @param progressInfo      ロードの進捗を表示するために必要な情報オブジェクトです.
         * 
         * @see Application, ProgressThread
         */
        public function PreLoaderThread(
                            preloader:PreLoader,
                            assetLocation:IAssetLocation,
                            progressInfo:ProgressInfo = null
                            )
        {
            super();
            
            this.preloader = preloader;
            this.progressInfo = progressInfo;
            
            //ロード対象のURIの配列
            this.assetLocation = assetLocation;
            this.locations = assetLocation.locations;
        }
        
        override protected function run():void
        {
        	if (isInterrupted)
        	   return;
        	   
        	//ローカルリソース用のIOERRORハンドラ
        	event(preloader, IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
            {
            	throwError("プリロード開始時にエラーが発生しました.", reason || e.text);
            });
            
            //リクエスト生成
            asset = locations.map(
                function(u:URLRequest, ...p):Asset
                {
                    return preloader.request(u, assetLocation.getContext(u.url), assetLocation.binaryLoading(u.url));
                }
            );
            
            //プログレスビューがあればプログレスビュー更新スレッド開始
            progressThread = (progressInfo && progressInfo.progressView) ? ProgressThread.create(progressInfo) : new Thread();
            progressThread.start();
            
            waitEvent();
            
            //ローカルファイルのロード時にイベント登録前にロードが終了するのを防ぐ
            //イベント登録は2フレ後
            intvl = setTimeout(function():void
            {
                //ロード開始
                preloader.execute();
            }, 100);
        }

        private function throwError(message:String, reason:String) : void 
        {
            finalize();
            throw new Error(message + "\n[REASON] Error: " + reason + "\n");
        }

        private function waitEvent() : void 
        {
        	interrupted(function():void
            {
                preloader.stop();
//                throwError("プリロードがキャンセルされました.", reason || "INTERRUTED");
            });
            
            //ロード終了後処理
            event(preloader, Event.COMPLETE, function():void
            {
                if (isInterrupted) return;
                interrupted(function():void{});
                    
                locations.forEach(
                    function(u:URLRequest, idx:int, ...p):void
                    {
                        assetLocation.regist(u.url, Asset(asset[idx]).content);
                    }
                );
                
                if (progressThread)
                    progressThread.join();
            });
            
            //リモートリソース用のIOErrorハンドラ
            event(preloader, IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
            {
            	throwError("プリロード開始時、または終了時にエラーが発生しました.", reason || e.text);
            });
            
            error(Error, function(e:Error, ...param):void
            {
            	throwError("プリロード開始時、または終了時にエラーが発生しました.", reason || e.message);
            });
            
            event(preloader, HTTPStatusEvent.HTTP_STATUS, function(e:HTTPStatusEvent):void
            {
            	//正常なステータスコードが帰ってこなければエラーになる可能性があるので委譲の理由として覚えておく
                if (e.status > 200)
                    reason = String(e.status);
                
                waitEvent();
            });
        }

        override protected function finalize() : void
        {
        	if (preloader)
                preloader.dispose();
            preloader = null;
            locations = null;
            assetLocation = null;
            ThreadUtil.interrupt(progressThread);
            progressThread = null;
            
            clearTimeout(intvl);
        }

    }
}
