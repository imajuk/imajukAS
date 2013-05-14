package com.imajuk.media.simpleFLVPlayer
{
    import fl.video.MetadataEvent;
    import fl.video.VideoEvent;

    import com.imajuk.behaviors.ColorBehavior;
    import com.imajuk.color.Color;
    import com.imajuk.media.SimpleFLVPlayer;
    import com.imajuk.ui.buttons.AbstractButton;
    import com.imajuk.ui.buttons.IButton;
    import com.imajuk.ui.buttons.fluent.BehaviorContext;
    import com.imajuk.utils.DisplayObjectUtil;
    import com.imajuk.utils.StageReference;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;


    
    public class SimpleFLVPlayerWithUI extends Sprite
    {
        public static const RG_CREAM2:Color = Color.fromHSV(32, 22, 79);
        public static const RG_WHITE2:Color = Color.fromHSV(32, 0, 100);
        private var video:SimpleFLVPlayer;
        private var btn_play:IButton;
        private var btn_sound:IButton;
        private var playHead:IButton;
        private var isSeeking:Boolean;
        private var pressedPosition:Number;
        private var loaded:Boolean;
        private var loadedPer:Number;
        private var videoPath:Array;
        private var currentVideo:Number;
        private var asset:DisplayObjectContainer;
        private var intf:DisplayObjectContainer;
        private var barHolder:DisplayObjectContainer;
        private var loadingProgressbar:DisplayObject;
        private var progressbar:DisplayObject;

        public function SimpleFLVPlayerWithUI(asset:DisplayObjectContainer, videoPath:Array)
        {
            super();            this.videoPath = videoPath;
            this.asset = addChild(asset) as DisplayObjectContainer;
            this.intf = asset.getChildByName("intf") as DisplayObjectContainer;
            this.barHolder = intf.getChildByName("barHolder") as DisplayObjectContainer;
            this.progressbar = barHolder.getChildByName("bar");            this.loadingProgressbar = barHolder.getChildByName("loadingBar");
            
            videoPath.forEach(function(path:String, idx:int, ...param):void
            {
                if (!(path is String) || path == null)
                    throw new Error("invalid video path : index " + idx + " : " + path);
            });
		
            createVideo();
            createInterface();
            
            layout();
        }

        //---------------------------------------------------------------------------------command
        public function showMovie(movieIndex:Number):void
        {
            initialize();
            
            currentVideo = movieIndex;
            video.play(null, videoPath[movieIndex]);
        }

        //---------------------------------------------------------------------------------event
        public function layout(event:Event = null):void
        {
            intf.x = video.x;
            intf.y = Math.round(video.y + video.height) + 10;		            //bar
            barHolder.width = video.width;            
            //btn
            btn_sound.x = barHolder.width - 30;            btn_play.x = barHolder.width - 60;
        }

        private function onProgress(event:VideoEvent):void
        {
            updateProgressBar(video.playheadTime, video.duration);
            updatePlayHead();
        }

        private function videoCompleteHandler():void
        {
        }

        private function buttonDownHandler(event:MouseEvent):void
        {
            isSeeking = true;
		
            var btn:Sprite = event.target as Sprite;
            pressedPosition = btn.x;
            
            var w:Number = DisplayObjectUtil.getRenderedWidth(barHolder);            var y:Number = btn.y;
            var r:Rectangle = new Rectangle(0, y, w * loadedPer, y); 
		
            btn.startDrag(true, r); 	
        }

        private function mouseUpHandler(event:MouseEvent):void
        {
            trace(isSeeking);
		
            if (isSeeking)
            {
                var m:Sprite = Sprite(playHead);
                m.stopDrag();
                seek(m.x);
                isSeeking = false;
            }
        }

        private function buttonReleaseHandler(event:MouseEvent):void
        {
            var btn:IButton = event.target as IButton;
            //TODO ボタンのアセットに直接アクセスするのではなく、SwapFrameButtonを実装する
            //おそらくclickBehaviorを持つ            var m:MovieClip = MovieClip(btn["asset"]);
            switch(btn)
            {
                case btn_play:
				
                    if(m.currentFrame == 1)
                    {
                        trace("PAUSE");                        video.pause();
                        m.gotoAndStop(2);
                    }
                    else
                    {
                        trace("PLAY");
                        video.resume();
                        m.gotoAndStop(1);
                    }
                    break;
				
                case btn_sound :
                    var st:SoundTransform = new SoundTransform();
				    if(m.alpha == 1)
                    {
                        m.alpha = .4;
                        st.volume = 0;
                        SoundMixer.soundTransform = st;
                    }
                    else
                    {
                        m.alpha = 1;
                        st.volume = 1;
                        SoundMixer.soundTransform = st;
                    }
                    break;
				
                case playHead :
                    m.stopDrag();
                    seek(m.x);
                    isSeeking = false;
                    break;
            }
        }

        private function onSeekInvalid():void
        {
        }

        private function metadataReceivedHandler(event:MetadataEvent):void
        {
            trace(this + " : metadataReceivedHandler " + [event]);
        }

        //---------------------------------------------------------------------------------private
        private function createMovieBtn(btnAsset:DisplayObject):IButton
        {
            var btn:IButton = 
                new AbstractButton(btnAsset)
                    .context(BehaviorContext.ROLL_OVER_OUT)
                    .behave(ColorBehavior.createTint(RG_CREAM2, 1, null, RG_WHITE2));
            btn.addEventListener(MouseEvent.MOUSE_UP, buttonReleaseHandler);
            return btn;
        }

        private function initialize():void
        {
            StageReference.stage.removeEventListener(Event.RESIZE, layout);            StageReference.stage.addEventListener(Event.RESIZE, layout);
        	
            loaded = false;
            loadedPer = 0;	
        }

        private function createVideo():void
        {
            video = addChild(new SimpleFLVPlayer()) as SimpleFLVPlayer;
            video.addEventListener(VideoEvent.PLAYHEAD_UPDATE, onProgress);
            video.addEventListener(VideoEvent.COMPLETE, videoCompleteHandler);
            video.addEventListener("onSeekInvalid", onSeekInvalid);            video.addEventListener(MetadataEvent.METADATA_RECEIVED, metadataReceivedHandler);            video.addEventListener(VideoEvent.READY, function():void
            {
                layout();
            });
            video.addEventListener(Event.ENTER_FRAME, function():void
            {
            	var per:Number = updateLoadingBar(); 
            	trace("loading..", per);
                if(per == 1)
            	   video.removeEventListener(Event.ENTER_FRAME, arguments.callee);
            });
        }

        private function createInterface():void
        {
            btn_play = intf.addChild(createMovieBtn(intf.getChildByName("btn_play")) as DisplayObject) as IButton;
            btn_sound = intf.addChild(createMovieBtn(intf.getChildByName("btn_sound")) as DisplayObject) as IButton;
            playHead = intf.addChild(createPlayHead(intf.getChildByName("playHead")) as DisplayObject) as IButton;
        }

        private function createPlayHead(btnAsset:DisplayObject):IButton
        {
            var btn:IButton = 
                new AbstractButton(btnAsset)
                    .context(BehaviorContext.ROLL_OVER_OUT)
                    .behave(ColorBehavior.createTint(RG_CREAM2, 1, null, RG_WHITE2));
            btn.addEventListener(MouseEvent.MOUSE_DOWN, buttonDownHandler);
            StageReference.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);            return btn;
        }

        private function seek(playHeadX:Number):void
        {
            var w:Number = video.width;
            var x:Number = playHeadX;
            var per:Number = x / w;
            video.seek(per * video.duration);
        }

        private function updateProgressBar(time:Number, videoDuration:Number):void
        {
            var per:Number = time / videoDuration;
            if (isNaN(per))
                return;
                
            progressbar.scaleX = per;
        }

        private function updatePlayHead():void
        {
            if(!isSeeking)
                playHead.x = progressbar.x + DisplayObjectUtil.getRenderedWidth(progressbar);        }

        private function updateLoadingBar():Number
        {
            if(loaded)
                return 1;
		
            var l:Number = video.getBytesLoaded();
            var t:Number = video.getBytesTotal();
            loadedPer = l / t;
            loadedPer = (isNaN(loadedPer)) ? 0 : loadedPer;
            
            if(loadedPer >= 1)
            {
                loadingProgressbar.scaleX = 1;
                loaded = true;
            }
            else
            {
                loadingProgressbar.scaleX = loadedPer;
            }
            
            return loadedPer;
        }
    }
}