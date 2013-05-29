package com.imajuk.sounds
{
    import com.imajuk.logs.Logger;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
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
                    Logger.show(int(Worker.current.getSharedProperty("log")));
                    loadSound();
                }
                
            }, 1000 / 60);
            
        }

        private function loadSound() : void
        {
            Logger.info(1, "loading... " + soundURL + "");
            sound = new Sound();
            sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            sound.addEventListener(Event.COMPLETE, extractSound);
            sound.load(new URLRequest(soundURL));
        }

        private function onIOError(event : IOErrorEvent) : void
        {
            Worker.current.setSharedProperty("error_mes", event.text);
            Worker.current.setSharedProperty("error", true);
        }

        private function extractSound(...param) : void
        {
            Worker.current.setSharedProperty("duration", sound.length);
            
            sound.extract(shared, sound.length * 44100);
            
            reset();
            
            Logger.info(1, 'extract sound complete.');
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
