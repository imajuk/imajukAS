package com.imajuk.media
{
    import com.imajuk.utils.DisplayObjectUtil;
    import com.imajuk.utils.StageReference;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.events.MouseEvent;

    /**
     * @author shinyamaharu
     */
    public class VideoFullScreenThread extends Thread 
    {
        private var full : DisplayObject;
        private var stage : Stage;
        private var videoUI : IVideoUI;
        private var target : DisplayObjectContainer;

        public function VideoFullScreenThread(videoUI:IVideoUI, video:SimpleFLVPlayer)
        {
            super();
            this.full = videoUI.fullscreenUI;
            this.videoUI = videoUI;
            this.stage = StageReference.stage;
            this.target = video.parent;
        }

        override protected function run() : void
        {
            if (isInterrupted) return;
            interrupted(function():void{});
            
            event(full, MouseEvent.CLICK, function() : void
            {
                DisplayObjectUtil.fullScreen(target, stage, function():void{
                    target.parent.addChild(DisplayObject(videoUI));
                });
                next(run);
            });
        }

        override protected function finalize() : void
        {
        }
    }
}
