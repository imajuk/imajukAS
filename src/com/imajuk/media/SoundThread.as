package com.imajuk.media
{
    import com.imajuk.threads.ThreadUtil;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;

    /**
     * @author shinyamaharu
     */
    public class SoundThread extends Thread
    {
        private var channel : SoundChannel;
        private var progress : DisplayObject;
        private var sound : Sound;
        private var onComplete : Function;
        private var watingCompletion : WatchCompleteThread;

        public function SoundThread(soundURL:String, progress:DisplayObject, onComplete:Function = null)
        {
            super();
            
            this.sound = new Sound(new URLRequest(soundURL));   
            this.progress = progress;
            this.onComplete = onComplete;
        }

        override protected function run() : void
        {
            
            if (isInterrupted) return;
            
            channel = sound.play(0);
            
            watingCompletion = new WatchCompleteThread(channel, onComplete);
            watingCompletion.start();
            
            next(showProgress);
        }

        private function showProgress() : void
        {
            if (isInterrupted) return;
            
            progress.scaleX = channel.position / sound.length;
            
            next(showProgress);
        }


        override protected function finalize() : void
        {
            channel.stop();
            ThreadUtil.interrupt(watingCompletion);
        }
    }
}
import org.libspark.thread.Thread;

import flash.events.Event;
import flash.media.SoundChannel;


class WatchCompleteThread extends Thread
{
    private var snd : SoundChannel;
    private var callback : Function;

    public function WatchCompleteThread(snd : SoundChannel, callback:Function)
    {
        this.snd = snd;
        this.callback = callback;
    }
    
    override protected function run() : void
    {
        if (isInterrupted) return;
        interrupted(function():void{});

        event(snd, Event.SOUND_COMPLETE, function() : void
        {
            if (callback != null) callback();
        });
        
    }

    override protected function finalize() : void
    {
    }
}