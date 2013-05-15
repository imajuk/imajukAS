package com.imajuk.sounds
{
    import org.libspark.thread.Thread;

    import flash.utils.ByteArray;

    internal class SoundNormalizerThread extends Thread
    {
        private var soundBinary : ByteArray;
        private var sound_url : String;
        private var callback : Function;

        public function SoundNormalizerThread(sound_url : String, soundBinary : ByteArray, callback : Function)
        {
            this.soundBinary = soundBinary;
            this.sound_url   = sound_url;
            this.callback    = callback;
        }

        override protected function run() : void
        {
            var t : Thread = new SoundExtractWorkerThread(soundBinary, sound_url);
            t.start();
            t.join(30000);

            next(normalize);
        }

        private function normalize() : void
        {
            var t : Thread = new NormalizeSoundWorkerThread(soundBinary);
            t.start();
            t.join();
        }

        override protected function finalize() : void
        {
            if (callback != null)
                callback(new SoundNormalizerEvent(SoundNormalizerEvent.COMPLETE, soundBinary));
        }
    }
}
