package com.imajuk.sounds
{
    import flash.events.IOErrorEvent;
    import com.imajuk.logs.Logger;

    import org.libspark.thread.Thread;

    import flash.events.Event;

    internal class SoundNormalizerThread extends Thread
    {
        private var result : Event;
        private var callback : Function;
        private var soundData : SoundData;

        public function SoundNormalizerThread(soundData : SoundData, callback : Function)
        {
            this.soundData = soundData;
            this.callback = callback;
            result = new SoundNormalizerEvent(SoundNormalizerEvent.COMPLETE, soundData);
        }

        override protected function run() : void
        {
            error(Error, function(e:Error, at:Thread) : void
            {
                Logger.warning(e.message + " at " + at);
                result = new IOErrorEvent(IOErrorEvent.IO_ERROR);
            }, false, true);
            
            var t : Thread = new SoundExtractWorkerThread(soundData);
            t.start();
            t.join(30000);

            next(normalize);
        }

        private function normalize() : void
        {
            var t : Thread = new NormalizeSoundWorkerThread(soundData.binary);
            t.start();
            t.join();
        }

        override protected function finalize() : void
        {
            if (callback != null)
                callback(result);
        }
    }
}
