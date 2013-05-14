package com.imajuk.media
{
    import org.libspark.thread.Thread;    /**     * @author shinyamaharu     */    public class BufferWacherThread extends Thread     {
        private var video : SimpleFLVPlayer;        private var alert : IBufferingAlert;
        private var isBuffering : Boolean;

        public function BufferWacherThread(video : SimpleFLVPlayer, alert:IBufferingAlert)        {
            super();
            
            this.video = video;
            this.alert = alert;        }        override protected function run() : void        {            if (isInterrupted) return;                        if (!video)               return;                           if(video.isBuffering)            {
            	isBuffering = true;                var l : Number = video.bufferLength;                var t : Number = video.bufferTime;                var per:Number = l / t;                per = (isNaN(per)) ? 0 : per;
                
                alert.alertBuffering(l, t, per);
            }            else            {
            	if (isBuffering)
            	   alert.invisibleBufferingAlert();
            	   
            	isBuffering = false;            }                        next(run);        }                override protected function finalize() : void        {
        }    }}