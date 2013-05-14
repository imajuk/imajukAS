package com.imajuk.sounds
{
    import flash.events.IOErrorEvent;
    import com.imajuk.logs.Logger;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.media.Sound;
    import flash.net.URLRequest;
    import flash.system.Worker;
    import flash.utils.ByteArray;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;

    /**
     * the main class for worker .swf
     * this must be compiled with parameter '-swf-version=17'
     * 
     * @author imajuk
     */
    public class SoundExtractWorkerMain extends Sprite
    {
        private var soundURL : String;
        private var sound : Sound;
        private var shared : ByteArray;
        
        public function SoundExtractWorkerMain()
        {
            Logger.show(Logger.INFO);
            
            reset();
            waitRequest();
        }

        private function waitRequest() : void
        {
            var interval : uint = setInterval(function() : void
            {
                shared   = Worker.current.getSharedProperty("soundBinary") as ByteArray;
                soundURL = Worker.current.getSharedProperty("soundURL");
                
                if (shared)
                {
                    clearInterval(interval);
                    loadSound();
                }
                
            }, 1000 / 60);
            
        }

        private function loadSound() : void
        {
            sound = new Sound();
            sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            sound.addEventListener(Event.COMPLETE, extractSound);
            sound.load(new URLRequest(soundURL));
        }

        private function onIOError(event : IOErrorEvent) : void
        {
            Logger.warning(event.text);
            Worker.current.setSharedProperty("error", true);
        }

        private function extractSound(...param) : void
        {
            sound.extract(shared, sound.length * 44100);
            
            reset();
            
            Logger.info(1, 'complete.');
            Worker.current.setSharedProperty("complete", true);
        }

        private function reset() : void
        {
            if (sound)
            {
                sound.removeEventListener(Event.COMPLETE, extractSound);
                sound.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            }
            sound    = null;
            shared   = null;
            soundURL = "";
            
        }
    }
}
