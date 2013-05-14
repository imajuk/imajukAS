package com.imajuk.utils
{
    import flash.display.FrameLabel;
    import flash.display.MovieClip;

    /**
     * @author imajuk
     */
    public class MovieClipUtils
    {
        public static function getFrameFromLabel(mc : MovieClip, label : String) : int
        {
            var frame : int;

            mc.currentLabels.forEach(function(l : FrameLabel, ...param) : void
            {
                if (l.name == label)
                    frame = l.frame;
            });

            return frame;
        }
    }
}
