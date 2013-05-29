package com.imajuk.sounds
{
    import com.imajuk.logs.Logger;

    import org.libspark.thread.Thread;

    import flash.events.Event;
    import flash.system.Worker;
    import flash.system.WorkerDomain;
    import flash.system.WorkerState;

    /**
     * @author shinyamaharu
     */
    internal class SoundExtractWorkerThread extends Thread
    {
        [Embed(source="soundExtractWorker.swf", mimeType="application/octet-stream")] 
        private static var SoundExtractWorker : Class;
        private static var worker : Worker;
        
        private var soundData : SoundData;

        public function SoundExtractWorkerThread(soundData : SoundData)
        {
            super();
            this.soundData = soundData;
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
                worker.setSharedProperty("soundBinary", soundData.binary);
                worker.setSharedProperty("soundURL",    soundData.url);
                worker.setSharedProperty("complete",    false);
                worker.setSharedProperty("error",       false);
                worker.setSharedProperty("log",         Logger.currentFilter);
            } 

            next(waitWokersTask);
        }
        
        private function waitWokersTask() : void
        {
            if (worker.getSharedProperty("error"))
            {
                throw new Error(worker.getSharedProperty("error_mes"));
                return;
            }
            
            if (!worker.getSharedProperty("complete"))
                next(waitWokersTask);
        }

        override protected function finalize() : void
        {
            soundData._soundDuration = uint(worker.getSharedProperty("duration"));
        }
    }
}
