package com.imajuk.sounds.normalize
{
    import com.imajuk.logs.Logger;
    import com.imajuk.sounds.SoundBinaryPlayer;
    import com.imajuk.sounds.SoundNormalizer;
    import com.imajuk.sounds.SoundNormalizerEvent;

    import flash.display.Sprite;

    /**
     * @author imajuk
     */
    public class NormalizeExample extends Sprite
    {
        
        public function NormalizeExample()
        {
            Logger.show(Logger.INFO);
            
            //--------------------------------------------------------------------------
            //  IMPORTANT:
            //    SoundNormalizer uses Worker that is latest Flash tecnology.
            //    You need to compile your project with the compiler option 'swf-version=17'.
            //    The project will require the version Flash Player 11.4 or later.
            //
            //  Here's the example how to normilize and play the sound.
            //--------------------------------------------------------------------------
            SoundNormalizer.loadAndNormalize("http://imajuk.com/music.mp3");
            SoundNormalizer.addEventListener(SoundNormalizerEvent.COMPLETE, function(e : SoundNormalizerEvent) : void
            {
                //------------------------------------------------
                // the sound loaded and normalized.
                // you can play the binary with SoundBinaryPlayer.
                //------------------------------------------------
                const player:SoundBinaryPlayer = new SoundBinaryPlayer();
                player.play(e.soundData); 
                
                
                //------------------------------------------------
                // you can get the information of playing progress
                //------------------------------------------------
                trace('player.currentTime: ' + (player.currentTime));
                trace('player.totalTime: '   + (player.totalTime));
                
                //------------------------------------------------
                // also you can stop the sound like this.
                //------------------------------------------------
//                player.dispose();
            });
        }
    }
}
