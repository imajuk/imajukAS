package com.imajuk.sounds
{
    import org.libspark.thread.Thread;

    import flash.events.Event;
    import flash.system.Worker;
    import flash.system.WorkerDomain;
    import flash.system.WorkerState;
    import flash.utils.ByteArray;

    /**
     * @author shinyamaharu
     */
    public class LoadSoundThread extends Thread
    {
        [Embed(source="soundExtractWorker.swf", mimeType="application/octet-stream")] 
        private static var SoundExtractWorker : Class;
        private static var worker : Worker;
        
        private var song_url : String;
        private var soundBinary : ByteArray;

        public function LoadSoundThread(soundBinary : ByteArray, song_url : String)
        {
            super();

            this.soundBinary = soundBinary;
            this.song_url = song_url;
        }

        override protected function run() : void
        {
            next(createWorker);
        }

        private function createWorker() : void
        {
            worker = WorkerDomain.current.createWorker(new SoundExtractWorker());
            event(worker, Event.WORKER_STATE, setupWorker);
            worker.start(); 
        }
        
        private function setupWorker(event:Event):void 
        { 
            if (worker.state == WorkerState.RUNNING) 
            { 
                worker.setSharedProperty("soundBinary", soundBinary);
                worker.setSharedProperty("soundURL", song_url);
                worker.setSharedProperty("complete", false);
                worker.setSharedProperty("error", false);
            } 

            next(waitWokersTask);
        }
        
        private function waitWokersTask() : void
        {
            if (worker.getSharedProperty("error"))
            {
                throw new Error();
                return;
            }
            
            if (!worker.getSharedProperty("complete"))
                next(waitWokersTask);
        }

        override protected function finalize() : void
        {
        }
    }
}
