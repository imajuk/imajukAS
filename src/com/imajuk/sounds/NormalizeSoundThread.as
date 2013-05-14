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
    public class NormalizeSoundThread extends Thread 
    {
        [Embed(source="normalizeWoker.swf", mimeType="application/octet-stream")] 
        private static var NormalizeWoker : Class;
        private static var worker : Worker;

        private var soundBinary : ByteArray;

        public function NormalizeSoundThread(soundBinary : ByteArray)
        {
            super();

            this.soundBinary = soundBinary;
        }

        override protected function run() : void
        {
            if (SoundNormalizer.isDebug) SoundNormalizer.resetDebugDisplay();
            
            next(extractSound);
        }

        private function extractSound() : void
        {
            next(createWorker);
        }

        private function createWorker() : void
        {
            worker = WorkerDomain.current.createWorker(new NormalizeWoker());
            event(worker, Event.WORKER_STATE, setupWorker);
            worker.start(); 
        }

        private function setupWorker(event:Event):void 
        { 
            if (worker.state == WorkerState.RUNNING) 
            { 
                worker.setSharedProperty("result", soundBinary);
                worker.setSharedProperty("complete", false);
                worker.setSharedProperty("debug", SoundNormalizer.getGraphicsData());
            } 

            next(waitWokersTask);
        }
        
        private function waitWokersTask() : void
        {
            if (!worker.getSharedProperty("complete"))
                next(waitWokersTask);
        }

        override protected function finalize() : void
        {
            if (SoundNormalizer.isDebug)
                SoundNormalizer.drawDebugDisplay();
        }
    }
}
