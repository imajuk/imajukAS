package com.imajuk.sounds
{
    import org.libspark.thread.Thread;

    internal class SoundNormalizerThread extends Thread
    {
        private var callback : Function;
        private var soundData : SoundData;

        public function SoundNormalizerThread(soundData : SoundData, callback : Function)
        {
            this.soundData = soundData;
            this.callback = callback;
        }

        override protected function run() : void
        {
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
                callback(new SoundNormalizerEvent(SoundNormalizerEvent.COMPLETE, soundData));
        }
    }
}
