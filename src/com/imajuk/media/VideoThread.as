package com.imajuk.media
{
    import fl.motion.easing.Exponential;
    import fl.video.VideoEvent;

    import com.imajuk.constants.Direction;
    import com.imajuk.graphics.Align;
    import com.imajuk.logs.Logger;
    import com.imajuk.motion.TweensyThread;
    import com.imajuk.threads.ThreadUtil;
    import com.imajuk.utils.DisplayObjectUtil;
    import com.imajuk.utils.StageReference;

    import org.libspark.thread.Thread;

    import flash.display.Sprite;
    import flash.events.Event;



    /**
     * @author shinyamaharu
     */
    public class VideoThread extends Thread
    {
    	private var sourceURL : String;
        private var container : Sprite;
        private var video : SimpleFLVPlayer;        private var videoCompleteCallback : Function;
        private var loop : Boolean;
        private var tween : Thread = new Thread();
        private var videoSize : VideoSize;
        private var videoUI : IVideoUI;
        private var bufferWatcher : BufferWacherThread;
        private var alert : IBufferingAlert;
        private var videoUIThread : VideoUIThread;
        private var autoStart : Boolean;

        /**
         * @param sourceURL     ビデオファイルのURL
         * @param container     ビデオインスタンスを格納するコンテナ
         * @param useLoop       ビデオ終了後ループ再生するかどうか
         * @param videoSize     ビデオのサイズを定義するVideoSizeインスタンス
         * @param videoUI       ビデオを操作するUI、IVideoUIインスタンス
         * @param callback      ビデオ終了時に実行するコールバック
         * @param alert         ビデオのバッファリング状態を示すIBufferingAlertインスタンス
         * 
         * //TODO StreamNotFoundのエラーをこのThreadでキャッチできるようにする
         */
        public function VideoThread(
                            sourceURL : String, 
                            container : Sprite,
                            useLoop : Boolean = false,
                            autoStart:Boolean = true,
                            videoSize : VideoSize = null,
                            videoUI : IVideoUI = null, 
                            videoCompleteCallback : Function = null,
                            alert:IBufferingAlert = null
                        )
        {
            super();
            
            this.sourceURL = sourceURL;
            this.container = container;
            this.loop      = useLoop;
            this.autoStart = autoStart;
            this.videoSize = videoSize || new VideoSize(VideoSize.USE_ORIGINAL_SIZE);
            this.videoUI   = videoUI;
            this.videoCompleteCallback  = videoCompleteCallback;
            this.alert = alert;
        }

        override protected function run() : void
        {
            if (isInterrupted) return;
            interrupted(function():void{});
            
            error(Error, function(...param):void
            {
            	Logger.error(param[0], param[1]);
            });
            
            //=================================
            // video player
            //=================================
            // 一つのvideoインスタンスを使い回すとなぜか2周目からdraw()できなくなるので
            // 毎回インスタンスを生成するようにした.
            destroyVideo();
            createVideoPlayer();
            
            //=================================
            // videoUI
            //=================================
            if (videoUI)
                mediateVideoUI();
            
            //=================================
            // bufering alert
            //=================================
            if (alert)
                mediateBufferingAlert();
            
            next(startVideo);
        }

        private function mediateBufferingAlert() : void 
        {
            bufferWatcher = new BufferWacherThread(video, alert);
            bufferWatcher.start();
        }

        private function createVideoPlayer() : void
        {
            video = container.addChild(new SimpleFLVPlayer()) as SimpleFLVPlayer;            video.name = "_simpleFLVPlayer_";
        }
        
        private function mediateVideoUI() : void
        {
            var f : Function = function():void
            {
                videoUIThread = new VideoUIThread(video, videoUI, videoSize, autoStart);                videoUIThread.start();
            };
            
            if (videoUI.parent)
                f();
            else
                //=================================
                // VideoUI のレイアウトにはstageプロパティを取得する必要がある.
                // addChild直後にstageプロパティは取得できないのでイベントを待つ
                //=================================
                videoUI.addEventListener(Event.ADDED_TO_STAGE, function():void
                {
                    videoUI.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
                    f();
                });
        }

        private function startVideo() : void 
        {
        	if (isInterrupted) return;
            interrupted(function():void{});
        	
            video.play(null, sourceURL);            
            event(video, VideoEvent.READY, 
                function():void
                {
                    if (isInterrupted) return;
                    
                    resolveVideoSize();
                        
                    tween = new TweensyThread(video, 0, 2, Exponential.easeInOut, null, {alpha:1});
                    tween.start();
                    
                    if (autoStart)
                    {
                        next(waitComplete);
                    }
                    else
                    {   
                    	sleep(100);
                        next(function() : void
                        {
                            video.pause();
                            waitComplete();
                        });
                    }
                }
            );
        }

        private function resolveVideoSize() : void 
        {
            switch(videoSize.mode)
            {
                case VideoSize.SHOW_ALL_IN_STAGE:
                    DisplayObjectUtil.fitToRectangle(
                        container, 
                        StageReference.stage.stageWidth, 
                        StageReference.stage.stageHeight, 
                        Direction.BOTH
                    );
                    Align.align(container, Align.Top);
                    break;
                    
                case VideoSize.HORIZON_FIT_TO_STAGE:
                    DisplayObjectUtil.fitToRectangle(
                        container, 
                        StageReference.stage.stageWidth, 
                        StageReference.stage.stageHeight, 
                        Direction.HORIZON
                    );
                    break;
                    
                case VideoSize.FIXED_SIZE :
                    video.width = videoSize.custumWidth;
                    video.height = videoSize.custumHeight;
                    break;
            }
                
            Logger.debug("video size was solved", video.width, video.height, video.scaleX, video.scaleY);
        }
        
        private function destroyVideo() : void 
        {
            DisplayObjectUtil.removeChild(video);
            if (video) video.destroy();
            ThreadUtil.interrupt(videoUIThread);
            ThreadUtil.interrupt(bufferWatcher);
        }

        private function waitComplete() : void 
        {
            if (isInterrupted) return;
            interrupted(function():void{});
            
            error(Error, function(e:Error, ...param):void
            {
                trace("!!!", e);
            });

            event(video, VideoEvent.COMPLETE, function():void
            {
                if (isInterrupted) return;
                
                if (videoCompleteCallback != null)
                   videoCompleteCallback();
                   
                if (loop)
                    next(run);
            });
            
            event(StageReference.stage, Event.RESIZE, function():void
            {
                if (isInterrupted) return;
                resolveVideoSize();
                waitComplete();
            }, false, 1);
        }

        override protected function finalize() : void
        {
        	Logger.debug(this);
            tween.interrupt();
            
            destroyVideo();
        }

    }
}
