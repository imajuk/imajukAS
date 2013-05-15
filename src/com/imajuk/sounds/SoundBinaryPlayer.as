package com.imajuk.sounds
{
    import com.imajuk.logs.Logger;

    import flash.events.Event;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.ByteArray;
    /**
     * @author imajuk
     */
    public class SoundBinaryPlayer
    {
        private var sound : Sound;
        private var soundBinary : ByteArray;
        private var channel : SoundChannel;

        public function SoundBinaryPlayer()
        {
        }

        public function play(soundBinary : ByteArray) : void
        {
            Logger.info(0, "playing...", soundBinary.length);
            
            this.soundBinary = soundBinary;
            soundBinary.position = 0;

            sound = new Sound();
            sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
            
            channel  = sound.play();
            channel.addEventListener(Event.SOUND_COMPLETE, dispose);
        }

        public function dispose(...param) : void
        {
            channel.stop();
            if (sound)     sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
            if (channel) channel.removeEventListener(Event.SOUND_COMPLETE, dispose);

            soundBinary = null;
            sound = null;
            channel = null;
        }
        
        private function onSampleData(event : SampleDataEvent) : void
        {
            var left : Number;
            var right : Number;

            // We can add an arbitrary amount of new sample data to event.data, anywhere between 2048 and 8192.
            // Anything less than 2048, though, and the sound will play until the end and then stop!
            for (var i : int = 0; i < 2048; i++)
            {
                try
                {
                    // left channnel
                    left = soundBinary.readFloat();
                    event.data.writeFloat(left);

                    // right channnel
                    right = soundBinary.readFloat();
                    event.data.writeFloat(right);
                }
                catch(e : Error)
                {
                    break;
                    Logger.warning(e);
                    dispose();
                }
            }
        }
    }
}
